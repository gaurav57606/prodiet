import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../domain/models/diet_plan.dart';

class DietPlanRepository {
  final SupabaseClient _supabase;
  static const String _tag = 'DietPlanRepository';

  DietPlanRepository(this._supabase);

  Future<Either<AppError, DietPlan?>> getActivePlan(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final response = await _supabase
          .from('diet_plans')
          .select()
          .eq('user_id', userId)
          .lte('start_date', today)
          .gte('end_date', today)
          .maybeSingle();
      
      if (response == null) return const Right(null);
      return Right(DietPlan.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getActivePlan'));
    }
  }

  Future<Either<AppError, List<DietPlan>>> getAllPlans(String userId) async {
    try {
      final response = await _supabase
          .from('diet_plans')
          .select()
          .eq('user_id', userId);
      
      final plans = (response as List).map((p) => DietPlan.fromJson(p)).toList();
      return Right(plans);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getAllPlans'));
    }
  }

  Future<Either<AppError, DietPlan>> createPlan(DietPlan plan) async {
    try {
      final response = await _supabase
          .from('diet_plans')
          .insert(plan.toJson())
          .select()
          .single();
      
      return Right(DietPlan.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.createPlan'));
    }
  }

  Future<Either<AppError, DietPlan>> updatePlan(DietPlan plan) async {
    try {
      final response = await _supabase
          .from('diet_plans')
          .update(plan.toJson())
          .eq('id', plan.id)
          .select()
          .single();
      
      return Right(DietPlan.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.updatePlan'));
    }
  }

  Future<Either<AppError, void>> deletePlan(String planId) async {
    try {
      await _supabase.from('diet_plans').delete().eq('id', planId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.deletePlan'));
    }
  }

  Future<Either<AppError, List<DietPlan>>> getPlansForDate(String userId, String date) async {
    try {
      final response = await _supabase
          .from('diet_plans')
          .select()
          .eq('user_id', userId)
          .lte('start_date', date)
          .gte('end_date', date);
      
      final plans = (response as List).map((p) => DietPlan.fromJson(p)).toList();
      return Right(plans);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getPlansForDate'));
    }
  }
}
