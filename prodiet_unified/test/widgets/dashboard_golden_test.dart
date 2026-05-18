import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:prodiet_unified/core/theme/app_theme.dart';
import 'package:prodiet_unified/core/theme/t1/t1_tokens.dart';
import 'package:prodiet_unified/core/theme/t2/t2_tokens.dart';

class FakeActiveThemeNotifier extends ActiveThemeNotifier {
  final ActiveTheme _mockState;
  FakeActiveThemeNotifier(this._mockState);
  @override
  ActiveTheme build() => _mockState;
}

class FakeActiveThemeInitializedNotifier extends ActiveThemeInitializedNotifier {
  @override
  bool build() => true;
}

class FakeDashboard extends Dashboard {
  final DashboardSummary _summary;
  FakeDashboard(this._summary);

  @override
  FutureOr<DashboardSummary> build() => _summary;
}

// Robust mock for AuthRepository to satisfy AuthNotifier constructor
class MockAuthRepository extends Mock implements AuthRepository {}
class MockFcmService extends Mock implements FcmService {}

class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier(super.repo, {super.fcm, AuthState initialState = const AuthLoading()}) 
    : super(skipInit: true) {
    state = initialState;
  }
}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Mock path_provider for GoogleFonts
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (methodCall) async {
      return '.';
    });

    // Disable fetching - our themes are now test-aware and will fall back
    GoogleFonts.config.allowRuntimeFetching = false;
    
    registerFallbackValue(const AuthLoading());
  });

  group('Dashboard Golden Tests', () {
    const summary = DashboardSummary(
      userName: 'Alex',
      caloriesGoal: 2000,
      caloriesConsumed: 1200,
      proteinGoal: 150,
      proteinConsumed: 80,
      carbsGoal: 200,
      carbsConsumed: 150,
      fatGoal: 60,
      fatConsumed: 40,
      waterGoalMl: 2500,
      waterMl: 1500,
      mealsToday: 2,
      mealsScheduled: 4,
      streakDays: 5,
      stepsToday: 8420,
      caloriesBurned: 312,
    );

    final testUser = AppUser(
      id: 'test-123',
      email: 'test@example.com',
      name: 'Alex',
      createdAt: DateTime.now(),
    );

    final authState = AuthAuthenticated(testUser);

    testWidgets('T1 Light Theme Dashboard Golden', (tester) async {
      // Set size directly on the view
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockRepo = MockAuthRepository();
      when(() => mockRepo.authStateChanges()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.currentSession()).thenReturn(null);

      final mockAuth = TestAuthNotifier(mockRepo, initialState: authState);
      final mockAnalytics = MockAnalyticsService();
      when(() => mockAnalytics.logScreen(any())).thenAnswer((_) async => {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t1Light)),
            activeThemeInitializedProvider.overrideWith(() => FakeActiveThemeInitializedNotifier()),
            authProvider.overrideWith((ref) => mockAuth),
            dashboardProvider.overrideWith(() => FakeDashboard(summary)),
            analyticsServiceProvider.overrideWithValue(mockAnalytics),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.buildTheme(T1Tokens.light, Brightness.light),
            home: const DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(DashboardScreen), matchesGoldenFile('goldens/dashboard_t1_light.png'));
    });

    testWidgets('T2 Dark Theme Dashboard Golden', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockRepo = MockAuthRepository();
      when(() => mockRepo.authStateChanges()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.currentSession()).thenReturn(null);

      final mockAuth = TestAuthNotifier(mockRepo, initialState: authState);
      final mockAnalytics = MockAnalyticsService();
      when(() => mockAnalytics.logScreen(any())).thenAnswer((_) async => {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t2Dark)),
            activeThemeInitializedProvider.overrideWith(() => FakeActiveThemeInitializedNotifier()),
            authProvider.overrideWith((ref) => mockAuth),
            dashboardProvider.overrideWith(() => FakeDashboard(summary)),
            analyticsServiceProvider.overrideWithValue(mockAnalytics),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.buildTheme(T2Tokens.dark, Brightness.dark),
            home: const DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(DashboardScreen), matchesGoldenFile('goldens/dashboard_t2_dark.png'));
    });
  });
}
