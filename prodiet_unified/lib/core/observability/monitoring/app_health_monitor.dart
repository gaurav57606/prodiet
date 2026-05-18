import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/observability/analytics/analytics_manager.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

class AppHealthMonitor {
  final AnalyticsManager _analytics;
  static DateTime? _startupTime;

  AppHealthMonitor(this._analytics);

  /// Captures app startup baseline time
  static void markStartupStart() {
    _startupTime = DateTime.now();
  }

  /// Records and logs the startup duration
  void recordStartupComplete() {
    if (_startupTime == null) return;
    final duration = DateTime.now().difference(_startupTime!).inMilliseconds;
    
    AppLogger.info('[HealthMonitor] Startup completed in ${duration}ms');
    _analytics.logEvent(AppAnalyticsEvent.performanceStartup(duration));
  }

  /// Tracks receipt/meal OCR scanning speed
  void recordOcrDuration(int durationMs) {
    AppLogger.info('[HealthMonitor] OCR processed in ${durationMs}ms');
    _analytics.logEvent(AppAnalyticsEvent.performanceOcr(durationMs));
  }

  /// Tracks database offline synchronization duration
  void recordSyncDuration(int durationMs) {
    AppLogger.info('[HealthMonitor] Sync completed in ${durationMs}ms');
    _analytics.logEvent(AppAnalyticsEvent.performanceSync(durationMs));
  }

  /// Tracks loading latency for premium screen experiences
  void recordScreenLoad(String screenName, int durationMs) {
    AppLogger.info('[HealthMonitor] Screen "$screenName" loaded in ${durationMs}ms');
    _analytics.logEvent(AppAnalyticsEvent('performance.screen_load', {
      'screen': screenName,
      'duration_ms': durationMs,
    }));
  }

  /// Monitors local system memory pressure levels
  void recordMemoryPressure(String level) {
    AppLogger.warning('[HealthMonitor] System reported memory pressure: $level');
    _analytics.logEvent(AppAnalyticsEvent.performanceMemoryPressure(level));
  }

  /// Reports non-fatal failed async operations
  void recordFailedAsyncOperation(String operation, Object error) {
    AppLogger.error('[HealthMonitor] Async operation failed: $operation', error: error);
    _analytics.logEvent(AppAnalyticsEvent.performanceAsyncFailed(operation, error.toString()));
  }
}

final appHealthMonitorProvider = Provider<AppHealthMonitor>((ref) {
  final analytics = AnalyticsManager();
  return AppHealthMonitor(analytics);
});
