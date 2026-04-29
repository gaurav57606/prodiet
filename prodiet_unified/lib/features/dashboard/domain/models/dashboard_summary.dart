import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';

class DashboardSummary {
  final String userName;
  final int caloriesConsumed;
  final int caloriesGoal;
  final int proteinConsumed;
  final int proteinGoal;
  final int carbsConsumed;
  final int carbsGoal;
  final int fatConsumed;
  final int fatGoal;
  final int waterMl;
  final int waterGoalMl;
  final int mealsToday;
  final int mealsScheduled;
  final double? currentWeightKg;
  final String? activeDietPlanName;
  final int streakDays;
  final int stepsToday;
  final int caloriesBurned;
  final Meal? nextMeal;

  const DashboardSummary({
    required this.userName,
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.proteinConsumed,
    required this.proteinGoal,
    required this.carbsConsumed,
    required this.carbsGoal,
    required this.fatConsumed,
    required this.fatGoal,
    required this.waterMl,
    required this.waterGoalMl,
    required this.mealsToday,
    required this.mealsScheduled,
    this.currentWeightKg,
    this.activeDietPlanName,
    required this.streakDays,
    required this.stepsToday,
    required this.caloriesBurned,
    this.nextMeal,
  });

  // Computed
  double get calorieProgress => caloriesGoal > 0
    ? (caloriesConsumed / caloriesGoal).clamp(0.0, 1.0) : 0.0;
    
  double get proteinProgress => proteinGoal > 0
    ? (proteinConsumed / proteinGoal).clamp(0.0, 1.0) : 0.0;

  double get carbsProgress => carbsGoal > 0
    ? (carbsConsumed / carbsGoal).clamp(0.0, 1.0) : 0.0;

  double get fatProgress => fatGoal > 0
    ? (fatConsumed / fatGoal).clamp(0.0, 1.0) : 0.0;

  double get waterProgress => waterGoalMl > 0
    ? (waterMl / waterGoalMl).clamp(0.0, 1.0) : 0.0;
    
  int get netCalories => caloriesConsumed - caloriesBurned;

  static DashboardSummary empty({
    int caloriesGoal = 2000,
    int waterGoalMl = 2000,
    int proteinGoal = 150,
    int carbsGoal = 200,
    int fatGoal = 60,
  }) {
    return DashboardSummary(
      userName: 'User',
      caloriesConsumed: 0,
      caloriesGoal: caloriesGoal,
      proteinConsumed: 0,
      proteinGoal: proteinGoal,
      carbsConsumed: 0,
      carbsGoal: carbsGoal,
      fatConsumed: 0,
      fatGoal: fatGoal,
      waterMl: 0,
      waterGoalMl: waterGoalMl,
      mealsToday: 0,
      mealsScheduled: 0,
      streakDays: 0,
      stepsToday: 0,
      caloriesBurned: 0,
    );
  }
}
