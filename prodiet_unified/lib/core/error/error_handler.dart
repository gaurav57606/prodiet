import 'package:flutter/foundation.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:logger/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorHandler {
  static final _logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  /// Centralized error handling for the entire app.
  /// Maps errors to user-friendly [AppError] and logs to Crashlytics in production.
  static AppError handle(Object error, {String? context}) {
    final AppError appError = _mapToAppError(error, context);

    // 1. Log to console (Debug only)
    if (kDebugMode) {
      _logger.e('Error Context: $context\nMessage: ${appError.message}', error: error);
    }

    // 2. Log to Crashlytics (Release only)
    if (!kDebugMode && !kIsWeb) {
      _logToCrashlytics(error, appError, context);
    }

    return appError;
  }

  static AppError _mapToAppError(Object error, String? context) {
    final prefix = context != null ? '[$context] ' : '';

    if (error is AuthException) {
      return AuthError(message: error.message, code: error.statusCode);
    } else if (error is PostgrestException) {
      return DatabaseError(message: '$prefix${error.message}');
    } else if (error is AppError) {
      return error;
    }
    
    return UnknownError(message: '$prefix${error.toString()}');
  }

  static void _logToCrashlytics(Object error, AppError appError, String? context) {
    try {
      final crash = FirebaseCrashlytics.instance;
      crash.setCustomKey('error_context', context ?? 'unknown');
      crash.setCustomKey('app_error_type', appError.runtimeType.toString());
      
      crash.recordError(
        error, 
        error is Error ? error.stackTrace : StackTrace.current,
        reason: appError.message,
        fatal: false,
      );
    } catch (_) {}
  }
}
