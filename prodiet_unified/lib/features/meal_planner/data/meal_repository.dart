import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/services/analytics_service.dart';
import '../domain/models/meal_models.dart';

class MealRepository {
  final SupabaseClient _supabase;
  final AnalyticsService _analytics;
  static const String _tag = 'MealRepository';

  MealRepository(this._supabase, this._analytics);

  Future<Either<AppError, List<Meal>>> getTodayMeals(String userId, String date) async {
    try {
      final response = await _supabase
          .from('meals')
          .select()
          .eq('user_id', userId)
          .eq('date', date);
      
      final meals = (response as List).map((m) => Meal.fromJson(m)).toList();
      return Right(meals);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getTodayMeals'));
    }
  }

  Future<Either<AppError, List<Meal>>> getMealsByDateRange(
    String userId,
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await _supabase
          .from('meals')
          .select()
          .eq('user_id', userId)
          .gte('date', startDate)
          .lte('date', endDate);
      
      final meals = (response as List).map((m) => Meal.fromJson(m)).toList();
      return Right(meals);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getMealsByDateRange'));
    }
  }

  Future<Either<AppError, MealLog>> logMeal({
    required String mealId,
    required String userId,
    required int actualCalories,
    String? notes,
  }) async {
    try {
      final data = {
        'meal_id': mealId,
        'user_id': userId,
        'actual_calories': actualCalories,
        'notes': notes,
        'actual_time': DateTime.now().toIso8601String(),
        'date': DateTime.now().toIso8601String().split('T')[0],
      };
      
      final response = await _supabase.from('meal_logs').insert(data).select().single();
      
      // Also update meal status to completed
      await updateMealStatus(mealId, 'completed');
      
      _analytics.logEvent(
        userId, 
        AnalyticsService.kMealLogged,
        data: {'meal_id': mealId, 'calories': actualCalories},
        screen: 'meal_planner',
      );
      
      return Right(MealLog.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.logMeal'));
    }
  }

  Future<Either<AppError, Meal>> updateMealStatus(String mealId, String status) async {
    try {
      final response = await _supabase
          .from('meals')
          .update({'status': status})
          .eq('id', mealId)
          .select()
          .single();
      
      return Right(Meal.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.updateMealStatus'));
    }
  }

  Future<Either<AppError, Meal>> addMeal(Meal meal) async {
    try {
      final response = await _supabase
          .from('meals')
          .insert(meal.toJson())
          .select()
          .single();
      
      return Right(Meal.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.addMeal'));
    }
  }

  Future<Either<AppError, void>> deleteMeal(String mealId) async {
    try {
      await _supabase.from('meals').delete().eq('id', mealId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.deleteMeal'));
    }
  }

  Future<Either<AppError, List<MealLog>>> getMealLogs(String userId, String date) async {
    try {
      final response = await _supabase
          .from('meal_logs')
          .select()
          .eq('user_id', userId)
          .eq('date', date);
      
      final logs = (response as List).map((l) => MealLog.fromJson(l)).toList();
      return Right(logs);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getMealLogs'));
    }
  }
}
