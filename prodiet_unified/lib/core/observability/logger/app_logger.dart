import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

enum ErrorSeverity { low, medium, high, critical }

class AppLogger {
  static final Logger _logger = Logger('ProDiet');

  static void init() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
    Logger.root.onRecord.listen(_handleLogRecord);
    
    // Catch-all for uncaught errors
    PlatformDispatcher.instance.onError = (error, stack) {
      critical('Uncaught error occurred', error: error, stack: stack, feature: 'platform_uncaught');
      return true;
    };
  }

  static void _handleLogRecord(LogRecord record) {
    if (kDebugMode) {
      debugPrint('${record.time}: [${record.level.name}] ${record.message}');
      if (record.error != null) debugPrint('Error: ${record.error}');
    }

    // Production Crashlytics reporting
    if (!kDebugMode && !kIsWeb) {
      final crashlytics = FirebaseCrashlytics.instance;
      if (record.level >= Level.SEVERE) {
        final severity = _getSeverity(record.level);
        
        crashlytics.setCustomKey('severity', severity.name);
        crashlytics.setCustomKey('logger_name', record.loggerName);
        
        // Extract features or tags if present in the message
        final message = record.message;
        if (message.contains('[Sync]')) {
          crashlytics.setCustomKey('feature', 'sync');
          crashlytics.setCustomKey('sync_error', 'true');
        } else if (message.contains('[OCR]')) {
          crashlytics.setCustomKey('feature', 'ocr_scanner');
          crashlytics.setCustomKey('ocr_error', 'true');
        }

        crashlytics.recordError(
          record.error ?? record.message,
          record.stackTrace ?? StackTrace.current,
          reason: record.message,
          fatal: record.level == Level.SHOUT,
        );
      } else {
        crashlytics.log('[${record.level.name}] ${record.message}');
      }
    }
  }

  static ErrorSeverity _getSeverity(Level level) {
    if (level == Level.SHOUT) return ErrorSeverity.critical;
    if (level == Level.SEVERE) return ErrorSeverity.high;
    if (level == Level.WARNING) return ErrorSeverity.medium;
    return ErrorSeverity.low;
  }

  static void debug(String message) => _logger.fine(message);
  static void info(String message) => _logger.info(message);
  static void warning(String message) => _logger.warning(message);
  
  static void error(
    String message, {
    Object? error,
    StackTrace? stack,
    String? feature,
  }) {
    if (!kDebugMode && !kIsWeb) {
      final crashlytics = FirebaseCrashlytics.instance;
      crashlytics.setCustomKey('severity', ErrorSeverity.high.name);
      if (feature != null) {
        crashlytics.setCustomKey('feature', feature);
      }
    }
    _logger.severe(message, error, stack);
  }

  static void critical(
    String message, {
    Object? error,
    StackTrace? stack,
    String? feature,
  }) {
    if (!kDebugMode && !kIsWeb) {
      final crashlytics = FirebaseCrashlytics.instance;
      crashlytics.setCustomKey('severity', ErrorSeverity.critical.name);
      if (feature != null) {
        crashlytics.setCustomKey('feature', feature);
      }
    }
    _logger.shout(message, error, stack);
  }
}
