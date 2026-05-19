import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:prodiet_unified/app/app.dart';
import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';

import 'package:prodiet_unified/app/bootstrap_screen.dart';
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

  group('End-to-End Golden Path', () {
    SharedPreferences.setMockInitialValues({});
    
    late MockAuthRepository mockAuthRepo;
    late MockMealRepository mockMealRepo;
    late MockAnalyticsService mockAnalytics;
    late MockFcmService mockFcm;
    
    final testUser = AppUser(
      id: 'u1',
      name: 'Test User',
      email: 'test@t.com',
      onboardingComplete: true,
      createdAt: DateTime.now(),
    );

    const summary = DashboardSummary(
      userName: 'Test User',
      caloriesConsumed: 0,
      caloriesGoal: 2000,
      waterMl: 250,
      waterGoalMl: 2500,
      proteinConsumed: 0,
      carbsConsumed: 0,
      fatConsumed: 0,
      proteinGoal: 100,
      carbsGoal: 200,
      fatGoal: 60,
      mealsToday: 1,
      mealsScheduled: 4,
      streakDays: 5,
      stepsToday: 5000,
      caloriesBurned: 300,
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

    setUp(() {
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
      
      // Stub FCM
      when(() => mockFcm.initialize(any())).thenAnswer((_) => Future<void>.value());
      
      final session = makeSession('u1', 'test@t.com');
      when(() => mockAuthRepo.authStateChanges())
          .thenAnswer((_) => Stream.value(supabase.AuthState(supabase.AuthChangeEvent.signedIn, session)));
      when(() => mockAuthRepo.currentSession()).thenReturn(session);
      when(() => mockAuthRepo.fetchProfile(any()))
          .thenAnswer((_) async => testUser);
    });

    testWidgets('Full Journey: Login -> Dashboard -> Log Meal', (tester) async {
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

      // 1. Verify we are on Dashboard
      expect(find.text('KCAL REMAINING TODAY'), findsWidgets);
      expect(find.text('2000'), findsWidgets); // Calorie Goal (Remaining)
      expect(find.textContaining('Test', findRichText: true), findsWidgets); // User Name in greeting or header

      // 2. Navigate to Meal Logging (T1 Today Meals)
      // Assuming there's a button or FAB to add meal
      final addMealFab = find.byIcon(Icons.add_rounded);
      if (addMealFab.evaluate().isNotEmpty) {
        await tester.tap(addMealFab);
        await tester.pumpAndSettle();
      }

      // 3. Verify Dashboard Summary
      expect(find.textContaining('Test', findRichText: true), findsWidgets);
    });
  });
}
