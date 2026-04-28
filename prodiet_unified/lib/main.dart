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
    printTime: false,
  ),
);

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e(
        'Flutter Error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.e('Platform Error: $error', error: error, stackTrace: stack);
      return true;
    };

    runApp(
      const ProviderScope(
        child: ProDietApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    logger.e('Zone Error: $error', error: error, stackTrace: stack);
  });
}
