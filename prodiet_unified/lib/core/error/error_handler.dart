import 'package:flutter/foundation.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:logger/logger.dart' as dev_logger;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

class ErrorHandler {
  static final _logger = dev_logger.Logger(
    printer: dev_logger.PrettyPrinter(methodCount: 0),
  );

  /// Centralized error handling for the entire app.
  /// Maps errors to user-friendly [AppError] and logs to Crashlytics in production.
  static AppError handle(Object error, {String? context, StackTrace? stackTrace}) {
    final AppError appError = _mapToAppError(error, context);

    // 1. Log to console (Debug only)
    if (kDebugMode) {
      _logger.e('Error Context: $context\nMessage: ${appError.message}', error: error, stackTrace: stackTrace);
    }

    // 2. Log to Crashlytics (Release only)
    if (!kDebugMode && !kIsWeb) {
      _logToCrashlytics(error, appError, context, stackTrace);
    }

    return appError;
  }

  static AppError _mapToAppError(Object error, String? context) {
    final prefix = context != null ? '[$context] ' : '';

    if (error is AuthException) {
      return AuthError(message: error.message, code: error.statusCode ?? '');
    } else if (error is PostgrestException) {
      return DatabaseError(message: '$prefix${error.message}');
    } else if (error is AppError) {
      return error;
    }
    
    return UnknownError(message: '$prefix${error.toString()}');
  }

  static void _logToCrashlytics(Object error, AppError appError, String? context, StackTrace? stackTrace) {
    try {
      final crash = FirebaseCrashlytics.instance;
      
      // Determine severity based on error types
      ErrorSeverity severity = ErrorSeverity.low;
      if (appError is DatabaseError) {
        severity = ErrorSeverity.high;
      } else if (appError is AuthError) {
        severity = ErrorSeverity.medium;
      } else if (appError is UnknownError) {
        severity = ErrorSeverity.critical;
      }
      
      // Classify feature tagging based on context
      String feature = 'general';
      final ctxLower = (context ?? '').toLowerCase();
      if (ctxLower.contains('sync')) {
        feature = 'sync_engine';
        crash.setCustomKey('sync_error', 'true');
      } else if (ctxLower.contains('ocr') || ctxLower.contains('scan')) {
        feature = 'ocr_scanner';
        crash.setCustomKey('ocr_error', 'true');
      } else if (ctxLower.contains('meal')) {
        feature = 'meal_planner';
      } else if (ctxLower.contains('water')) {
        feature = 'water';
      } else if (ctxLower.contains('auth')) {
        feature = 'auth';
      }

      crash.setCustomKey('error_context', context ?? 'unknown');
      crash.setCustomKey('app_error_type', appError.runtimeType.toString());
      crash.setCustomKey('severity', severity.name);
      crash.setCustomKey('feature', feature);
      
      final preservedStack = stackTrace ?? 
          (error is Error ? error.stackTrace : StackTrace.current);

      crash.recordError(
        error, 
        preservedStack,
        reason: appError.message,
        fatal: severity == ErrorSeverity.critical,
      );
    } catch (_) {}
  }
}
