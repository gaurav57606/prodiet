import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart'; // for logger
import '../../../core/error/error_handler.dart';
import '../data/auth_repository.dart';
import '../domain/models/app_user.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  static const _tag = 'AuthNotifier';
  StreamSubscription? _authSubscription;

  AuthNotifier(this._repo) : super(const AuthLoading()) {
    _init();
  }

  void _init() {
    _authSubscription?.cancel();
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
        // Profile not created yet (happens right after signup before trigger)
        // Or if trigger fails. We'll wait or assume onboarding needed.
        state = const AuthLoading();
        // Give trigger a moment or retry
        await Future.delayed(const Duration(seconds: 1));
        final retryProfile = await _repo.fetchProfile(userId);
        if (retryProfile == null) {
          // If still null, we might need to manually create or show error
          state = const AuthUnauthenticated();
          return;
        }
        _handleProfile(retryProfile);
      } else {
        _handleProfile(profile);
      }
    } catch (e) {
      logger.e('[$_tag] _handleSession error: $e');
      state = const AuthUnauthenticated();
    }
  }

  void _handleProfile(AppUser profile) {
    if (profile.onboardingComplete) {
      state = AuthAuthenticated(profile);
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

