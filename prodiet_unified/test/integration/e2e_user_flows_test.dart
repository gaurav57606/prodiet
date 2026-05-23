import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:prodiet_unified/app/app.dart';
import 'package:prodiet_unified/app/bootstrap_screen.dart';
import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/meal_planner/data/meal_repository.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:prodiet_unified/core/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'dart:async';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockMealRepository extends Mock implements MealRepository {}
class MockAnalyticsService extends Mock implements AnalyticsService {}
class MockFcmService extends Mock implements FcmService {}
class MockConnectivityNotifier extends ConnectivityNotifier {
  @override
  Future<ConnectivityStatus> build() async => ConnectivityStatus.online;
}

class MockDashboard extends Dashboard {
  final DashboardSummary summary;
  MockDashboard(this.summary);

  @override
  FutureOr<DashboardSummary> build() async => summary;
}

class MockActiveThemeInitializedNotifier extends ActiveThemeInitializedNotifier {
  @override
  bool build() => true;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Mock path_provider for google_fonts
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
        return '.';
      });

  // Mock connectivity checking method channel
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall methodCall) async {
        if (methodCall.method == 'check') {
          return ['wifi'];
        }
        return null;
      });

  // Mock connectivity status stream event channel
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity_status'),
          (MethodCall methodCall) async {
        if (methodCall.method == 'listen') {
          return null;
        }
        if (methodCall.method == 'cancel') {
          return null;
        }
        return null;
      });

  group('Multi-Step End-to-End Integration Flow', () {
    late MockAuthRepository mockAuthRepo;
    late MockMealRepository mockMealRepo;
    late MockAnalyticsService mockAnalytics;
    late MockFcmService mockFcm;
    late SharedPreferences prefs;

    final testUser = AppUser(
      id: 'u123',
      name: 'Dr. Gaurav',
      email: 'gaurav@prodiet.com',
      onboardingComplete: true,
      createdAt: DateTime.now(),
    );

    const summary = DashboardSummary(
      userName: 'Dr. Gaurav',
      caloriesConsumed: 1200,
      caloriesGoal: 2500,
      waterMl: 1000,
      waterGoalMl: 3000,
      proteinConsumed: 90,
      carbsConsumed: 150,
      fatConsumed: 40,
      proteinGoal: 150,
      carbsGoal: 250,
      fatGoal: 80,
      mealsToday: 2,
      mealsScheduled: 5,
      streakDays: 14,
      stepsToday: 8000,
      caloriesBurned: 450,
    );

    supabase.Session makeSession(String userId, String email) {
      return supabase.Session(
        accessToken: 'tok_$userId',
        tokenType: 'bearer',
        user: supabase.User(
          id: userId,
          email: email,
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      mockAuthRepo = MockAuthRepository();
      mockMealRepo = MockMealRepository();
      mockAnalytics = MockAnalyticsService();
      mockFcm = MockFcmService();

      // Stub Analytics
      when(() => mockAnalytics.startSession(any(),
          deviceModel: any(named: 'deviceModel'),
          osVersion: any(named: 'osVersion'),
          appVersion: any(named: 'appVersion'))).thenAnswer((_) => Future<void>.value());
      when(() => mockAnalytics.endSession(any())).thenAnswer((_) => Future<void>.value());
      when(() => mockAnalytics.logScreen(any())).thenAnswer((_) => Future<void>.value());
      when(() => mockAnalytics.logEvent(any(), parameters: any(named: 'parameters'))).thenAnswer((_) => Future<void>.value());

      // Stub FCM
      when(() => mockFcm.initialize(any())).thenAnswer((_) => Future<void>.value());

      final session = makeSession('u123', 'gaurav@prodiet.com');
      final authStreamController = StreamController<supabase.AuthState>.broadcast();

      when(() => mockAuthRepo.authStateChanges())
          .thenAnswer((_) => authStreamController.stream);
      when(() => mockAuthRepo.currentSession()).thenReturn(session);
      when(() => mockAuthRepo.fetchProfile(any()))
          .thenAnswer((_) async => testUser);
      when(() => mockAuthRepo.signInWithEmail(any(), any()))
          .thenAnswer((_) async {
        authStreamController.add(supabase.AuthState(supabase.AuthChangeEvent.signedIn, session));
      });
      when(() => mockAuthRepo.signOut()).thenAnswer((_) async {
        authStreamController.add(const supabase.AuthState(supabase.AuthChangeEvent.signedOut, null));
      });
    });

    testWidgets('Session Lifecycle: Login -> Verify Dashboard UI -> Settings/Theme Switch -> Logout Session Purge', (tester) async {
      // Pump App with mock implementations
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepo),
            mealRepositoryProvider.overrideWithValue(mockMealRepo),
            dashboardProvider.overrideWith(() => MockDashboard(summary)),
            analyticsServiceProvider.overrideWithValue(mockAnalytics),
            fcmServiceProvider.overrideWithValue(mockFcm),
            connectivityProvider.overrideWith(() => MockConnectivityNotifier()),
            activeThemeInitializedProvider.overrideWith(MockActiveThemeInitializedNotifier.new),
            bootstrapStateProvider.overrideWith((ref) => BootstrapState.ready),
          ],
          child: const ProDietApp(isTest: true),
        ),
      );

      await tester.pumpAndSettle();
      for (final widget in tester.allWidgets) {
        if (widget is Text) {
          print('DEBUG TEXT: ${widget.data}');
        } else if (widget is RichText) {
          print('DEBUG RICHTEXT: ${(widget.text as TextSpan).toPlainText()}');
        }
      }
      expect(find.text('KCAL REMAINING TODAY'), findsWidgets);
      expect(find.text('1300'), findsWidgets); // Remaining Calories (2500 - 1200)
      expect(find.textContaining('Gaurav', findRichText: true), findsWidgets); // Welcoming label

      // 2. Settings & Preference Persistence test
      final container = ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
      
      // Default theme is t1Dark
      expect(container.read(activeThemeProvider), ActiveTheme.t1Dark);

      // Programmatically select theme (simulate settings interaction)
      await container.read(activeThemeProvider.notifier).setTheme(ActiveTheme.t2Light);
      await tester.pumpAndSettle();

      // Assert the theme toggled correctly
      expect(container.read(activeThemeProvider), ActiveTheme.t2Light);
      
      // Assert it is successfully written to local disk SharedPreferences persistence
      expect(prefs.getString('active_theme'), 't2Light');

      // 3. User Sign Out purging credentials and reverting auth state
      await container.read(authProvider.notifier).signOut();
      await tester.pumpAndSettle();

      // Assert auth state has transitioned back to unauthenticated
      expect(container.read(authProvider), const AuthUnauthenticated());
    });
  });
}
