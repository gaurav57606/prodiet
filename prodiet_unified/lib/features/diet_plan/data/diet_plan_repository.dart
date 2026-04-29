import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import '../domain/diet_meal.dart';
import '../domain/diet_day.dart';
import '../domain/diet_plan.dart';

class DietPlanRepository {
  final SupabaseClient _supabase;

  DietPlanRepository(this._supabase);

  Future<DietPlan?> getActivePlan(String userId) async {
    final response = await _supabase
        .from('diet_plans')
        .select()
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('generated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return DietPlan.fromJson(response);
  }

  Future<DietPlan> generatePlan(String userId) async {
    // 1. Fetch user profile
    final profile = await _supabase
        .from('users')
        .select('age,weight_kg,height_cm,fitness_goal,activity_level,dietary_preferences,allergies,daily_calorie_goal')
        .eq('id', userId)
        .single();

    // 2. Deactivate all previous plans
    await deactivateAllPlans(userId);

    // 3. Call Edge Function
    final response = await _supabase.functions.invoke(
      'generate-diet-plan',
      body: {
        'userId': userId,
        'profile': profile,
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to generate AI Diet Plan: ${response.data}');
    }

    // 4. Parse response
    final data = response.data as Map<String, dynamic>;
    final planData = {
      ...data,
      'user_id': userId,
      'is_active': true,
      'generated_at': DateTime.now().toIso8601String(),
    };

    // 5. INSERT into database
    final inserted = await _supabase
        .from('diet_plans')
        .insert(planData)
        .select()
        .single();

    return DietPlan.fromJson(inserted);
  }

  Future<void> savePlanMealsToToday(String userId, DietPlan plan) async {
    if (plan.days.isEmpty) return;

    // 1-based (1 = Monday ... 7 = Sunday)
    final dayIndex = DateTime.now().weekday - 1;
    if (dayIndex < 0 || dayIndex >= plan.days.length) return;
    
    final todayPlan = plan.days[dayIndex];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final mealsToInsert = <Map<String, dynamic>>[];

    void addMeals(List<DietMeal> items, MealType type) {
      for (final item in items) {
        mealsToInsert.add({
          'user_id': userId,
          'name': item.name,
          'calories': item.calories,
          'protein_g': item.proteinG,
          'carbs_g': item.carbsG,
          'fat_g': item.fatG,
          'meal_type': type.name,
          'ingredients': item.ingredients,
          'status': 'pending',
          'planned_date': today.toIso8601String(),
        });
      }
    }

    addMeals(todayPlan.breakfast, MealType.breakfast);
    addMeals(todayPlan.lunch, MealType.lunch);
    addMeals(todayPlan.dinner, MealType.dinner);
    addMeals(todayPlan.snacks, MealType.snack);

    if (mealsToInsert.isNotEmpty) {
      await _supabase.from('meals').insert(mealsToInsert);
    }
  }

  Future<void> deactivateAllPlans(String userId) async {
    await _supabase
        .from('diet_plans')
        .update({'is_active': false})
        .eq('user_id', userId);
  }
}
