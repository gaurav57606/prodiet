import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Structured taxonomy for all app events.
/// Format: category.action.result (e.g. 'auth.login.success')
class AppAnalyticsEvent {
  final String name;
  final Map<String, Object>? parameters;

  const AppAnalyticsEvent(this.name, [this.parameters]);

  // Auth Taxonomy
  static AppAnalyticsEvent authLoginStarted() => const AppAnalyticsEvent('auth.login.started');
  static AppAnalyticsEvent authLoginSuccess(String method) => AppAnalyticsEvent('auth.login.success', {'method': method});
  static AppAnalyticsEvent authLoginFailed(String error) => AppAnalyticsEvent('auth.login.failed', {'error': error});
  static AppAnalyticsEvent authLogout() => const AppAnalyticsEvent('auth.logout');

  // Meal Taxonomy
  static AppAnalyticsEvent mealScanStarted() => const AppAnalyticsEvent('meal.scan.started');
  static AppAnalyticsEvent mealScanSuccess(double calories, {int? durationMs}) => AppAnalyticsEvent('meal.scan.success', {
    'calories': calories,
    if (durationMs != null) 'duration_ms': durationMs,
  });
  static AppAnalyticsEvent mealScanFailed(String error) => AppAnalyticsEvent('meal.scan.failed', {'error': error});
  static AppAnalyticsEvent mealLogged(String type) => AppAnalyticsEvent('meal.logged', {'type': type});

  // Sync Taxonomy
  static AppAnalyticsEvent syncStarted() => const AppAnalyticsEvent('sync.started');
  static AppAnalyticsEvent syncSuccess(int count, {int? durationMs}) => AppAnalyticsEvent('sync.success', {
    'count': count,
    if (durationMs != null) 'duration_ms': durationMs,
  });
  static AppAnalyticsEvent syncFailed(String error) => AppAnalyticsEvent('sync.failed', {'error': error});
  static AppAnalyticsEvent syncRetry(int attempt) => AppAnalyticsEvent('sync.retry', {'attempt': attempt});

  // UI/Navigation Taxonomy
  static AppAnalyticsEvent dashboardLoaded() => const AppAnalyticsEvent('dashboard.loaded');
  static AppAnalyticsEvent screenView(String screenName) => AppAnalyticsEvent('navigation.screen_view', {'screen': screenName});

  // Health Taxonomy
  static AppAnalyticsEvent healthConnectStarted() => const AppAnalyticsEvent('health.connect.started');
  static AppAnalyticsEvent healthConnectSuccess() => const AppAnalyticsEvent('health.connect.success');
  static AppAnalyticsEvent healthConnectFailed(String error) => AppAnalyticsEvent('health.connect.failed', {'error': error});

  // Performance (App Health Monitoring)
  static AppAnalyticsEvent performanceStartup(int durationMs) => AppAnalyticsEvent('performance.startup', {'duration_ms': durationMs});
  static AppAnalyticsEvent performanceOcr(int durationMs) => AppAnalyticsEvent('performance.ocr', {'duration_ms': durationMs});
  static AppAnalyticsEvent performanceSync(int durationMs) => AppAnalyticsEvent('performance.sync', {'duration_ms': durationMs});
  static AppAnalyticsEvent performanceMemoryPressure(String level) => AppAnalyticsEvent('performance.memory_pressure', {'level': level});
  static AppAnalyticsEvent performanceAsyncFailed(String operation, String error) => AppAnalyticsEvent('performance.async_failed', {
    'operation': operation,
    'error': error,
  });
}

class AnalyticsManager {
  final FirebaseAnalytics _analytics;

  AnalyticsManager({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  /// Log a structured, type-safe AppAnalyticsEvent
  Future<void> logEvent(AppAnalyticsEvent event) async {
    if (kIsWeb) return;
    
    // Sanitize taxonomy dot format to underscore for Firebase Analytics limits
    final firebaseEventName = event.name.replaceAll('.', '_');
    
    await _analytics.logEvent(
      name: firebaseEventName,
      parameters: event.parameters,
    );
  }

  /// Direct raw event logging (for backwards-compatibility layers)
  Future<void> logRawEvent(String name, [Map<String, Object>? parameters]) async {
    if (kIsWeb) return;
    final firebaseEventName = name.replaceAll('.', '_');
    await _analytics.logEvent(
      name: firebaseEventName,
      parameters: parameters,
    );
  }

  Future<void> logScreen(String screenName) async {
    if (kIsWeb) return;
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> setUserId(String userId) async {
    if (kIsWeb) return;
    await _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty(String name, String value) async {
    if (kIsWeb) return;
    await _analytics.setUserProperty(name: name, value: value);
  }
}
