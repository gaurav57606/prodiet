import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import '../data/auth_repository.dart';
import '../domain/models/app_user.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';
export 'auth_state.dart';

// Auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseServiceProvider));
});

// Main auth state — THE single source of truth
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    fcm: ref.watch(fcmServiceProvider),
  );
});

// Convenience selectors
final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) return authState.user;
  if (authState is AuthNeedsOnboarding) return authState.user;
  return null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});

final isLoadingAuthProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthLoading;
});

/// Returns the current authenticated user's ID, or empty string if not
/// authenticated. Used by stream providers that require a userId.
final currentUserIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) return authState.user.id;
  if (authState is AuthNeedsOnboarding) return authState.user.id;
  return '';
});
