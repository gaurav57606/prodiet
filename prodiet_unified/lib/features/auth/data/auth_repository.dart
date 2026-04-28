import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../../../main.dart'; // for logger
import '../domain/models/app_user.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  static const String _tag = 'AuthRepository';

  AuthRepository(this._supabase);

  Future<Either<AppError, AppUser>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    logger.i('[$_tag] signUp: $email');
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return const Left(UnknownError(message: 'Sign up failed: User is null'));
      }

      final now = DateTime.now().toIso8601String();
      final profileData = {
        'id': user.id,
        'email': email,
        'name': name,
        'onboarding_complete': false,
        'daily_water_goal_ml': 2000,
        'variety_preference': 'balanced',
        'created_at': now,
        'updated_at': now,
      };

      await _supabase.from('users').upsert(profileData);

      return _fetchProfile(user.id);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.signUp'));
    }
  }

  Future<Either<AppError, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    logger.i('[$_tag] signIn: $email');
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return const Left(UnknownError(message: 'Sign in failed: User is null'));
      }

      return _fetchProfile(user.id);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.signIn'));
    }
  }

  Future<Either<AppError, void>> signOut() async {
    logger.i('[$_tag] signOut');
    try {
      await _supabase.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.signOut'));
    }
  }

  Future<Either<AppError, void>> sendPasswordReset(String email) async {
    logger.i('[$_tag] sendPasswordReset: $email');
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.sendPasswordReset'));
    }
  }

  Future<Either<AppError, AppUser?>> getSessionUser() async {
    logger.i('[$_tag] getSessionUser');
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return const Right(null);

      final profileResult = await _fetchProfile(user.id);
      return profileResult.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getSessionUser'));
    }
  }

  Future<Either<AppError, AppUser>> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    logger.i('[$_tag] updateProfile: $userId');
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      await _supabase.from('users').update(data).eq('id', userId);
      return _fetchProfile(userId);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.updateProfile'));
    }
  }

  Future<Either<AppError, void>> saveToken(String userId, String fcmToken) async {
    logger.i('[$_tag] saveToken: $userId');
    try {
      await _supabase.from('users').update({'fcm_token': fcmToken}).eq('id', userId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.saveToken'));
    }
  }

  Future<Either<AppError, AppUser>> _fetchProfile(String userId) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return Right(AppUser.fromJson(data));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag._fetchProfile'));
    }
  }
}
