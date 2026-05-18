import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';

void main() {
  /// Helper to create a summary with only the fields under test overridden.
  DashboardSummary makeSummary({
    int caloriesConsumed = 0,
    int caloriesGoal     = 2000,
    int proteinConsumed  = 0,
    int proteinGoal      = 150,
    int carbsConsumed    = 0,
    int carbsGoal        = 200,
    int fatConsumed      = 0,
    int fatGoal          = 60,
    int waterMl          = 0,
    int waterGoalMl      = 2000,
    int streakDays       = 0,
    int stepsToday       = 0,
    int caloriesBurned   = 0,
  }) =>
      DashboardSummary(
        userName:         'TestUser',
        caloriesConsumed: caloriesConsumed,
        caloriesGoal:     caloriesGoal,
        proteinConsumed:  proteinConsumed,
        proteinGoal:      proteinGoal,
        carbsConsumed:    carbsConsumed,
        carbsGoal:        carbsGoal,
        fatConsumed:      fatConsumed,
        fatGoal:          fatGoal,
        waterMl:          waterMl,
        waterGoalMl:      waterGoalMl,
        mealsToday:       0,
        mealsScheduled:   3,
        streakDays:       streakDays,
        stepsToday:       stepsToday,
        caloriesBurned:   caloriesBurned,
      );

  // ─────────────────────────────────────────────────────────
  // empty factory
  // ─────────────────────────────────────────────────────────
  group('DashboardSummary.empty', () {
    test('creates all-zero summary with default goals', () {
      final s = DashboardSummary.empty();
      expect(s.caloriesConsumed, 0);
      expect(s.waterMl,          0);
      expect(s.streakDays,       0);
      expect(s.calorieProgress,  0.0);
      expect(s.caloriesGoal,     2000);
      expect(s.waterGoalMl,      2000);
    });

    test('accepts custom goals in empty factory', () {
      final s = DashboardSummary.empty(
        caloriesGoal: 1800,
        waterGoalMl: 3000,
        proteinGoal: 120,
      );
      expect(s.caloriesGoal,  1800);
      expect(s.waterGoalMl,   3000);
      expect(s.proteinGoal,   120);
    });
  });

  // ─────────────────────────────────────────────────────────
  // calorieProgress
  // ─────────────────────────────────────────────────────────
  group('DashboardSummary — calorieProgress', () {
    test('returns 0.5 at half goal', () {
      final s = makeSummary(caloriesConsumed: 1000, caloriesGoal: 2000);
      expect(s.calorieProgress, closeTo(0.5, 0.001));
    });

    test('clamps to 1.0 when over goal', () {
      final s = makeSummary(caloriesConsumed: 3000, caloriesGoal: 2000);
      expect(s.calorieProgress, 1.0);
    });

    test('returns 0.0 when goal is 0 (div-by-zero guard)', () {
      final s = makeSummary(caloriesConsumed: 500, caloriesGoal: 0);
      expect(s.calorieProgress, 0.0);
    });

    test('returns 0.0 when nothing consumed', () {
      final s = makeSummary(caloriesConsumed: 0, caloriesGoal: 2000);
      expect(s.calorieProgress, 0.0);
    });

    test('returns 1.0 exactly at goal', () {
      final s = makeSummary(caloriesConsumed: 2000, caloriesGoal: 2000);
      expect(s.calorieProgress, 1.0);
    });
  });

  // ─────────────────────────────────────────────────────────
  // Macro progress (protein / carbs / fat)
  // ─────────────────────────────────────────────────────────
  group('DashboardSummary — macro progress', () {
    test('proteinProgress 50% at half goal', () {
      final s = makeSummary(proteinConsumed: 75, proteinGoal: 150);
      expect(s.proteinProgress, closeTo(0.5, 0.001));
    });

    test('carbsProgress 50% at half goal', () {
      final s = makeSummary(carbsConsumed: 100, carbsGoal: 200);
      expect(s.carbsProgress, closeTo(0.5, 0.001));
    });

    test('fatProgress 50% at half goal', () {
      final s = makeSummary(fatConsumed: 30, fatGoal: 60);
      expect(s.fatProgress, closeTo(0.5, 0.001));
    });

    test('all macro progress clamped to 1.0 over goal', () {
      final s = makeSummary(
        proteinConsumed: 300, proteinGoal: 150,
        carbsConsumed:   500, carbsGoal:   200,
        fatConsumed:     120, fatGoal:      60,
      );
      expect(s.proteinProgress, 1.0);
      expect(s.carbsProgress,   1.0);
      expect(s.fatProgress,     1.0);
    });

    test('macro progress 0.0 when goal is 0 (guard)', () {
      final s = makeSummary(
        proteinConsumed: 50, proteinGoal: 0,
        carbsConsumed:   50, carbsGoal:   0,
        fatConsumed:     20, fatGoal:      0,
      );
      expect(s.proteinProgress, 0.0);
      expect(s.carbsProgress,   0.0);
      expect(s.fatProgress,     0.0);
    });
  });

  // ─────────────────────────────────────────────────────────
  // waterProgress
  // ─────────────────────────────────────────────────────────
  group('DashboardSummary — waterProgress', () {
    test('returns 0.75 at 75% of goal', () {
      final s = makeSummary(waterMl: 1500, waterGoalMl: 2000);
      expect(s.waterProgress, closeTo(0.75, 0.001));
    });

    test('clamps to 1.0 when over goal', () {
      final s = makeSummary(waterMl: 5000, waterGoalMl: 2000);
      expect(s.waterProgress, 1.0);
    });

    test('returns 0.0 when goal is 0 (guard)', () {
      final s = makeSummary(waterMl: 500, waterGoalMl: 0);
      expect(s.waterProgress, 0.0);
    });
  });

  // ─────────────────────────────────────────────────────────
  // netCalories
  // ─────────────────────────────────────────────────────────
  group('DashboardSummary — netCalories', () {
    test('netCalories = consumed - burned (surplus)', () {
      final s = makeSummary(caloriesConsumed: 2000, caloriesBurned: 500);
      expect(s.netCalories, 1500);
    });

    test('netCalories is negative when burned > consumed (deficit)', () {
      final s = makeSummary(caloriesConsumed: 300, caloriesBurned: 600);
      expect(s.netCalories, -300);
    });

    test('netCalories is zero when balanced', () {
      final s = makeSummary(caloriesConsumed: 500, caloriesBurned: 500);
      expect(s.netCalories, 0);
    });

    test('netCalories is zero when both are zero', () {
      final s = makeSummary();
      expect(s.netCalories, 0);
    });
  });
}
