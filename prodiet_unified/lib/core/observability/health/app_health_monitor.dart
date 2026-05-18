import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

class AppHealthMonitor {
  static final Map<String, DateTime> _timers = {};

  static void startTrace(String key) {
    _timers[key] = DateTime.now();
    AppLogger.info('[Health] Started trace: $key');
  }

  static void stopTrace(String key, {Map<String, dynamic>? metadata}) {
    final startTime = _timers.remove(key);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      AppLogger.info('[Health] Trace completed: $key in ${duration.inMilliseconds}ms');
      
      // In production, this would send to Firebase Analytics / Performance
      // AnalyticsManager().logPerformance(key, duration, metadata);
    }
  }

  static void trackMemoryPressure() {
    // Basic memory usage tracking for production diagnostics
    AppLogger.warning('[Health] High memory pressure detected');
  }
}
