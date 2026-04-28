import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/services/notification_service.dart';
import 'package:logger/logger.dart';

class FcmService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final SupabaseClient _supabase;
  final NotificationService _localNotifications;
  final _logger = Logger();

  FcmService(this._supabase, this._localNotifications);

  Future<void> initialize(String userId) async {
    // 1. Request permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get FCM token
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToSupabase(userId, token);
      }

      // 3. Setup onMessage handler (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _logger.i('Foreground message received: ${message.notification?.title}');
        if (message.notification != null) {
          _localNotifications.scheduleLowStockAlert(message.notification!.title ?? 'Alert');
        }
      });

      // 4. Handle token refresh
      _fcm.onTokenRefresh.listen((newToken) async {
        await _saveTokenToSupabase(userId, newToken);
      });
    }
  }

  Future<void> _saveTokenToSupabase(String userId, String token) async {
    try {
      await _supabase.from('users').update({
        'fcm_token': token,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      _logger.i('FCM Token saved to Supabase');
    } catch (e) {
      _logger.e('Error saving FCM token: $e');
    }
  }
}

final fcmServiceProvider = Provider<FcmService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  // We need a way to get notification service, maybe another provider
  return FcmService(supabase, NotificationService());
});
