import 'package:dartz/dartz.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiRepository {
  final SupabaseClient _client;
  final AnalyticsService _analytics;

  AiRepository(this._client, this._analytics);

  Future<Either<AppError, Map<String, dynamic>>> generateMealPlan(
    AppUser user, {
    int days = 7,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'ai-meal-plan',
        body: {
          'user_id': user.id,
          'fitness_goal': user.fitnessGoal ?? 'maintain',
          'activity_level': user.activityLevel ?? 'moderate',
          'dietary_preferences': user.dietaryPreferences.join(', '),
          'allergies': user.allergies.join(', '),
          'days': days,
        },
      );

      if (response.status != 200) {
        return Left(ServerError(
            message: 'AI Meal Plan generation failed: ${response.status}'));
      }

      final data = response.data as Map<String, dynamic>;
      final isCacheHit = data['cached'] == true;

      _analytics.logEvent(
        user.id,
        AnalyticsService.kAiPlanGenerated,
        data: {'cached': isCacheHit, 'days': days},
        screen: 'ai_meal_plan',
      );

      return Right(data);
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<Either<AppError, String>> askKitchenAssistant(
    String userId,
    String question,
    List<String> availableIngredients,
  ) async {
    try {
      final response = await _client.functions.invoke(
        'ai-chat',
        body: {
          'user_id': userId,
          'question': question,
          'ingredients': availableIngredients,
        },
      );

      if (response.status != 200) {
        return Left(ServerError(
            message: 'Kitchen Assistant failed: ${response.status}'));
      }

      return Right(
          response.data['answer'] ?? 'I couldn\'t find an answer for that.');
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<Either<AppError, Map<String, dynamic>>> generateCompensation(
    String userId,
    String missedMealId,
    Map<String, dynamic> remainingMacros,
  ) async {
    try {
      final response = await _client.functions.invoke(
        'ai-compensate',
        body: {
          'user_id': userId,
          'missed_meal_id': missedMealId,
          'remaining_macros': remainingMacros,
        },
      );

      if (response.status != 200) {
        return Left(
            ServerError(message: 'AI Compensation failed: ${response.status}'));
      }

      return Right(response.data as Map<String, dynamic>);
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}
