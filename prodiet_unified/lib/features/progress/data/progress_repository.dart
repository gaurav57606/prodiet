import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../domain/models/progress_log.dart';

class ProgressRepository {
  final SupabaseClient _supabase;
  static const String _tag = 'ProgressRepository';

  ProgressRepository(this._supabase);

  Future<Either<AppError, List<ProgressLog>>> getLogs(String userId, {int limit = 30}) async {
    try {
      final response = await _supabase
          .from('progress_logs')
          .select()
          .eq('user_id', userId)
          .order('logged_at', ascending: false)
          .limit(limit);
      
      final logs = (response as List).map((l) => ProgressLog.fromJson(l)).toList();
      return Right(logs);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getLogs'));
    }
  }

  Future<Either<AppError, ProgressLog>> addLog(ProgressLog log) async {
    try {
      final response = await _supabase
          .from('progress_logs')
          .insert(log.toJson())
          .select()
          .single();
      
      return Right(ProgressLog.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.addLog'));
    }
  }

  Future<Either<AppError, void>> deleteLog(String logId) async {
    try {
      await _supabase.from('progress_logs').delete().eq('id', logId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.deleteLog'));
    }
  }

  Future<Either<AppError, List<Map<String, dynamic>>>> getWeightTrend(String userId, int days) async {
    try {
      final sinceDate = DateTime.now().subtract(Duration(days: days)).toIso8601String();
      final response = await _supabase
          .from('progress_logs')
          .select('logged_at, weight_kg')
          .eq('user_id', userId)
          .gte('logged_at', sinceDate)
          .order('logged_at', ascending: true);
      
      final trend = (response as List).map((row) => {
        'date': (row['logged_at'] as String).split('T')[0],
        'weight': (row['weight_kg'] as num).toDouble(),
      }).toList();
      
      return Right(trend);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getWeightTrend'));
    }
  }

  Future<Either<AppError, String>> uploadPhoto(String userId, File file) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '$userId/$fileName';
      
      await _supabase.storage.from('progress_photos').upload(path, file);
      final url = _supabase.storage.from('progress_photos').getPublicUrl(path);
      
      return Right(url);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.uploadPhoto'));
    }
  }
}
