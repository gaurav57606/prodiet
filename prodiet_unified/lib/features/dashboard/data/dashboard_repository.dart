import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/error/error_handler.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';

class DashboardRepository {
  final SupabaseClient _supabase;

  DashboardRepository(this._supabase);

  Future<DashboardSummary> getTodaySummary(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final results = await Future.wait<dynamic>([
        _supabase
            .from('meals')
            .select()
            .eq('user_id', userId)
            .eq('planned_date', today),
        _supabase.from('water_logs').select()
            .eq('user_id', userId)
            .gte('created_at', '${today}T00:00:00.000Z')
            .lte('created_at', '${today}T23:59:59.999Z'),
        _supabase
            .from('users')
            .select('name, daily_calorie_goal, daily_water_goal_ml')
            .eq('id', userId)
            .single(),
        _supabase.from('meals').select().eq('user_id', userId)
            .eq('planned_date', today).eq('status', 'pending')
            .order('scheduled_time').limit(1),
        _supabase.from('diet_plans').select('name')
            .eq('user_id', userId).eq('is_active', true).maybeSingle(),
      ]);

      final mealsData = results[0] as List<dynamic>;
      final waterData = results[1] as List<dynamic>;
      final userData = results[2] as Map<String, dynamic>;
      final nextMealList = results[3] as List<dynamic>;
      final planData = results[4] as Map<String, dynamic>?;

      Meal? nextMeal;
      if (nextMealList.isNotEmpty) {
        try { nextMeal = Meal.fromJson(nextMealList.first as Map<String, dynamic>); } catch (_) {}
      }

      int caloriesConsumed = 0;
      int proteinConsumed = 0;
      int carbsConsumed = 0;
      int fatConsumed = 0;
      int mealsLogged = 0;

      for (var meal in mealsData) {
        if (meal['status'] == 'completed') {
          mealsLogged++;
          caloriesConsumed += (meal['calories'] as num? ?? 0).toInt();
          proteinConsumed += (meal['protein_g'] as num? ?? 0).toInt();
          carbsConsumed += (meal['carbs_g'] as num? ?? 0).toInt();
          fatConsumed += (meal['fat_g'] as num? ?? 0).toInt();
        }
      }

      int waterMl = 0;
      for (var log in waterData) {
        waterMl += (log['amount_ml'] as num? ?? 0).toInt();
      }

      final calorieGoal = (userData['daily_calorie_goal'] as num? ?? 2000).toInt();
      final proteinGoal = ((calorieGoal * 0.3) / 4).toInt();
      final carbsGoal = ((calorieGoal * 0.4) / 4).toInt();
      final fatGoal = ((calorieGoal * 0.3) / 9).toInt();

      return DashboardSummary(
        userName: userData['name'] ?? 'User',
        caloriesConsumed: caloriesConsumed,
        caloriesGoal: calorieGoal,
        proteinConsumed: proteinConsumed,
        proteinGoal: proteinGoal,
        carbsConsumed: carbsConsumed,
        carbsGoal: carbsGoal,
        fatConsumed: fatConsumed,
        fatGoal: fatGoal,
        waterMl: waterMl,
        waterGoalMl: (userData['daily_water_goal_ml'] as num? ?? 2000).toInt(),
        mealsToday: mealsLogged,
        mealsScheduled: mealsData.length,
        streakDays: 0,
        stepsToday: 0,
        caloriesBurned: 0,
        nextMeal: nextMeal,
        activeDietPlanName: planData?['name'] as String?,
      );
    } catch (e) {
      throw ErrorHandler.handle(e, context: 'DashboardRepository.getTodaySummary');
    }
  }
}
