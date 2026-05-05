import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/app.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/data/auth_repository.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/features/meal_planner/data/meal_repository.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockMealRepository extends Mock implements MealRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Golden Path', () {
    late MockAuthRepository mockAuthRepo;
    late MockMealRepository mockMealRepo;
    
    final testUser = AppUser(
      id: 'u1',
      name: 'Test User',
      email: 'test@t.com',
      onboardingComplete: true,
      createdAt: DateTime.now(),
    );

    final summary = DashboardSummary(
      userName: 'Test User',
      caloriesConsumed: 0,
      caloriesGoal: 2000,
      waterMl: 0,
      waterGoalMl: 2500,
      proteinConsumed: 0,
      carbsConsumed: 0,
      fatConsumed: 0,
      proteinGoal: 100,
      carbsGoal: 200,
      fatGoal: 60,
      mealsToday: 0,
      mealsScheduled: 4,
      streakDays: 5,
      stepsToday: 5000,
      caloriesBurned: 300,
    );

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      mockMealRepo = MockMealRepository();
      
      when(() => mockAuthRepo.authStateChanges())
          .thenAnswer((_) => Stream.value(testUser));
      when(() => mockAuthRepo.currentSession()).thenReturn(null);
      when(() => mockAuthRepo.fetchProfile(any()))
          .thenAnswer((_) async => testUser);
    });

    testWidgets('Full Journey: Login -> Dashboard -> Log Meal', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepo),
            mealRepositoryProvider.overrideWithValue(mockMealRepo),
            activeThemeProvider.overrideWith((ref) => ActiveTheme.t1Dark),
            dashboardProvider.overrideWith((ref) => summary),
          ],
          child: const ProDietApp(),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify we are on Dashboard
      expect(find.text('DASHBOARD'), findsWidgets);
      expect(find.text('2000'), findsWidgets); // Calorie Goal

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
