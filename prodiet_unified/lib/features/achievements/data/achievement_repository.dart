import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../domain/models/achievement.dart';

class AchievementRepository {
  final SupabaseClient _supabase;
  static const String _tag = 'AchievementRepository';

  AchievementRepository(this._supabase);

  Future<Either<AppError, List<Achievement>>> getAll(String userId) async {
    try {
      final response = await _supabase
          .from('achievements')
          .select()
          .eq('user_id', userId)
          .order('earned_at', ascending: false);

      final achievements =
          (response as List).map((a) => Achievement.fromJson(a)).toList();
      return Right(achievements);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getAll'));
    }
  }

  Future<Either<AppError, List<Achievement>>> getRecent(
      String userId, int limit) async {
    try {
      final response = await _supabase
          .from('achievements')
          .select()
          .eq('user_id', userId)
          .order('earned_at', ascending: false)
          .limit(limit);

      final achievements =
          (response as List).map((a) => Achievement.fromJson(a)).toList();
      return Right(achievements);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getRecent'));
    }
  }

  Future<Either<AppError, Achievement>> award({
    required String userId,
    required String type,
    required String title,
    required String description,
    required int streakCount,
    required String badgeImagePath,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'type': type,
        'title': title,
        'description': description,
        'earned_at': DateTime.now().toIso8601String(),
        'streak_count': streakCount,
        'badge_image_path': badgeImagePath,
      };

      final response =
          await _supabase.from('achievements').insert(data).select().single();
      return Right(Achievement.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.award'));
    }
  }

  Future<Either<AppError, bool>> hasAchievement(
      String userId, String type) async {
    try {
      final response = await _supabase
          .from('achievements')
          .select('id')
          .eq('user_id', userId)
          .eq('type', type)
          .maybeSingle();

      return Right(response != null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.hasAchievement'));
    }
  }
}
