import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/error/app_error.dart';

import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';

class MockBuildContext extends Mock implements BuildContext {}
class MockGoRouterState extends Mock implements GoRouterState {}
class MockAuthRepository extends Mock implements AuthRepository {}

class FakeActiveThemeNotifier extends ActiveThemeNotifier {
  final ActiveTheme _mockState;
  FakeActiveThemeNotifier(this._mockState);
  @override
  ActiveTheme build() => _mockState;
}

class FakeAuthNotifier extends AuthNotifier {
  final AuthState _mockState;
  FakeAuthNotifier(this._mockState, AuthRepository repo) : super(repo, skipInit: true);

  @override
  AuthState get state => _mockState;

  @override
  RemoveListener addListener(
    void Function(AuthState state) listener, {
    bool fireImmediately = true,
  }) {
    if (fireImmediately) listener(_mockState);
    return () {};
  }
}

/// Builds a fully-overridden ProviderContainer for router redirect tests.
ProviderContainer _buildContainer({
  required bool themeInitialized,
  ActiveTheme theme = ActiveTheme.t1Light,
  AuthState authState = const AuthUnauthenticated(),
  required MockAuthRepository mockRepo,
}) {
  return ProviderContainer(overrides: [
    activeThemeInitializedProvider.overrideWith((ref) => themeInitialized),
    activeThemeProvider
        .overrideWith(() => FakeActiveThemeNotifier(theme)),
    authProvider
        .overrideWith((ref) => FakeAuthNotifier(authState, mockRepo)),
  ]);
}

void main() {
  late MockBuildContext mockContext;
  late MockGoRouterState mockState;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockContext = MockBuildContext();
    mockState   = MockGoRouterState();
    mockRepo    = MockAuthRepository();

    // REQUIRED: FakeAuthNotifier calls super() which fires _init()
    // inside AuthNotifier constructor — these stubs must be present.
    when(() => mockRepo.currentSession()).thenReturn(null);
    when(() => mockRepo.authStateChanges())
        .thenAnswer((_) => const Stream.empty());
  });

  // ─────────────────────────────────────────────────────────
  // THEME GUARD
  // ─────────────────────────────────────────────────────────
  group('AppRouter — Theme guard', () {
    test('redirects to / when theme not yet initialized', () {
      final container = _buildContainer(
        themeInitialized: false,
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container), '/');
    });
  });

  // ─────────────────────────────────────────────────────────
  // ROOT REDIRECT
  // ─────────────────────────────────────────────────────────
  group('AppRouter — Root redirect', () {
    test('redirects / → /t1/splash when T1 theme active', () {
      when(() => mockState.matchedLocation).thenReturn('/');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container), '/t1/splash');
    });

    test('redirects / → /t2/splash when T2 theme active', () {
      when(() => mockState.matchedLocation).thenReturn('/');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t2Dark,
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container), '/t2/splash');
    });
  });

  // ─────────────────────────────────────────────────────────
  // UNAUTHENTICATED REDIRECTS
  // ─────────────────────────────────────────────────────────
  group('AppRouter — Unauthenticated redirects', () {
    test('T1: splash → /t1/login when unauthenticated', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/splash');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: const AuthUnauthenticated(),
        mockRepo: mockRepo,
      );
      expect(
          redirectLogic(mockContext, mockState, container), '/t1/login');
    });

    test('T2: splash → /t2/login when unauthenticated', () {
      when(() => mockState.matchedLocation).thenReturn('/t2/splash');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t2Dark,
        authState: const AuthUnauthenticated(),
        mockRepo: mockRepo,
      );
      expect(
          redirectLogic(mockContext, mockState, container), '/t2/login');
    });
  });

  // ─────────────────────────────────────────────────────────
  // AUTHENTICATED REDIRECTS
  // ─────────────────────────────────────────────────────────
  group('AppRouter — Authenticated redirects', () {
    AppUser makeUser(String id) => AppUser(
          id: id,
          email: '$id@t.com',
          onboardingComplete: true,
          createdAt: DateTime(2026),
        );

    test('T1: /t1/login → /t1/dashboard when authenticated', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/login');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: AuthAuthenticated(makeUser('u1')),
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container),
          '/t1/dashboard');
    });

    test('T2: /t2/login → /t2/dashboard when authenticated', () {
      when(() => mockState.matchedLocation).thenReturn('/t2/login');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t2Dark,
        authState: AuthAuthenticated(makeUser('u2')),
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container),
          '/t2/dashboard');
    });

    test('no redirect when already on dashboard + authenticated', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/dashboard');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: AuthAuthenticated(makeUser('u1')),
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────
  // ONBOARDING REDIRECT
  // ─────────────────────────────────────────────────────────
  group('AppRouter — Onboarding redirect', () {
    test('T1: redirects to /t1/health-goals when NeedsOnboarding', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/splash');
      final user = AppUser(
        id: 'u1',
        email: 'u@t.com',
        onboardingComplete: false,
        createdAt: DateTime(2026),
      );
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: AuthNeedsOnboarding(user),
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container),
          contains('health-goals'));
    });
  });

  // ─────────────────────────────────────────────────────────
  // AUTH FAILURE REDIRECT
  // ─────────────────────────────────────────────────────────
  group('AppRouter — AuthFailure redirect', () {
    test('redirects to splash on AuthFailure', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/dashboard');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: const AuthFailure(UnknownError(message: 'Session expired')),
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container),
          contains('splash'));
    });
  });

  // ─────────────────────────────────────────────────────────
  // AUTH LOADING — NO REDIRECT
  // ─────────────────────────────────────────────────────────
  group('AppRouter — AuthLoading', () {
    test('does not redirect away from splash during AuthLoading', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/splash');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: const AuthLoading(),
        mockRepo: mockRepo,
      );
      expect(redirectLogic(mockContext, mockState, container), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────
  // AUTH PROFILE MISSING REDIRECT
  // ─────────────────────────────────────────────────────────
  group('AppRouter — AuthProfileMissing redirect', () {
    test('redirects to profile-retry route on AuthProfileMissing', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/dashboard');
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: const AuthProfileMissing('u1'),
        mockRepo: mockRepo,
      );
      final result = redirectLogic(mockContext, mockState, container);
      expect(result, AppRoutes.t2ProfileRetry);
    });

    test('does NOT redirect if already on profile-retry screen (prevents loop)', () {
      when(() => mockState.matchedLocation).thenReturn(AppRoutes.t2ProfileRetry);
      final container = _buildContainer(
        themeInitialized: true,
        theme: ActiveTheme.t1Light,
        authState: const AuthProfileMissing('u1'),
        mockRepo: mockRepo,
      );
      final result = redirectLogic(mockContext, mockState, container);
      expect(result, isNull);
    });
  });
}
