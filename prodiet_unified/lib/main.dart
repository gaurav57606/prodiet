import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/app/app.dart';
import 'package:prodiet_unified/app/bootstrap.dart';
import 'package:prodiet_unified/core/widgets/error_boundary.dart';
import 'package:prodiet_unified/core/services/sync_worker.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';

void main() async {
  final container = ProviderContainer();

  await Bootstrap.run(() => UncontrolledProviderScope(
    container: container,
    child: const ErrorBoundary(
      child: ProDietApp(),
    ),
  ));

  // Initialize background services
  container.read(syncWorkerProvider).initialize();
  
  // FCM init happens when user is logged in, usually handled in AuthProvider listener
  container.listen(currentUserIdProvider, (previous, next) {
    if (next.isNotEmpty) {
      container.read(fcmServiceProvider)?.initialize(next);
      container.read(syncWorkerProvider).performFullSync();
    }
  });
}
