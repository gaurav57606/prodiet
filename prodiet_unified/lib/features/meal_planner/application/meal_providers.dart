import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/meal_planner/data/meal_repository.dart';
import 'package:prodiet_unified/features/meal_planner/domain/daily_meal_summary.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(ref.watch(supabaseClientProvider));
});

final todayMealsProvider = StreamProvider.autoDispose<DailyMealSummary>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return Stream.value(const DailyMealSummary(meals: [], totalCalories: 0, totalProteinG: 0, totalCarbsG: 0, totalFatG: 0));
  
  return ref.watch(mealRepositoryProvider).watchTodayMeals(userId).map((meals) {
    return DailyMealSummary.calculate(meals);
  });
});

final isLoggingMealProvider = StateProvider<bool>((ref) => false);

final weeklyMealsProvider = FutureProvider.autoDispose<List<Meal>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return [];
  
  return ref.read(mealRepositoryProvider).getMealHistory(userId, days: 7);
});
