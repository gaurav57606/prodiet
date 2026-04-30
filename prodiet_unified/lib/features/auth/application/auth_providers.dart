import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../data/auth_repository.dart';
import '../domain/models/app_user.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// Supabase client — single instance for entire app
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
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
  return ref.watch(authProvider.notifier).currentUser;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});

final isLoadingAuthProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthLoading;
});
