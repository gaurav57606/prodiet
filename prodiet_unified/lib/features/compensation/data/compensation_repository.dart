import 'package:dartz/dartz.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/core/services/notification_service.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/features/ai/data/ai_repository.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/compensation_log.dart';

class CompensationRepository {
  final SupabaseService _client;
  final AiRepository _aiRepo;
  final NotificationService _notifications;

  CompensationRepository(this._client, this._aiRepo, this._notifications);

  Future<Either<AppError, CompensationLog>> logMissedMeal({
    required String userId,
    required String mealId,
    required int missedCalories,
    required int missedProteinG,
    required List<Meal> todaysMeals,
  }) async {
    try {
      // 1. Calculate remaining meals dynamically
      final remainingMeals = todaysMeals.where((m) => 
        m.status == MealStatus.pending && 
        m.plannedDate.isAfter(DateTime.now())
      ).length;

      // 2. Generate AI adjustment
      final aiAdjustmentResult = await _aiRepo.generateCompensation(
        userId,
        mealId,
        {
          'missed_calories': missedCalories,
          'missed_protein_g': missedProteinG,
          'remaining_meals_for_day': remainingMeals,
        },
      );

      final adjustmentJson = aiAdjustmentResult.fold(
        (e) => null,
        (data) => data,
      );

      // 3. Insert into compensation_logs
      final log = CompensationLog(
        id: const Uuid().v4(),
        userId: userId,
        originalMealId: mealId,
        missedCalories: missedCalories,
        missedProteinG: missedProteinG,
        compensationType: 'skipped',
        appliedToDate: DateTime.now().toIso8601String().split('T')[0],
        aiAdjustmentJson: adjustmentJson,
        createdAt: DateTime.now(),
      );

      final response = await _client.perform((client) async {
        return await client
            .from('compensation_logs')
            .insert(log.toJson())
            .select()
            .single();
      }, context: 'compensation.logMissedMeal');

      // 4. Trigger real local notification
      await _notifications.showNotification(
        id: log.id.hashCode,
        title: 'Plan Adjusted 🔄',
        body: 'You missed a meal, so we\'ve recalculated your targets for the rest of the day.',
      );

      return Right(CompensationLog.fromJson(response));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<Either<AppError, void>> applyCompensation(String logId) async {
    try {
      await _client.perform((client) async {
        await client
            .from('compensation_logs')
            .update({'status': 'applied'})
            .eq('id', logId);
      }, context: 'compensation.applyCompensation');
      return const Right(null);
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<Either<AppError, List<CompensationLog>>> getHistory(String userId) async {
    try {
      final response = await _client.perform((client) async {
        return await client
            .from('compensation_logs')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
      }, context: 'compensation.getHistory');
      
      final logs = (response as List).map((l) => CompensationLog.fromJson(l)).toList();
      return Right(logs);
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}

