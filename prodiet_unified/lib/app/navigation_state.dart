import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/app/bootstrap_screen.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';

enum AppNavigationState {
  bootstrapping,
  unauthenticatedSplash,
  unauthenticated,
  onboarding,
  profileMissing,
  authenticated,
}

final navigationStateProvider = Provider<AppNavigationState>((ref) {
  final bootstrapState = ref.watch(bootstrapStateProvider);
  final activeThemeInitialized = ref.watch(activeThemeInitializedProvider);
  
  if (bootstrapState != BootstrapState.ready || !activeThemeInitialized) {
    return AppNavigationState.bootstrapping;
  }
  
  final authState = ref.watch(authProvider);
  
  if (authState is AuthLoading) {
    return AppNavigationState.unauthenticatedSplash;
  }
  if (authState is AuthFailure) {
    return AppNavigationState.unauthenticatedSplash;
  }
  if (authState is AuthUnauthenticated) {
    return AppNavigationState.unauthenticated;
  }
  if (authState is AuthProfileMissing) {
    return AppNavigationState.profileMissing;
  }
  if (authState is AuthNeedsOnboarding) {
    return AppNavigationState.onboarding;
  }
  if (authState is AuthAuthenticated) {
    return AppNavigationState.authenticated;
  }
  
  return AppNavigationState.bootstrapping;
});
