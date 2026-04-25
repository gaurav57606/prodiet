import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set up global error handlers
    FlutterError.onError = (details) {
      log('Flutter Error: ${details.exception}', stackTrace: details.stack);
      if (kReleaseMode) {
        // Here you would send to Crashlytics
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      log('Platform Error: $error', stackTrace: stack);
      return true;
    };

    runApp(
      const ProviderScope(
        child: DietMateApp(),
      ),
    );
  }, (error, stack) {
    log('Zone Error: $error', stackTrace: stack);
  });
}
