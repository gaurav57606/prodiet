import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/notification_service.dart';
import 'package:prodiet_unified/core/services/notification_providers.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FcmService {
  final SupabaseService _supabase;
  final NotificationService _localNotifications;
  final FirebaseMessaging _fcm;

  FcmService(
    this._supabase,
    this._localNotifications, {
    FirebaseMessaging? fcm,
  }) : _fcm = fcm ?? FirebaseMessaging.instance;

  Future<void> initialize(String userId) async {
    if (kIsWeb) return;

    try {
      // 1. Request permissions with structured flow
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      final bool capability = settings.authorizationStatus == AuthorizationStatus.authorized ||
                              settings.authorizationStatus == AuthorizationStatus.provisional;

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        AppLogger.warning('[FCM] Notifications denied by user');
      }

      // 2. Initial Registration
      await _registerDevice(userId, capability);

      // 3. Listen for token refreshes
      _fcm.onTokenRefresh.listen((newToken) async {
        AppLogger.info('[FCM] Token refreshed, updating backend');
        await _saveToken(userId, newToken, capability);
      });

      // 4. Foreground handling
      FirebaseMessaging.onMessage.listen((message) {
        AppLogger.info('[FCM] Foreground notification received');
        _showLocalNotification(message);
      });
    } catch (e, st) {
      AppLogger.error('[FCM] Failed to initialize service', error: e, stack: st, feature: 'fcm');
    }
  }

  Future<void> _registerDevice(String userId, bool capability) async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await _saveToken(userId, token, capability);
      }
    } catch (e, st) {
      AppLogger.error('[FCM] Failed to get token', error: e, stack: st, feature: 'fcm');
    }
  }

  Future<void> _saveToken(String userId, String token, bool capability) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      
      String deviceId = 'unknown';
      String platform = Platform.isAndroid ? 'android' : 'ios';
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'ios_unknown';
      }

      // Enterprise Hardening: User Devices Registry with Notification Capabilities
      await _supabase.perform((client) async {
        await client.from('user_devices').upsert({
          'user_id': userId,
          'device_id': deviceId,
          'fcm_token': token,
          'platform': platform,
          'app_version': packageInfo.version,
          'last_seen': DateTime.now().toIso8601String(),
          'is_active': true,
          'notification_capability': capability,
        });
      }, context: 'fcm.saveToken');

      AppLogger.info('[FCM] Device registry updated successfully');
    } catch (e, st) {
      AppLogger.error('[FCM] Failed to save token to registry', error: e, stack: st, feature: 'fcm');
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    if (message.notification == null) return;
    
    _localNotifications.showNotification(
      id: message.hashCode,
      title: message.notification!.title ?? 'ProDiet',
      body: message.notification!.body ?? '',
      payload: message.data['route'],
    );
  }

  /// Clean up stale tokens for this device on logout
  Future<void> signOut(String userId) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = 'unknown';
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'ios_unknown';
      }
      
      // Invalidate token locally
      await _fcm.deleteToken();
      
      // Mark device as inactive in registry to stop future push routing
      await _supabase.perform((client) async {
        await client.from('user_devices').upsert({
          'user_id': userId,
          'device_id': deviceId,
          'is_active': false,
          'last_seen': DateTime.now().toIso8601String(),
        });
      }, context: 'fcm.signOutInactivate');

      AppLogger.info('[FCM] Device marked inactive successfully on logout');
    } catch (e, st) {
      AppLogger.error('[FCM] Sign out cleanup failed', error: e, stack: st, feature: 'fcm');
    }
  }
}

final fcmServiceProvider = Provider<FcmService?>((ref) {
  if (kIsWeb) return null;
  return FcmService(
    ref.watch(supabaseServiceProvider),
    ref.watch(notificationServiceProvider),
  );
});
