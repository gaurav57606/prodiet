import '../../../core/error/app_error.dart';
import '../domain/models/app_user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  final AppUser user;
  const AuthAuthenticated(this.user);
}

class AuthNeedsOnboarding extends AuthState {
  final AppUser user;
  const AuthNeedsOnboarding(this.user);
}

class AuthFailure extends AuthState {
  final AppError error;
  const AuthFailure(this.error);
}

/// Emitted when auth succeeds but the user profile row does not exist yet.
/// UI should show a "Setting up your account…" screen with a Retry button.
class AuthProfileMissing extends AuthState {
  final String userId;
  const AuthProfileMissing(this.userId);
}

