import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';

class DashboardRepository {
  final SupabaseService _supabase;

  DashboardRepository(this._supabase);

  Future<DashboardSummary> getTodaySummary(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final ninetyDaysAgo = DateTime.now().subtract(const Duration(days: 90)).toIso8601String().split('T')[0];

    final results = await _supabase.perform((client) async {
      return await Future.wait<dynamic>([
        client
            .from('meals')
            .select()
            .eq('user_id', userId)
            .eq('planned_date', today),
        client.from('water_logs').select('amount_ml')
            .eq('user_id', userId)
            .eq('date', today),
        client
            .from('users')
            .select('name, daily_calorie_goal, daily_water_goal_ml')
            .eq('id', userId)
            .single(),
        client.from('meals').select().eq('user_id', userId)
            .eq('planned_date', today).eq('status', 'pending')
            .order('scheduled_time').limit(1),
        client.from('diet_plans').select('name')
            .eq('user_id', userId).eq('is_active', true).maybeSingle(),
        client.from('meals').select('planned_date,status')
            .eq('user_id', userId)
            .gte('planned_date', ninetyDaysAgo)
            .order('planned_date', ascending: false),
      ]);
    }, context: 'dashboard.getTodaySummary');

    final mealsData = results[0] as List<dynamic>;
    final waterData = results[1] as List<dynamic>;
    final userData = results[2] as Map<String, dynamic>;
    final nextMealList = results[3] as List<dynamic>;
    final planData = results[4] as Map<String, dynamic>?;
    final streakData = results[5] as List<dynamic>;

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
      if (meal['status'] == 'eaten') {
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
    final streakDays = _calculateStreak(streakData);

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
      streakDays: streakDays,
      stepsToday: 0,
      caloriesBurned: 0,
      nextMeal: nextMeal,
      activeDietPlanName: planData?['name'] as String?,
    );
  }

  int _calculateStreak(List<dynamic> mealRows) {
    try {
      if (mealRows.isEmpty) return 0;

      final Map<String, bool> eatenByDay = {};
      for (var row in mealRows) {
        final date = row['planned_date'] as String;
        final status = row['status'] as String;
        if (status == 'eaten') {
          eatenByDay[date] = true;
        }
      }

      int streak = 0;
      DateTime checkDate = DateTime.now();
      String dateStr = checkDate.toIso8601String().split('T')[0];

      // Check today first
      if (eatenByDay[dateStr] == true) {
        streak++;
      }
      
      // Go back from yesterday
      checkDate = checkDate.subtract(const Duration(days: 1));
      while (true) {
        dateStr = checkDate.toIso8601String().split('T')[0];
        if (eatenByDay[dateStr] == true) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
      return streak;
    } catch (_) {
      return 0;
    }
  }
}
