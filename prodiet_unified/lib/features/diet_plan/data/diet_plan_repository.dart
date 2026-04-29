import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/meal_planner/data/meal_repository.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import '../domain/diet_day.dart';
import '../domain/diet_plan.dart';

class DietPlanRepository {
  final SupabaseClient _supabase;
  final MealRepository _mealRepository;
  static const String _cacheKeyPrefix = 'diet_plan_';

  DietPlanRepository(this._supabase, this._mealRepository);

  Future<DietPlan> generatePlan(String userId) async {
    // 1. Fetch user profile
    final profile = await _supabase
        .from('users')
        .select('fitness_goal, activity_level, dietary_preferences, allergies')
        .eq('id', userId)
        .single();

    final fitnessGoal = profile['fitness_goal'] as String? ?? 'General Health';
    final activityLevel = profile['activity_level'] as String? ?? 'Sedentary';
    final dietaryPrefs = (profile['dietary_preferences'] as List?)?.join(', ') ?? 'None';
    final allergies = (profile['allergies'] as List?)?.join(', ') ?? 'None';

    // 2. Call Edge Function
    final response = await _supabase.functions.invoke(
      'ai-meal-plan',
      body: {
        'user_id': userId,
        'fitness_goal': fitnessGoal,
        'activity_level': activityLevel,
        'dietary_preferences': dietaryPrefs,
        'allergies': allergies,
        'days': 7,
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to generate AI Diet Plan: ${response.data}');
    }

    final data = response.data as Map<String, dynamic>;
    
    // 3. Map to DietPlan
    final plan = DietPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      days: (data['days'] as List).map((d) => DietDay.fromJson(d)).toList(),
      summaryCalories: (data['summary']['calories'] as num).toInt(),
      summaryProteinG: (data['summary']['protein'] as num).toInt(),
      summaryCarbsG: (data['summary']['carbs'] as num).toInt(),
      summaryFatG: (data['summary']['fat'] as num).toInt(),
      fitnessGoal: fitnessGoal,
      activityLevel: activityLevel,
      generatedAt: DateTime.now(),
    );

    // 4. Cache locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_cacheKeyPrefix$userId', jsonEncode(plan.toJson()));

    return plan;
  }

  Future<DietPlan?> getCachedPlan(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_cacheKeyPrefix$userId');
    
    if (jsonString == null) return null;

    try {
      final plan = DietPlan.fromJson(jsonDecode(jsonString));
      
      // Check if plan is < 7 days old
      final age = DateTime.now().difference(plan.generatedAt);
      if (age.inDays >= 7) {
        await prefs.remove('$_cacheKeyPrefix$userId');
        return null;
      }
      
      return plan;
    } catch (e) {
      return null;
    }
  }

  Future<void> savePlanToMeals(String userId, DietPlan plan) async {
    // Take Day 1 (or today's index if we want to be fancy, but prompt says day[0])
    if (plan.days.isEmpty) return;
    final today = plan.days[0];

    // Estimate calories per meal (simple split of summary)
    final calPerMeal = (plan.summaryCalories / 3).roundToDouble();
    final pPerMeal = (plan.summaryProteinG / 3).roundToDouble();
    final cPerMeal = (plan.summaryCarbsG / 3).roundToDouble();
    final fPerMeal = (plan.summaryFatG / 3).roundToDouble();

    await Future.wait([
      _mealRepository.logMeal(
        userId,
        name: today.breakfast,
        mealType: MealType.breakfast,
        calories: calPerMeal,
        proteinG: pPerMeal,
        carbsG: cPerMeal,
        fatG: fPerMeal,
      ),
      _mealRepository.logMeal(
        userId,
        name: today.lunch,
        mealType: MealType.lunch,
        calories: calPerMeal,
        proteinG: pPerMeal,
        carbsG: cPerMeal,
        fatG: fPerMeal,
      ),
      _mealRepository.logMeal(
        userId,
        name: today.dinner,
        mealType: MealType.dinner,
        calories: calPerMeal,
        proteinG: pPerMeal,
        carbsG: cPerMeal,
        fatG: fPerMeal,
      ),
    ]);
  }
}
