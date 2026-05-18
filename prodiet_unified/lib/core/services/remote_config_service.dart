import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  // Local fallback configurations if Firebase is unreachable or fails
  static const Map<String, dynamic> _defaultConfig = {
    'feature_ocr_enabled': true,
    'feature_social_feed': false,
    'sync_interval_seconds': 30,
    'app_maintenance_mode': false,
    'ocr_confidence_threshold': 0.75,
  };

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    if (kIsWeb) return;

    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: kDebugMode ? const Duration(minutes: 1) : const Duration(hours: 1),
      ));

      await _remoteConfig.setDefaults(_defaultConfig);
      
      // Perform background fetch-and-activate
      await _remoteConfig.fetchAndActivate();
      
      AppLogger.info('[RemoteConfig] Successfully initialized and activated.');

      // Listen for dynamic updates in real-time
      _remoteConfig.onConfigUpdated.listen((event) async {
        await _remoteConfig.activate();
        AppLogger.info('[RemoteConfig] Real-time config updated: ${event.updatedKeys}');
      });
    } catch (e, st) {
      AppLogger.error(
        '[RemoteConfig] Initialization failed. Falling back to local defaults.',
        error: e,
        stack: st,
        feature: 'remote_config',
      );
    }
  }

  /// Helper to safely retrieve values with local fallbacks
  T _getValue<T>(String key, T defaultValue) {
    if (kIsWeb) return defaultValue;

    try {
      if (T == bool) {
        return _remoteConfig.getBool(key) as T;
      } else if (T == int) {
        return _remoteConfig.getInt(key) as T;
      } else if (T == double) {
        return _remoteConfig.getDouble(key) as T;
      } else if (T == String) {
        return _remoteConfig.getString(key) as T;
      }
    } catch (e) {
      AppLogger.warning('[RemoteConfig] Error fetching key "$key", using fallback: $defaultValue');
    }
    return defaultValue;
  }

  // ==========================================
  // TYPE-SAFE CONFIGURATION ACCESSORS
  // ==========================================

  /// Check if the AI OCR Scanning engine is globally enabled
  bool get isOcrEnabled => _getValue<bool>('feature_ocr_enabled', true);

  /// Toggle social community feed feature
  bool get isSocialFeedEnabled => _getValue<bool>('feature_social_feed', false);

  /// Interval parameter for background database synchronization
  int get syncIntervalSeconds => _getValue<int>('sync_interval_seconds', 30);

  /// Emergency maintenance kill switch block
  bool get isMaintenanceMode => _getValue<bool>('app_maintenance_mode', false);

  /// Dynamic A/B test parameters (e.g. OCR scanner confidence cutoff)
  double get ocrConfidenceThreshold => _getValue<double>('ocr_confidence_threshold', 0.75);
}
