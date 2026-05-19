import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/app/navigation_state.dart';
import 'package:prodiet_unified/app/bootstrap_screen.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';

AppUser dummyUser() => AppUser(
      id: '1',
      name: 'John',
      email: 'john@example.com',
      onboardingComplete: true,
      createdAt: DateTime.now(),
    );

class MockAuthRepository extends Mock implements AuthRepository {}

class MockActiveThemeInitializedNotifier extends ActiveThemeInitializedNotifier {
  final bool initialValue;
  MockActiveThemeInitializedNotifier(this.initialValue);

  @override
  bool build() => initialValue;
}

class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(AuthState initialState)
      : super(MockAuthRepository(), skipInit: true) {
    state = initialState;
  }
}

void main() {
  test('navigationStateProvider computes bootstrapping when bootstrap or activeTheme is not ready', () {
    final container = ProviderContainer(
      overrides: [
        bootstrapStateProvider.overrideWith((ref) => BootstrapState.loading),
        activeThemeInitializedProvider.overrideWith(() => MockActiveThemeInitializedNotifier(false)),
        authProvider.overrideWith((ref) => MockAuthNotifier(const AuthLoading())),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(navigationStateProvider), AppNavigationState.bootstrapping);
  });

  test('navigationStateProvider computes unauthenticated when authState is AuthUnauthenticated', () {
    final container = ProviderContainer(
      overrides: [
        bootstrapStateProvider.overrideWith((ref) => BootstrapState.ready),
        activeThemeInitializedProvider.overrideWith(() => MockActiveThemeInitializedNotifier(true)),
        authProvider.overrideWith((ref) => MockAuthNotifier(const AuthUnauthenticated())),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(navigationStateProvider), AppNavigationState.unauthenticated);
  });

  test('navigationStateProvider computes onboarding when authState is AuthNeedsOnboarding', () {
    final container = ProviderContainer(
      overrides: [
        bootstrapStateProvider.overrideWith((ref) => BootstrapState.ready),
        activeThemeInitializedProvider.overrideWith(() => MockActiveThemeInitializedNotifier(true)),
        authProvider.overrideWith((ref) => MockAuthNotifier(AuthNeedsOnboarding(dummyUser()))),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(navigationStateProvider), AppNavigationState.onboarding);
  });

  test('navigationStateProvider computes authenticated when authState is AuthAuthenticated', () {
    final container = ProviderContainer(
      overrides: [
        bootstrapStateProvider.overrideWith((ref) => BootstrapState.ready),
        activeThemeInitializedProvider.overrideWith(() => MockActiveThemeInitializedNotifier(true)),
        authProvider.overrideWith((ref) => MockAuthNotifier(AuthAuthenticated(dummyUser()))),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(navigationStateProvider), AppNavigationState.authenticated);
  });
}
