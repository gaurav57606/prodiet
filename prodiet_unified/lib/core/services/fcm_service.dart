import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/core/services/notification_service.dart';
import 'package:logger/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FcmService {
  final SupabaseClient _supabase;
  final NotificationService _localNotifications;
  final _logger = Logger();

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  FcmService(this._supabase, this._localNotifications);

  Future<void> initialize(String userId) async {
    if (kIsWeb) return;

    // 1. Request permissions
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      _logger.w('[FCM] Notifications not authorized');
      return;
    }

    // 2. Register device and token
    await _registerDevice(userId);

    // 3. Setup listeners
    _setupMessageHandlers();

    // 4. Token refresh listener
    _fcm.onTokenRefresh.listen((newToken) async {
      await _saveToken(userId, newToken);
    });
  }

  Future<void> _registerDevice(String userId) async {
    final token = await _fcm.getToken();
    if (token != null) {
      await _saveToken(userId, token);
    }
  }

  Future<void> _saveToken(String userId, String token) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = 'unknown';
      String deviceName = 'unknown_device';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'ios_unknown';
        deviceName = iosInfo.name;
      }

      // Hardened: Using user_devices table for multi-device support
      // Fallback to users table if user_devices doesn't exist yet
      try {
        await _supabase.from('user_devices').upsert({
          'user_id': userId,
          'device_id': deviceId,
          'device_name': deviceName,
          'fcm_token': token,
          'last_seen_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {
        // Legacy fallback
        await _supabase.from('users').update({
          'fcm_token': token,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', userId);
      }
      
      _logger.i('[FCM] Token registered successfully');
    } catch (e) {
      _logger.e('[FCM] Registration failed: $e');
    }
  }

  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((message) {
      _logger.i('[FCM] Foreground message received');
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _logger.i('[FCM] Notification opened app');
      _handleNavigation(message);
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification == null) return;
    
    _localNotifications.showNotification(
      id: message.hashCode,
      title: message.notification!.title ?? 'ProDiet',
      body: message.notification!.body ?? '',
      payload: message.data['route'],
    );
  }

  void _handleNavigation(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route != null && route.isNotEmpty) {
      AppRouterNavigator.navigateTo(route);
    }
  }
}

final fcmServiceProvider = Provider<FcmService?>((ref) {
  if (kIsWeb) return null;
  final supabase = ref.watch(supabaseClientProvider);
  final notifications = ref.watch(notificationServiceProvider);
  return FcmService(supabase, notifications);
});

// AppRouterNavigator remains as is for now, but should be integrated better with GoRouter in Phase 4
class AppRouterNavigator {
  static GoRouter? _router;
  static void setRouter(GoRouter router) => _router = router;
  static void navigateTo(String route) => _router?.push(route);
}
