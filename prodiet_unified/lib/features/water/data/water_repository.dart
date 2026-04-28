import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/services/analytics_service.dart';
import '../domain/models/water_log.dart';

class WaterRepository {
  final SupabaseClient _supabase;
  final AnalyticsService _analytics;
  static const String _tag = 'WaterRepository';

  WaterRepository(this._supabase, this._analytics);

  Future<Either<AppError, int>> getTodayWaterTotal(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final response = await _supabase
          .from('water_logs')
          .select('amount_ml')
          .eq('user_id', userId)
          .eq('date', today);
      
      int total = 0;
      for (var row in response) {
        total += (row['amount_ml'] as num).toInt();
      }
      return Right(total);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getTodayWaterTotal'));
    }
  }

  Future<Either<AppError, List<WaterLog>>> getWaterLogs(String userId, String date) async {
    try {
      final response = await _supabase
          .from('water_logs')
          .select()
          .eq('user_id', userId)
          .eq('date', date);
      
      final logs = (response as List).map((l) => WaterLog.fromJson(l)).toList();
      return Right(logs);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getWaterLogs'));
    }
  }

  Future<Either<AppError, WaterLog>> logWater(String userId, int amountMl) async {
    try {
      final now = DateTime.now();
      final date = now.toIso8601String().split('T')[0];
      final data = {
        'user_id': userId,
        'amount_ml': amountMl,
        'logged_at': now.toIso8601String(),
        'date': date,
      };
      
      final response = await _supabase.from('water_logs').insert(data).select().single();
      
      _analytics.logEvent(
        userId, 
        AnalyticsService.kWaterLogged, 
        data: {'amount_ml': amountMl},
        screen: 'water_tracker',
      );
      
      return Right(WaterLog.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.logWater'));
    }
  }

  Future<Either<AppError, void>> deleteLog(String logId) async {
    try {
      await _supabase.from('water_logs').delete().eq('id', logId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.deleteLog'));
    }
  }

  Future<Either<AppError, double>> getWeeklyAverage(String userId) async {
    try {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split('T')[0];
      final response = await _supabase
          .from('water_logs')
          .select('amount_ml, date')
          .eq('user_id', userId)
          .gte('date', weekAgo);
      
      Map<String, int> dailyTotals = {};
      for (var row in response) {
        final date = row['date'];
        dailyTotals[date] = (dailyTotals[date] ?? 0) + (row['amount_ml'] as num).toInt();
      }
      
      if (dailyTotals.isEmpty) return const Right(0.0);
      double avg = dailyTotals.values.reduce((a, b) => a + b) / 7.0;
      return Right(avg);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getWeeklyAverage'));
    }
  }
}
