import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppLogger {
  static final Logger _logger = Logger('ProDiet');

  static void init() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
    Logger.root.onRecord.listen(_handleLogRecord);
  }

  static void _handleLogRecord(LogRecord record) {
    // 1. Console Output (Debug only)
    if (kDebugMode) {
      debugPrint('${record.time}: [${record.level.name}] ${record.message}');
      if (record.error != null) debugPrint('Error: ${record.error}');
      if (record.stackTrace != null) debugPrint('StackTrace: ${record.stackTrace}');
    }

    // 2. Crashlytics Integration (Production only)
    if (!kDebugMode && record.level >= Level.SEVERE) {
      FirebaseCrashlytics.instance.recordError(
        record.error ?? record.message,
        record.stackTrace,
        reason: record.message,
        fatal: record.level == Level.SHOUT,
      );
    } else if (!kDebugMode) {
      FirebaseCrashlytics.instance.log('[${record.level.name}] ${record.message}');
    }
  }

  static void debug(String message) => _logger.fine(message);
  static void info(String message) => _logger.info(message);
  static void warning(String message) => _logger.warning(message);
  static void error(String message, [Object? error, StackTrace? stack]) => 
      _logger.severe(message, error, stack);
  static void critical(String message, [Object? error, StackTrace? stack]) => 
      _logger.shout(message, error, stack);
}
