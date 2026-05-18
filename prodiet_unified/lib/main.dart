import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/app/app.dart';
import 'package:prodiet_unified/app/bootstrap.dart';
import 'package:prodiet_unified/core/widgets/error_boundary.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import 'package:prodiet_unified/core/sync/sync_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';
import 'package:prodiet_unified/core/observability/health/app_health_monitor.dart';

void main() async {
  AppHealthMonitor.startTrace('app_startup');
  
  final container = ProviderContainer();

  await Bootstrap.run(() async {
    // 1. Init Logging
    AppLogger.init();
    
    // 2. Init Remote Config
    await container.read(remoteConfigServiceProvider).initialize();
    
    return UncontrolledProviderScope(
      container: container,
      child: const ErrorBoundary(
        child: ProDietApp(),
      ),
    );
  });

  // 3. Initialize background services
  container.read(syncManagerProvider).start();
  
  // 4. Auth Dependent Inits
  container.listen(currentUserIdProvider, (previous, next) {
    if (next.isNotEmpty) {
      container.read(fcmServiceProvider)?.initialize(next);
      container.read(syncManagerProvider).processQueue();
      container.read(analyticsManagerProvider).setUserId(next);
    }
  });

  AppHealthMonitor.stopTrace('app_startup');
}
