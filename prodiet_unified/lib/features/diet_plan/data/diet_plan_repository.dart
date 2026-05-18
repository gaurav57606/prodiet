import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import '../domain/diet_meal.dart';
import '../domain/diet_plan.dart';
import '../domain/diet_plan_exceptions.dart';

class DietPlanRepository {
  final SupabaseService _supabase;

  DietPlanRepository(this._supabase);

  Future<DietPlan?> getActivePlan(String userId) async {
    final response = await _supabase.perform((client) async {
      return await client
          .from('diet_plans')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('generated_at', ascending: false)
          .limit(1)
          .maybeSingle();
    }, context: 'diet_plans.getActivePlan');

    if (response == null) return null;
    return DietPlan.fromJson(response);
  }

  Future<DietPlan> generatePlan(String userId) async {
    // Check last generated_at for rate limiting
    final lastPlan = await _supabase.perform((client) async {
      return await client
          .from('diet_plans')
          .select('generated_at')
          .eq('user_id', userId)
          .order('generated_at', ascending: false)
          .limit(1)
          .maybeSingle();
    }, context: 'diet_plans.checkRateLimit');

    if (lastPlan != null) {
      final lastGenerated = DateTime.tryParse(lastPlan['generated_at'] as String? ?? '');
      if (lastGenerated != null) {
        final hoursSince = DateTime.now().difference(lastGenerated).inHours;
        if (hoursSince < 24) {
          final hoursRemaining = 24 - hoursSince;
          throw PlanRateLimitException(
            'You can generate a new plan in $hoursRemaining hours.',
            hoursRemaining: hoursRemaining,
          );
        }
      }
    }

    // 1. Fetch user profile
    final profile = await _supabase.perform((client) async {
      return await client
          .from('users')
          .select('age,weight_kg,height_cm,fitness_goal,activity_level,dietary_preferences,allergies,daily_calorie_goal')
          .eq('id', userId)
          .single();
    }, context: 'diet_plans.getUserProfile');

    // 2. Deactivate all previous plans
    await deactivateAllPlans(userId);

    // 3. Call Edge Function inside perform block for standard error catching
    final response = await _supabase.perform((client) async {
      return await client.functions.invoke(
        'generate-diet-plan',
        body: {
          'userId': userId,
          'profile': profile,
        },
      );
    }, context: 'diet_plans.generatePlanEdgeFunction');

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
    final inserted = await _supabase.perform((client) async {
      return await client
          .from('diet_plans')
          .insert(planData)
          .select()
          .single();
    }, context: 'diet_plans.insertNewPlan');

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
          'planned_date': today.toIso8601String().split('T')[0],
        });
      }
    }

    addMeals(todayPlan.breakfast, MealType.breakfast);
    addMeals(todayPlan.lunch, MealType.lunch);
    addMeals(todayPlan.dinner, MealType.dinner);
    addMeals(todayPlan.snacks, MealType.snack);

    if (mealsToInsert.isNotEmpty) {
      await _supabase.perform((client) async {
        await client.from('meals').insert(mealsToInsert);
      }, context: 'diet_plans.savePlanMealsToToday');
    }
  }

  Future<void> deactivateAllPlans(String userId) async {
    await _supabase.perform((client) async {
      await client
          .from('diet_plans')
          .update({'is_active': false})
          .eq('user_id', userId);
    }, context: 'diet_plans.deactivateAllPlans');
  }
}
