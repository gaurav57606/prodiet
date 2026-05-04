import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';

void main() {
  group('DashboardSummary', () {
    test('calorieProgress should calculate correctly', () {
      const summary = DashboardSummary(
        userName: 'Test',
        caloriesConsumed: 1000,
        caloriesGoal: 2000,
        proteinConsumed: 0,
        proteinGoal: 100,
        carbsConsumed: 0,
        carbsGoal: 100,
        fatConsumed: 0,
        fatGoal: 100,
        waterMl: 0,
        waterGoalMl: 2000,
        mealsToday: 0,
        mealsScheduled: 0,
        streakDays: 0,
        stepsToday: 0,
        caloriesBurned: 0,
      );

      expect(summary.calorieProgress, 0.5);
    });

    test('calorieProgress should clamp to 1.0', () {
      const summary = DashboardSummary(
        userName: 'Test',
        caloriesConsumed: 3000,
        caloriesGoal: 2000,
        proteinConsumed: 0,
        proteinGoal: 100,
        carbsConsumed: 0,
        carbsGoal: 100,
        fatConsumed: 0,
        fatGoal: 100,
        waterMl: 0,
        waterGoalMl: 2000,
        mealsToday: 0,
        mealsScheduled: 0,
        streakDays: 0,
        stepsToday: 0,
        caloriesBurned: 0,
      );

      expect(summary.calorieProgress, 1.0);
    });

    test('netCalories should subtract burned from consumed', () {
      const summary = DashboardSummary(
        userName: 'Test',
        caloriesConsumed: 2000,
        caloriesGoal: 2000,
        proteinConsumed: 0,
        proteinGoal: 100,
        carbsConsumed: 0,
        carbsGoal: 100,
        fatConsumed: 0,
        fatGoal: 100,
        waterMl: 0,
        waterGoalMl: 2000,
        mealsToday: 0,
        mealsScheduled: 0,
        streakDays: 0,
        stepsToday: 0,
        caloriesBurned: 500,
      );

      expect(summary.netCalories, 1500);
    });

    test('empty should return a summary with zeroed progress', () {
      final summary = DashboardSummary.empty(caloriesGoal: 2500);

      expect(summary.caloriesConsumed, 0);
      expect(summary.caloriesGoal, 2500);
      expect(summary.calorieProgress, 0.0);
    });
  });
}
