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

  AuthNotifier(this._repo, {FcmService? fcm, bool skipInit = false})
      : _fcm = fcm,
        super(const AuthLoading()) {
    addListener((state) {
      logger.i('[$_tag] State changed to: $state');
    });
    if (!skipInit) _init();
  }

  void _init() {
    _authSubscription?.cancel();
    logger.i('[$_tag] Initializing AuthNotifier...');

    // Wrap in microtask to ensure listeners are ready
    Future.microtask(() async {
      try {
        logger.d('[$_tag] Checking session...');
        final existingSession = _repo.currentSession();
        if (existingSession != null) {
          logger.i('[$_tag] Existing session found for ${existingSession.user.id}');
          await _handleSession(existingSession.user.id);
          if (!mounted) return;
        } else {
          logger.i('[$_tag] No existing session found');
          state = const AuthUnauthenticated();
        }
      } catch (e, st) {
        if (!mounted) return;
        logger.e('[$_tag] Init error: $e', error: e, stackTrace: st);
        state = AuthFailure(ErrorHandler.handle(e, context: '$_tag._init'));
      }
    });

    // Still subscribe for future changes
    _authSubscription = _repo.authStateChanges().listen((data) async {
      final session = data.session;
      logger.i('[$_tag] Auth state change detected. Event: ${data.event}, Session: ${session?.user.id}');
      if (session == null) {
        state = const AuthUnauthenticated();
      } else {
        await _handleSession(session.user.id);
        if (!mounted) return;
      }
    });
  }

  Future<void> _handleSession(String userId) async {
    try {
      logger.d('[$_tag] Fetching profile for $userId...');
      
      // Try fetching the profile.
      var profile = await _repo.fetchProfile(userId).timeout(
        const Duration(seconds: 5), // Reduced timeout for faster failover
        onTimeout: () {
          logger.e('[$_tag] Profile fetch timed out for $userId');
          throw TimeoutException('Profile fetch timed out');
        },
      );
      
      if (!mounted) return;

      // If missing, it might be a race condition with DB triggers.
      // We'll do one very short wait if it's the absolute first time we see this user.
      if (profile == null) {
        logger.w('[$_tag] Profile null for $userId, waiting briefly for DB trigger...');
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        profile = await _repo.fetchProfile(userId);
      }

      if (profile == null) {
        logger.w('[$_tag] Profile still missing for $userId. Moving to AuthProfileMissing state.');
        state = AuthProfileMissing(userId);
        return;
      }

      logger.d('[$_tag] Profile loaded successfully for ${profile.email}');
      _handleProfile(profile);
    } catch (e) {
      if (!mounted) return;
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
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.signIn'));
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      state = const AuthLoading();
      await _repo.signUpWithEmail(email, password, name);
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.signUp'));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const AuthLoading();
      await _repo.signInWithGoogle();
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.signInWithGoogle'));
    }
  }

  Future<void> signOut() async {
    try {
      await _repo.signOut();
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      logger.e('[$_tag] signOut error: $e');
    }
  }

  /// Called from the UI "Retry" button when state is AuthProfileMissing.
  /// Uses an exponential backoff strategy to wait for profile creation.
  Future<void> retryProfileLoad(String userId) async {
    state = const AuthLoading();
    final backoff = [500, 1000, 2000, 4000, 8000];
    
    for (int i = 0; i < backoff.length; i++) {
      await Future.delayed(Duration(milliseconds: backoff[i]));
      if (!mounted) return;
      
      try {
        final profile = await _repo.fetchProfile(userId);
        if (!mounted) return;
        
        if (profile != null) {
          _handleProfile(profile);
          return;
        }
        logger.w('[$_tag] retryProfileLoad attempt ${i + 1} — profile still null');
      } catch (e) {
        if (!mounted) return;
        logger.e('[$_tag] retryProfileLoad error on attempt ${i + 1}: $e');
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
      // Do NOT set state here. Screen shows success message locally.
    } catch (e) {
      if (!mounted) return;
      state = AuthFailure(ErrorHandler.handle(e, context: '$_tag.sendPasswordReset'));
    }
  }

  Future<void> completeOnboarding(String userId, Map<String, dynamic> profileData) async {
    try {
      state = const AuthLoading();
      await _repo.updateProfile(userId, {
        ...profileData,
        'onboarding_complete': true,
      });
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      final updatedProfile = await _repo.fetchProfile(userId);
      if (!mounted) return;
      if (updatedProfile != null) {
        state = AuthAuthenticated(updatedProfile);
      } else {
        state = const AuthFailure(UnknownError(
          message: 'Could not load your profile after setup. Please restart the app.',
        ));
      }
    } catch (e) {
      if (!mounted) return;
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
