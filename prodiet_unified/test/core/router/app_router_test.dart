import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
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
  FakeAuthNotifier(this._mockState, AuthRepository repo) : super(repo);

  @override
  AuthState get state => _mockState;
  
  @override
  RemoveListener addListener(void Function(AuthState state) listener, {bool fireImmediately = true}) {
    if (fireImmediately) listener(_mockState);
    return () {};
  }
}

void main() {
  late MockBuildContext mockContext;
  late MockGoRouterState mockState;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockContext = MockBuildContext();
    mockState = MockGoRouterState();
    mockRepo = MockAuthRepository();
    
    // Stub methods that are called during AuthNotifier construction
    when(() => mockRepo.currentSession()).thenReturn(null);
    when(() => mockRepo.authStateChanges()).thenAnswer((_) => const Stream.empty());
  });

  group('AppRouter Redirect Logic', () {
    test('should redirect to / if theme not initialized', () {
      final container = ProviderContainer(overrides: [
        activeThemeInitializedProvider.overrideWith((ref) => false),
      ]);
      
      final result = redirectLogic(mockContext, mockState, container);
      expect(result, '/');
    });

    test('should redirect to T1 splash if at root and T1 active', () {
      when(() => mockState.matchedLocation).thenReturn('/');
      
      final container = ProviderContainer(overrides: [
        activeThemeInitializedProvider.overrideWith((ref) => true),
        activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t1Light)),
      ]);
      
      final result = redirectLogic(mockContext, mockState, container);
      expect(result, '/t1/splash');
    });

    test('should redirect to login if unauthenticated and at splash (T1)', () {
      when(() => mockState.matchedLocation).thenReturn('/t1/splash');
      
      final container = ProviderContainer(overrides: [
        activeThemeInitializedProvider.overrideWith((ref) => true),
        activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t1Light)),
        authProvider.overrideWith((ref) => FakeAuthNotifier(const AuthUnauthenticated(), mockRepo)),
      ]);
      
      final result = redirectLogic(mockContext, mockState, container);
      expect(result, '/t1/login');
    });

    test('should redirect to dashboard if authenticated and at login (T2)', () {
      when(() => mockState.matchedLocation).thenReturn('/t2/login');
      
      final user = AppUser(
        id: 'u1', email: 'u1@t.com', onboardingComplete: true, createdAt: DateTime.now());
      
      final container = ProviderContainer(overrides: [
        activeThemeInitializedProvider.overrideWith((ref) => true),
        activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t2Dark)),
        authProvider.overrideWith((ref) => FakeAuthNotifier(AuthAuthenticated(user), mockRepo)),
      ]);
      
      final result = redirectLogic(mockContext, mockState, container);
      expect(result, '/t2/dashboard');
    });
  });
}
