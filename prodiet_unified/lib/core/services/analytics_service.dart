import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AnalyticsService {
  final SupabaseClient _client;
  String? _currentSessionId;
  // ignore: unused_field
  static const _tag = 'Analytics';

  AnalyticsService(this._client);

  // ── SESSION ──────────────────────────────────────────
  Future<void> startSession(String userId, {
    required String deviceModel,
    required String osVersion,
    required String appVersion,
  }) async {
    _currentSessionId = const Uuid().v4();
    await _client.from('analytics.user_sessions').insert({
      'id': _currentSessionId,
      'user_id': userId,
      'device_model': deviceModel,
      'os_version': osVersion,
      'app_version': appVersion,
      'session_start': DateTime.now().toIso8601String(),
    });
    // Update retention flag
    await _upsertRetentionFlag(userId);
  }

  Future<void> endSession(String userId) async {
    if (_currentSessionId == null) return;
    final now = DateTime.now();
    await _client
      .from('analytics.user_sessions')
      .update({'session_end': now.toIso8601String()})
      .eq('id', _currentSessionId!);
    _currentSessionId = null;
  }

  // ── SCREEN VIEWS ──────────────────────────────────────
  Future<void> logScreen(String userId, String screenName) async {
    await _client.from('analytics.screen_views').insert({
      'user_id': userId,
      'session_id': _currentSessionId,
      'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ── FEATURE EVENTS ─────────────────────────────────────
  Future<void> logEvent(
    String userId,
    String eventName, {
    Map<String, dynamic>? data,
    String? screen,
  }) async {
    await _client.from('analytics.feature_events').insert({
      'user_id': userId,
      'session_id': _currentSessionId,
      'event_name': eventName,
      'event_data': data,
      'screen': screen,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ── ERRORS ─────────────────────────────────────────────
  Future<void> logError(String userId, String screen, String errorMsg) async {
    await _client.from('analytics.error_logs').insert({
      'user_id': userId,
      'screen': screen,
      'error_message': errorMsg,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ── RETENTION ─────────────────────────────────────────
  Future<void> _upsertRetentionFlag(String userId) async {
    await _client.from('analytics.retention_flags').upsert({
      'user_id': userId,
      'last_seen': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');
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
