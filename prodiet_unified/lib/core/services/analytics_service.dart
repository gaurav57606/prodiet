import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (kIsWeb) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logScreen(String name) async {
    if (kIsWeb) return;
    await _analytics.logScreenView(screenName: name);
  }

  Future<void> setUserId(String id) async {
    if (kIsWeb) return;
    await _analytics.setUserId(id: id);
  }

  Future<void> setUserProperty(String name, String value) async {
    if (kIsWeb) return;
    await _analytics.setUserProperty(name: name, value: value);
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
