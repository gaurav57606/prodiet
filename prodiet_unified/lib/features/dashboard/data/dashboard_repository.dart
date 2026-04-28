import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/core/error/error_handler.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';

class DashboardRepository {
  final SupabaseClient _supabase;

  DashboardRepository(this._supabase);

  Future<Either<AppError, DashboardSummary>> getTodaySummary({
    required String userId,
    required int caloriesGoal,
    required int waterGoalMl,
    int proteinGoal = 150,
    int carbsGoal = 200,
    int fatGoal = 60,
  }) async {
    try {
      final now = DateTime.now();
      final today = now.toIso8601String().split('T')[0];

      // 1. Meal Logs (Consumed Calories & Macros)
      // Note: We join with meals to get nutritional values if they aren't in meal_logs
      final mealLogsResponse = await _supabase
          .from('meal_logs')
          .select('actual_calories, meal_id, meals(nutritional_values)')
          .eq('user_id', userId)
          .eq('date', today);
      
      int caloriesConsumed = 0;
      int proteinConsumed = 0;
      int carbsConsumed = 0;
      int fatConsumed = 0;
      
      for (var row in mealLogsResponse) {
        caloriesConsumed += (row['actual_calories'] as num).toInt();
        final mealData = row['meals'] as Map<String, dynamic>?;
        if (mealData != null && mealData['nutritional_values'] != null) {
          final nv = mealData['nutritional_values'];
          proteinConsumed += (nv['protein_g'] as num? ?? 0).toInt();
          carbsConsumed += (nv['carbs_g'] as num? ?? 0).toInt();
          fatConsumed += (nv['fat_g'] as num? ?? 0).toInt();
        }
      }

      // 2. Water Logs
      final waterLogsResponse = await _supabase
          .from('water_logs')
          .select('amount_ml')
          .eq('user_id', userId)
          .eq('date', today);
      
      int waterMl = 0;
      for (var row in waterLogsResponse) {
        waterMl += (row['amount_ml'] as num).toInt();
      }

      // 3. Next Meal
      final nextMealResponse = await _supabase
          .from('meals')
          .select('*')
          .eq('user_id', userId)
          .eq('date', today)
          .eq('status', 'pending')
          .gte('scheduled_time', now.toIso8601String())
          .order('scheduled_time', ascending: true)
          .limit(1)
          .maybeSingle();
      
      Meal? nextMeal;
      if (nextMealResponse != null) {
        nextMeal = Meal.fromJson(nextMealResponse);
      }

      // 4. Meals Summary (Scheduled vs Completed)
      final mealsResponse = await _supabase
          .from('meals')
          .select('status')
          .eq('user_id', userId)
          .eq('date', today);
      
      int mealsScheduled = mealsResponse.length;
      int mealsLogged = mealsResponse.where((m) => m['status'] == 'completed').length;

      // 5. Active Diet Plan
      final dietPlanResponse = await _supabase
          .from('diet_plans')
          .select('plan_name')
          .eq('user_id', userId)
          .lte('start_date', today)
          .gte('end_date', today)
          .maybeSingle();
      
      String? activeDietPlanName = dietPlanResponse?['plan_name'] as String?;

      // 6. Activity Logs (Steps, Calories Burned)
      final activityLogResponse = await _supabase
          .from('activity_logs')
          .select('steps, calories_burned')
          .eq('user_id', userId)
          .eq('date', today)
          .maybeSingle();
      
      int stepsToday = (activityLogResponse?['steps'] as num?)?.toInt() ?? 0;
      int caloriesBurned = (activityLogResponse?['calories_burned'] as num?)?.toInt() ?? 0;

      // 7. Streak (Fetched from a streak table or user metadata if available)
      int streakDays = 0;

      return Right(DashboardSummary(
        caloriesConsumed: caloriesConsumed,
        caloriesGoal: caloriesGoal,
        proteinConsumed: proteinConsumed,
        proteinGoal: proteinGoal,
        carbsConsumed: carbsConsumed,
        carbsGoal: carbsGoal,
        fatConsumed: fatConsumed,
        fatGoal: fatGoal,
        waterMl: waterMl,
        waterGoalMl: waterGoalMl,
        mealsLogged: mealsLogged,
        mealsScheduled: mealsScheduled,
        activeDietPlanName: activeDietPlanName,
        streakDays: streakDays,
        stepsToday: stepsToday,
        caloriesBurned: caloriesBurned,
        currentWeightKg: null,
        nextMeal: nextMeal,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: 'DashboardRepository.getTodaySummary'));
    }
  }
}
