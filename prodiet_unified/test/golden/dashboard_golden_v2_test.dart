import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/dashboard_screen.dart' as t1;
import 'package:prodiet_unified/features/dashboard/t2/presentation/screens/dashboard_screen.dart' as t2;
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';

class FakeActiveThemeNotifier extends ActiveThemeNotifier {
  final ActiveTheme _mockState;
  FakeActiveThemeNotifier(this._mockState);
  @override
  ActiveTheme build() => _mockState;
}

// Robust mock for AuthRepository to satisfy AuthNotifier constructor
class MockAuthRepository extends Mock implements AuthRepository {}
class MockFcmService extends Mock implements FcmService {}

class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier(AuthRepository repo, {FcmService? fcm, AuthState initialState = const AuthLoading()}) 
    : super(repo, fcm: fcm, skipInit: true) {
    state = initialState;
  }

  void setTestState(AuthState newState) {
    state = newState;
  }
}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((methodCall) async {
      return '.';
    });

    GoogleFonts.config.allowRuntimeFetching = true;
    registerFallbackValue(const AuthLoading());
  });

  group('Dashboard Golden Tests V2', () {
    // ... summary and testUser definitions ...
    final summary = DashboardSummary(
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

    testWidgets('T1 Light Theme Dashboard Golden V2', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRepo = MockAuthRepository();
      when(() => mockRepo.authStateChanges()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.currentSession()).thenReturn(null);

      final mockAuth = TestAuthNotifier(mockRepo, initialState: authState);
      final mockAnalytics = MockAnalyticsService();
      when(() => mockAnalytics.logScreen(any(), any())).thenAnswer((_) async => {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t1Light)),
            authProvider.overrideWith((ref) => mockAuth),
            dashboardProvider.overrideWith((ref) => summary),
            analyticsServiceProvider.overrideWithValue(mockAnalytics),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: t1.DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(t1.DashboardScreen), matchesGoldenFile('goldens/dashboard_t1_light_v2.png'));
    });

    testWidgets('T2 Dark Theme Dashboard Golden V2', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRepo = MockAuthRepository();
      when(() => mockRepo.authStateChanges()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.currentSession()).thenReturn(null);

      final mockAuth = TestAuthNotifier(mockRepo, initialState: authState);
      final mockAnalytics = MockAnalyticsService();
      when(() => mockAnalytics.logScreen(any(), any())).thenAnswer((_) async => {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t2Dark)),
            authProvider.overrideWith((ref) => mockAuth),
            dashboardProvider.overrideWith((ref) => summary),
            analyticsServiceProvider.overrideWithValue(mockAnalytics),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: t2.DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(t2.DashboardScreen), matchesGoldenFile('goldens/dashboard_t2_dark_v2.png'));
    });
  });
}
