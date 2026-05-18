import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  // Note: initialize() should be called during app bootstrap
  // or via a dedicated initializer.
  return service;
});
