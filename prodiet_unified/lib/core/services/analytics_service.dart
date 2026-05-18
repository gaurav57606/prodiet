import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/observability/analytics/analytics_manager.dart';

class AnalyticsService {
  final AnalyticsManager _manager;

  AnalyticsService({AnalyticsManager? manager})
      : _manager = manager ?? AnalyticsManager();

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _manager.logRawEvent(name, parameters);
  }

  Future<void> logScreen(String name) async {
    await _manager.logScreen(name);
  }

  Future<void> setUserId(String id) async {
    await _manager.setUserId(id);
  }

  Future<void> setUserProperty(String name, String value) async {
    await _manager.setUserProperty(name, value);
  }

  Future<void> startSession(
    String userId, {
    required String deviceModel,
    required String osVersion,
    required String appVersion,
  }) async {
    if (kIsWeb) return;
    await setUserId(userId);
    await setUserProperty('device_model', deviceModel);
    await setUserProperty('os_version', osVersion);
    await setUserProperty('app_version', appVersion);
    await _manager.logEvent(const AppAnalyticsEvent('auth.login.success', {'method': 'session_restore'}));
  }

  Future<void> endSession(String userId) async {
    if (kIsWeb) return;
    await _manager.logEvent(const AppAnalyticsEvent('auth.logout'));
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
