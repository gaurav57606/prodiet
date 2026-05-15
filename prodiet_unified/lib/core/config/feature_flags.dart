import 'package:flutter/foundation.dart';
import '../observability/logger/app_logger.dart';

enum AppEnvironment { dev, staging, prod }

class FeatureFlags {
  static AppEnvironment environment = kDebugMode ? AppEnvironment.dev : AppEnvironment.prod;

  /// In-memory cache for dynamic flags
  static final Map<String, bool> _dynamicFlags = {};

  static void updateFlags(Map<String, bool> newFlags) {
    _dynamicFlags.addAll(newFlags);
    AppLogger.info('Feature flags updated: $_dynamicFlags');
  }

  static bool isEnabled(String flag, {bool defaultValue = false}) {
    return _dynamicFlags[flag] ?? defaultValue;
  }

  // Static keys for type-safe access
  static bool get ocrEnabled => isEnabled('ocr_enabled', defaultValue: kDebugMode);
  static bool get aiPlanEnabled => isEnabled('ai_plan_enabled', defaultValue: true);
  static bool get voiceLogEnabled => isEnabled('voice_log_enabled', defaultValue: false);
  static bool get premiumDashboard => isEnabled('premium_dashboard', defaultValue: environment != AppEnvironment.dev);
}
