import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'app.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
);

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Flutter level error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e("Flutter Error: ${details.exception}", error: details.exception, stackTrace: details.stack);
      // In production, send to Crashlytics or similar service
    };

    // Platform level error handling
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.e("Platform Error: $error", error: error, stackTrace: stack);
      return true;
    };

    runApp(
      const ProviderScope(
        child: DietMateApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    logger.e("Zone Error: $error", error: error, stackTrace: stack);
  });
}
