import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/app/app.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';
import 'package:prodiet_unified/core/observability/health/app_health_monitor.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppHealthMonitor.startTrace('app_startup');
    AppLogger.init();

    // Catch Flutter framework errors early
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      AppLogger.critical('[Global] Captured Flutter error', error: details.exception, stack: details.stack);
    };

    // Catch asynchronous platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.critical('[Global] Captured asynchronous platform error', error: error, stack: stack);
      return true;
    };

    runApp(
      const ProviderScope(
        child: ProDietApp(),
      ),
    );
  }, (error, stack) {
    AppLogger.critical('[Global] Captured unhandled zoned guarded error', error: error, stack: stack);
  });
}
