import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:prodiet_unified/core/config/app_config.dart';
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

    FlutterError.onError = (FlutterErrorDetails details) {
      logger.e('Flutter Error: ${details.exception}', error: details.exception, stackTrace: details.stack);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.e('Platform Error: $error', error: error, stackTrace: stack);
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // 1. Initialize timezone (for local notifications)
    tz.initializeTimeZones();

    // 2. Init Supabase with secure config
    AppConfig.assertValid();
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );

    // Init Firebase
    await Firebase.initializeApp();

    logger.i('[Main] All services initialized');

    runApp(
      const ProviderScope(
        child: ProDietApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    logger.e('Zone Error: $error', error: error, stackTrace: stack);
  });
}
