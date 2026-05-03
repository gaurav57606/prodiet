import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/services/notification_service.dart';
import 'package:logger/logger.dart';

class FcmService {
  final SupabaseClient _supabase;
  final NotificationService _localNotifications;
  final _logger = Logger();

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  FcmService(this._supabase, this._localNotifications);

  Future<void> initialize(String userId) async {
    if (kIsWeb) {
      _logger.i('[FCM] Skipping initialization on Web');
      return;
    }
    // 1. Request permissions
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      _logger.w('[FCM] Notifications not authorized by user');
      return;
    }

    // 2. Get and save FCM token
    final token = await _fcm.getToken();
    if (token != null) await _saveTokenToSupabase(userId, token);

    // 3. Foreground messages — show local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('[FCM] Foreground: ${message.notification?.title}');
      _handleMessageDisplay(message);
    });

    // 4. Background click — app was in background, user tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('[FCM] Background tap: ${message.notification?.title}');
      _handleMessageNavigation(message);
    });

    // 5. Terminated click — app was killed, user tapped notification to launch
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _logger.i('[FCM] Terminated tap: ${initialMessage.notification?.title}');
      // Small delay to let the app finish initializing before navigation
      await Future.delayed(const Duration(milliseconds: 500));
      _handleMessageNavigation(initialMessage);
    }

    // 6. Token refresh
    _fcm.onTokenRefresh.listen((newToken) async {
      await _saveTokenToSupabase(userId, newToken);
    });
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

  /// Shows a local notification for foreground messages.
  void _handleMessageDisplay(RemoteMessage message) {
    if (message.notification == null) return;
    final route = message.data['route'] as String?;
    
    _localNotifications.showNotification(
      id: message.hashCode,
      title: message.notification!.title ?? 'ProDiet Alert',
      body: message.notification!.body ?? '',
      payload: route,
    );
  }

  /// Handles navigation when a notification is tapped.
  void _handleMessageNavigation(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route == null || route.isEmpty) {
      _logger.w('[FCM] Notification tapped but no route in data payload');
      return;
    }
    _logger.i('[FCM] Navigating to: $route');
    AppRouterNavigator.navigateTo(route);
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final fcmServiceProvider = Provider<FcmService?>((ref) {
  if (kIsWeb) return null;
  final supabase = ref.watch(supabaseClientProvider);
  final notifications = ref.watch(notificationServiceProvider);
  return FcmService(supabase, notifications);
});

/// Static navigator helper — lets FCM navigate without a BuildContext.
class AppRouterNavigator {
  static GoRouter? _router;

  static void setRouter(GoRouter router) {
    _router = router;
  }

  static void navigateTo(String route) {
    if (_router == null) {
      debugPrint('[AppRouterNavigator] Router not set!');
      return;
    }
    // Use go() to replace stack or push() to add on top
    _router!.push(route);
  }
}
