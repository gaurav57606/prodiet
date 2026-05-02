import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import '../../../main.dart'; // for logger
import '../../../core/error/error_handler.dart';
import '../data/auth_repository.dart';
import '../domain/models/app_user.dart';
import 'auth_state.dart';
import '../../../core/error/app_error.dart';


class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final FcmService? _fcm;
  static const _tag = 'AuthNotifier';
  StreamSubscription? _authSubscription;

  AuthNotifier(this._repo, {FcmService? fcm})
      : _fcm = fcm,
        super(const AuthLoading()) {
    _init();
  }

  void _init() {
    _authSubscription?.cancel();

    // Check current session IMMEDIATELY — onAuthStateChange only fires on changes,
    // not on the current state. Without this, a returning user stays AuthLoading forever.
    final existingSession = _repo.currentSession();
    if (existingSession != null) {
      _handleSession(existingSession.user.id);
    } else {
      state = const AuthUnauthenticated();
    }

    // Still subscribe for future changes (sign-in, sign-out, token refresh)
    _authSubscription = _repo.authStateChanges().listen((data) async {
      final session = data.session;
      if (session == null) {
        state = const AuthUnauthenticated();
      } else {
        await _handleSession(session.user.id);
      }
    });
  }

  Future<void> _handleSession(String userId) async {
    try {
      final profile = await _repo.fetchProfile(userId);
      if (profile == null) {
        // Profile row not yet created (DB trigger may be delayed).
        // Emit AuthProfileMissing so the UI can show a retry option.
        state = AuthProfileMissing(userId);
        return;
      }
      _handleProfile(profile);
    } catch (e) {
      logger.e('[$_tag] _handleSession error: $e');
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag._handleSession'));
    }
  }

  void _handleProfile(AppUser profile) {
    if (profile.onboardingComplete) {
      state = AuthAuthenticated(profile);
      _fcm?.initialize(profile.id).catchError((e) {
        logger.w('[$_tag] FCM init failed: $e');
      });
    } else {
      state = AuthNeedsOnboarding(profile);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = const AuthLoading();
      await _repo.signInWithEmail(email, password);
    } catch (e) {
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.signIn'));
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      state = const AuthLoading();
      await _repo.signUpWithEmail(email, password, name);
    } catch (e) {
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.signUp'));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const AuthLoading();
      await _repo.signInWithGoogle();
    } catch (e) {
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.signInWithGoogle'));
    }
  }

  Future<void> signOut() async {
    try {
      await _repo.signOut();
    } catch (e) {
      logger.e('[$_tag] signOut error: $e');
    }
  }

  /// Called from the UI "Retry" button when state is AuthProfileMissing.
  /// Polls up to 5 times with 1.5s delay before giving up.
  Future<void> retryProfileLoad(String userId) async {
    state = const AuthLoading();
    for (int attempt = 1; attempt <= 5; attempt++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      try {
        final profile = await _repo.fetchProfile(userId);
        if (profile != null) {
          _handleProfile(profile);
          return;
        }
        logger.w('[$_tag] retryProfileLoad attempt $attempt — profile still null');
      } catch (e) {
        logger.e('[$_tag] retryProfileLoad error on attempt $attempt: $e');
      }
    }
    // Exhausted all retries — emit a descriptive failure
    state = const AuthFailure(UnknownError(
      message: 'Could not load your profile. Please check your connection and try again.',
    ));
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _repo.sendPasswordReset(email);
    } catch (e) {
      logger.e('[$_tag] resetPassword error: $e');
    }
  }

  Future<void> completeOnboarding(
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      state = const AuthLoading();
      await _repo.updateProfile(userId, {
        ...profileData,
        'onboarding_complete': true,
      });
      // The auth listener will pick up the change if we refetch or if we manually update state
      final updatedProfile = await _repo.fetchProfile(userId);
      if (updatedProfile != null) {
        state = AuthAuthenticated(updatedProfile);
      }
    } catch (e) {
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.completeOnboarding'));
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  AppUser? get currentUser {
    final s = state;
    if (s is AuthAuthenticated) return s.user;
    if (s is AuthNeedsOnboarding) return s.user;
    return null;
  }
}

