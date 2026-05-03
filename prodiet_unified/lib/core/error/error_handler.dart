import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_error.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Maps any exception to a typed [AppError] AND logs it to Crashlytics
  /// as a non-fatal event with context tags for dashboard filtering.
  static AppError handle(Object error, {String? context}) {
    final tag = context != null ? '[$context] ' : '';
    final AppError appError;

    if (error is AuthException) {
      appError = AuthError(
        message: '$tag${error.message}',
        code: 'AUTH_${error.statusCode ?? "ERR"}',
      );
    } else if (error is PostgrestException) {
      appError = DatabaseError(message: '$tag${error.message}');
    } else if (error is StorageException) {
      appError = ServerError(message: '$tag${error.message}');
    } else if (error is AppError) {
      appError = error;
    } else {
      appError = UnknownError(message: '$tag${error.toString()}');
    }

    // Log non-fatal to Crashlytics with context for dashboard filtering
    _logToCrashlytics(error, appError, context: context);

    return appError;
  }

  static void _logToCrashlytics(
    Object originalError,
    AppError appError, {
    String? context,
  }) {
    if (kIsWeb) return; // Crashlytics not initialized on Web
    try {
      // Add key-value context tags visible in Crashlytics dashboard
      final crashlytics = FirebaseCrashlytics.instance;

      crashlytics.setCustomKey('error_type', appError.runtimeType.toString());
      if (context != null) {
        crashlytics.setCustomKey('error_context', context);
      }
      if (appError is AuthError) {
        crashlytics.setCustomKey('auth_error_code', appError.code);
      }

      // Record as non-fatal — shows in "Non-fatals" tab in Crashlytics
      crashlytics.recordError(
        originalError,
        originalError is Error ? originalError.stackTrace : null,
        reason: appError.message,
        fatal: false,
        printDetails: false, // avoid double-logging since logger already prints
      );
    } catch (_) {
      // Never let Crashlytics logging crash the app
    }
  }
}
