import 'package:dartz/dartz.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/features/ai/data/ai_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/compensation_log.dart';

class CompensationRepository {
  final SupabaseClient _client;
  final AiRepository _aiRepo;

  CompensationRepository(this._client, this._aiRepo);

  Future<Either<AppError, CompensationLog>> logMissedMeal({
    required String userId,
    required String mealId,
    required int missedCalories,
    required int missedProteinG,
  }) async {
    try {
      // 1. Generate AI adjustment
      final aiAdjustmentResult = await _aiRepo.generateCompensation(
        userId,
        mealId,
        {
          'missed_calories': missedCalories,
          'missed_protein_g': missedProteinG,
          'remaining_meals_for_day': 3, // Mock value
        },
      );

      final adjustmentJson = aiAdjustmentResult.fold(
        (e) => null,
        (data) => data,
      );

      // 2. Insert into compensation_logs
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

      final response = await _client
          .from('compensation_logs')
          .insert(log.toJson())
          .select()
          .single();

      // 3. Trigger local notification (Mocked as no service found)
      // print('Notification: Meal missed — plan adjusted');

      return Right(CompensationLog.fromJson(response));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<Either<AppError, List<CompensationLog>>> getHistory(String userId) async {
    try {
      final response = await _client
          .from('compensation_logs')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      final logs = (response as List).map((l) => CompensationLog.fromJson(l)).toList();
      return Right(logs);
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}
