import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/meal.dart';

class MealRepository {
  final SupabaseClient _supabase;

  MealRepository(this._supabase);

  Stream<List<Meal>> watchTodayMeals(String userId) {
    final today = DateTime.now().toIso8601String().split('T')[0];

    return _supabase
        .from('meals')
        .stream(primaryKey: ['id'])
        .eq('planned_date', today) // Server-side date filtering
        .map((data) {
          return data
              .where((row) =>
                  row['user_id'] == userId) // Client-side user filtering
              .map((row) => Meal.fromJson(row))
              .toList()
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        });
  }

  Future<void> logMeal(
    String userId, {
    required String name,
    required MealType mealType,
    required double calories,
    double proteinG = 0,
    double carbsG = 0,
    double fatG = 0,
    List<String> ingredients = const [],
  }) async {
    final now = DateTime.now();
    final today = now.toIso8601String().split('T')[0];

    final data = {
      'user_id': userId,
      'name': name,
      'meal_type': mealType.name,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'ingredients': ingredients,
      'status': MealStatus.pending.name,
      'planned_date': today,
      'created_at': now.toIso8601String(),
    };

    await _supabase.from('meals').insert(data);
  }

  Future<void> markEaten(String mealId) async {
    await _supabase
        .from('meals')
        .update({'status': MealStatus.eaten.name}).eq('id', mealId);
  }

  Future<void> markSkipped(String mealId) async {
    await _supabase
        .from('meals')
        .update({'status': MealStatus.skipped.name}).eq('id', mealId);
  }

  Future<void> deleteMeal(String mealId) async {
    await _supabase.from('meals').delete().eq('id', mealId);
  }

  Future<List<Meal>> getMealHistory(String userId, {int days = 7}) async {
    final startDate = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .split('T')[0];

    final response = await _supabase
        .from('meals')
        .select()
        .eq('user_id', userId)
        .gte('planned_date', startDate);

    return (response as List).map((row) => Meal.fromJson(row)).toList();
  }
}
