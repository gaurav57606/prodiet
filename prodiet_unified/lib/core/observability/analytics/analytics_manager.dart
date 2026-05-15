import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../observability/logger/app_logger.dart';

class AnalyticsManager {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Tracks a custom event with properties
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      AppLogger.info('Analytics Event: $name | Params: $parameters');
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e, stack) {
      AppLogger.error('Failed to log event: $name', e, stack);
    }
  }

  /// Sets user properties for audience segmentation
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      AppLogger.info('Analytics UserProperty: $name = $value');
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e, stack) {
      AppLogger.error('Failed to set user property: $name', e, stack);
    }
  }

  /// Standard events
  static Future<void> logScreenView(String screenName) async {
    await logEvent(name: 'screen_view', parameters: {'screen_name': screenName});
  }

  static Future<void> logAuth(String method) async {
    await logEvent(name: 'login', parameters: {'method': method});
  }
}
