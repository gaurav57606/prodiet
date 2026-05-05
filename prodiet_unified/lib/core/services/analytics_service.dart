// Analytics Architecture:
// ALL product analytics (sessions, screen views, events, errors, retention)
// are tracked via Supabase tables — NOT via Firebase Analytics.
// Firebase is used ONLY for:
//   - Crashlytics: unhandled exception capture (main.dart)
//   - FCM: push notification delivery (fcm_service.dart)
// Do NOT add firebase_analytics — it would duplicate Supabase tracking.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AnalyticsService {
  final SupabaseClient _client;
  String? _currentSessionId;
  AnalyticsService(this._client);

  // ── SESSION ──────────────────────────────────────────
  Future<void> startSession(String userId, {
    required String deviceModel,
    required String osVersion,
    required String appVersion,
  }) {
    _currentSessionId = const Uuid().v4();
    return _client.from('user_sessions').insert({
      'id': _currentSessionId,
      'user_id': userId,
      'device_model': deviceModel,
      'os_version': osVersion,
      'app_version': appVersion,
      'session_start': DateTime.now().toIso8601String(),
    }).then((_) => _upsertRetentionFlag(userId))
    .catchError((e) {
      // Silent fail
    });
  }

  Future<void> endSession(String userId) {
    if (_currentSessionId == null) return Future.value();
    final now = DateTime.now();
    final taskId = _currentSessionId;
    _currentSessionId = null;
    return _client
      .from('user_sessions')
      .update({'session_end': now.toIso8601String()})
      .eq('id', taskId!)
      .then((_) => null)
      .catchError((e) {
        // Silent fail
      });
  }

  // ── SCREEN VIEWS ──────────────────────────────────────
  Future<void> logScreen(String userId, String screenName) {
    return _client.from('screen_views').insert({
      'user_id': userId,
      'session_id': _currentSessionId,
      'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
    }).then((_) => null).catchError((e) {
      // Silent fail
    });
  }

  // ── FEATURE EVENTS ─────────────────────────────────────
  Future<void> logEvent(
    String userId,
    String eventName, {
    Map<String, dynamic>? data,
    String? screen,
  }) {
    return _client.from('feature_events').insert({
      'user_id': userId,
      'session_id': _currentSessionId,
      'event_name': eventName,
      'event_data': data,
      'screen': screen,
      'timestamp': DateTime.now().toIso8601String(),
    }).then((_) => null).catchError((e) {
      // Silent fail
    });
  }

  // ── ERRORS ─────────────────────────────────────────────
  Future<void> logError(String userId, String screen, String errorMsg) {
    return _client.from('error_logs').insert({
      'user_id': userId,
      'screen': screen,
      'error_message': errorMsg,
      'timestamp': DateTime.now().toIso8601String(),
    }).then((_) => null).catchError((e) {
      // Silent fail
    });
  }

  // ── RETENTION ─────────────────────────────────────────
  Future<void> _upsertRetentionFlag(String userId) async {
    try {
      await _client.from('retention_flags').upsert({
        'user_id': userId,
        'last_seen': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');
    } catch (e) {
      // Silent fail
    }
  }

  // ── PREDEFINED EVENT CONSTANTS ─────────────────────────
  static const String kMealLogged       = 'meal_logged';
  static const String kMealSkipped      = 'meal_skipped';
  static const String kWaterLogged      = 'water_logged';
  static const String kOcrScanStarted   = 'ocr_scan_started';
  static const String kOcrScanSuccess   = 'ocr_scan_success';
  static const String kOcrScanFailed    = 'ocr_scan_failed';
  static const String kAiPlanGenerated  = 'ai_plan_generated';
  static const String kAiCacheHit       = 'ai_cache_hit';
  static const String kCompensationUsed = 'compensation_used';
  static const String kVendorRedirect   = 'vendor_redirect';
  static const String kProgressLogged   = 'progress_logged';
  static const String kAchievementEarned= 'achievement_earned';
  static const String kInventoryUpdated = 'inventory_updated';
  static const String kSyncCompleted    = 'sync_completed';
}
