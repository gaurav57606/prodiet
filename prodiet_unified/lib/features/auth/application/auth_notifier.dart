import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart'; // for logger
import '../data/auth_repository.dart';
import '../domain/models/app_user.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  static const _tag = 'AuthNotifier';

  AuthNotifier(this._repo) : super(const AuthLoading()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final result = await _repo.getSessionUser();
    result.fold(
      (error) {
        logger.w('[$_tag] Session restore failed: ${error.message}');
        state = const AuthUnauthenticated();
      },
      (user) {
        if (user == null) {
          state = const AuthUnauthenticated();
        } else if (!user.onboardingComplete) {
          state = AuthNeedsOnboarding(user);
        } else {
          state = AuthAuthenticated(user);
        }
      },
    );
  }

  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    final result = await _repo.signIn(email: email, password: password);
    result.fold(
      (error) => state = AuthFailure(error),
      (user) {
        if (!user.onboardingComplete) {
          state = AuthNeedsOnboarding(user);
        } else {
          state = AuthAuthenticated(user);
        }
      },
    );
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AuthLoading();
    final result = await _repo.signUp(email: email, password: password, name: name);
    result.fold(
      (error) => state = AuthFailure(error),
      (user) => state = AuthNeedsOnboarding(user),
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthUnauthenticated();
  }

  Future<void> sendPasswordReset(String email) async {
    await _repo.sendPasswordReset(email);
  }

  Future<void> completeOnboarding(
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    final result = await _repo.updateProfile(userId, {
      ...profileData,
      'onboarding_complete': true,
    });
    result.fold(
      (error) => state = AuthFailure(error),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> refreshUser() async {
    final user = currentUser;
    if (user == null) return;

    final result = await _repo.getSessionUser();
    result.fold(
      (error) => null, // Keep existing state on refresh error
      (updatedUser) {
        if (updatedUser != null) {
          if (updatedUser.onboardingComplete) {
            state = AuthAuthenticated(updatedUser);
          } else {
            state = AuthNeedsOnboarding(updatedUser);
          }
        }
      },
    );
  }

  AppUser? get currentUser {
    final s = state;
    if (s is AuthAuthenticated) return s.user;
    if (s is AuthNeedsOnboarding) return s.user;
    return null;
  }
}
