import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'app.dart';

final logger = Logger();

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      logger.e("Flutter Error", error: details.exception, stackTrace: details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      logger.e("Platform Error", error: error, stackTrace: stack);
      return true;
    };

    runApp(
      const ProviderScope(
        child: DietMateApp(),
      ),
    );
  }, (error, stack) {
    logger.f("Zone Error", error: error, stackTrace: stack);
  });
}
