import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
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
            .eq('date', today),
        _supabase
            .from('water_logs')
            .select()
            .eq('user_id', userId)
            .eq('date', today),
        _supabase
            .from('users')
            .select('name, daily_calorie_goal, daily_water_goal_ml')
            .eq('id', userId)
            .single(),
      ]);

      final mealsData = results[0] as List<dynamic>;
      final waterData = results[1] as List<dynamic>;
      final userData = results[2] as Map<String, dynamic>;

      int caloriesConsumed = 0;
      int proteinConsumed = 0;
      int carbsConsumed = 0;
      int fatConsumed = 0;
      int mealsLogged = 0;

      for (var meal in mealsData) {
        if (meal['status'] == 'completed') {
          mealsLogged++;
          final nv = meal['nutritional_values'] as Map<String, dynamic>? ?? {};
          caloriesConsumed += (nv['calories'] as num? ?? 0).toInt();
          proteinConsumed += (nv['protein_g'] as num? ?? 0).toInt();
          carbsConsumed += (nv['carbs_g'] as num? ?? 0).toInt();
          fatConsumed += (nv['fat_g'] as num? ?? 0).toInt();
        }
      }

      int waterMl = 0;
      for (var log in waterData) {
        waterMl += (log['amount_ml'] as num? ?? 0).toInt();
      }

      return DashboardSummary(
        userName: userData['name'] ?? 'User',
        caloriesConsumed: caloriesConsumed,
        caloriesGoal: (userData['daily_calorie_goal'] as num? ?? 2000).toInt(),
        proteinConsumed: proteinConsumed,
        proteinGoal: 150, // Default or derived
        carbsConsumed: carbsConsumed,
        carbsGoal: 200, // Default or derived
        fatConsumed: fatConsumed,
        fatGoal: 60, // Default or derived
        waterMl: waterMl,
        waterGoalMl: (userData['daily_water_goal_ml'] as num? ?? 2000).toInt(),
        mealsToday: mealsLogged,
        mealsScheduled: mealsData.length,
        streakDays: 0,
        stepsToday: 0,
        caloriesBurned: 0,
      );
    } catch (e) {
      throw ErrorHandler.handle(e,
          context: 'DashboardRepository.getTodaySummary');
    }
  }
}
