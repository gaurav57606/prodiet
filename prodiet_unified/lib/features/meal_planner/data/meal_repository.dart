import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/sync/sync_queue.dart';
import 'package:prodiet_unified/core/sync/sync_task.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:uuid/uuid.dart';
import '../domain/meal.dart';

class MealRepository {
  final SupabaseService _supabase;
  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  MealRepository(this._supabase, this._db, this._syncQueue);

  Stream<List<Meal>> watchTodayMeals(String userId) {
    return watchMealsForDate(userId, DateTime.now());
  }

  Stream<List<Meal>> watchMealsForDate(String userId, DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    
    // Watch local Drift DB (Single Source of Truth)
    return _db.mealDao.watchMealsForDate(userId, dateStr).map((localMeals) {
      return localMeals.map((l) {
        Map<String, dynamic> nut = {};
        if (l.nutritionalValuesJson != null) {
          try {
            nut = jsonDecode(l.nutritionalValuesJson!) as Map<String, dynamic>;
          } catch (_) {}
        }
        final double cal = (nut['calories'] as num?)?.toDouble() ?? 0.0;
        final double pro = (nut['protein'] as num?)?.toDouble() ?? 0.0;
        final double carb = (nut['carbs'] as num?)?.toDouble() ?? 0.0;
        final double fat = (nut['fat'] as num?)?.toDouble() ?? 0.0;
        
        List<String> ingList = [];
        if (l.ingredientsJson != null) {
          try {
            ingList = List<String>.from(jsonDecode(l.ingredientsJson!));
          } catch (_) {}
        }
        
        return Meal(
          id: l.id,
          userId: l.userId,
          name: l.name,
          mealType: MealType.values.byName(l.mealType),
          calories: cal,
          proteinG: pro,
          carbsG: carb,
          fatG: fat,
          ingredients: ingList,
          status: MealStatus.values.byName(l.status),
          plannedDate: DateTime.parse(l.date),
          createdAt: DateTime.parse(l.createdAt),
        );
      }).toList();
    });
  }

  Future<void> logMeal(String userId, {
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
    final id = const Uuid().v4();
    
    final nutritionalValuesJson = jsonEncode({
      'calories': calories,
      'protein': proteinG,
      'carbs': carbsG,
      'fat': fatG,
    });
    final ingredientsJson = jsonEncode(ingredients);
    
    // 1. Write to local DB first (Optimistic)
    await _db.mealDao.upsertMeal(LocalMealsCompanion.insert(
      id: id,
      userId: userId,
      name: name,
      mealType: mealType.name,
      status: Value(MealStatus.pending.name),
      date: today,
      ingredientsJson: Value(ingredientsJson),
      nutritionalValuesJson: Value(nutritionalValuesJson),
      createdAt: now.toIso8601String(),
      updatedAt: Value(now),
      clientUpdatedAt: Value(now),
      isDirty: const Value(true),
    ));

    // 2. Enqueue Sync
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      operation: SyncOperation.insert,
      target: SyncTarget.meals,
      recordId: id,
      payload: {
        'id': id,
        'user_id': userId,
        'name': name,
        'meal_type': mealType.name,
        'calories': calories,
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        'status': MealStatus.pending.name,
        'planned_date': today,
        'created_at': now.toIso8601String(),
        'client_updated_at': now.toIso8601String(),
      },
      createdAt: DateTime.now(),
    ));
  }

  Future<void> markEaten(String mealId) async {
    final now = DateTime.now();
    await _db.mealDao.updateStatus(mealId, MealStatus.eaten.name);
    
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      operation: SyncOperation.update,
      target: SyncTarget.meals,
      recordId: mealId,
      payload: {
        'status': MealStatus.eaten.name,
        'client_updated_at': now.toIso8601String(),
      },
      createdAt: DateTime.now(),
    ));
  }

  Future<void> markSkipped(String mealId) async {
    final now = DateTime.now();
    await _db.mealDao.updateStatus(mealId, MealStatus.skipped.name);
    
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      operation: SyncOperation.update,
      target: SyncTarget.meals,
      recordId: mealId,
      payload: {
        'status': MealStatus.skipped.name,
        'client_updated_at': now.toIso8601String(),
      },
      createdAt: DateTime.now(),
    ));
  }

  Future<void> deleteMeal(String mealId) async {
    await _db.mealDao.deleteMeal(mealId);
    
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      operation: SyncOperation.delete,
      target: SyncTarget.meals,
      recordId: mealId,
      payload: {},
      createdAt: DateTime.now(),
    ));
  }


  Future<List<Meal>> getMealHistory(String userId, {int days = 7}) async {
    final startDate = DateTime.now().subtract(Duration(days: days)).toIso8601String().split('T')[0];
    
    // Hardened: In a real offline-first app, history should also be in Drift.
    // For now, keep Supabase fetch but ideally we sync history too.
    final response = await _supabase.perform((client) async {
      return await client
          .from('meals')
          .select()
          .eq('user_id', userId)
          .gte('planned_date', startDate);
    }, context: 'meals.getMealHistory');
    
    return (response as List).map((row) => Meal.fromJson(row)).toList();
  }
}
