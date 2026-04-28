import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app.dart';
import 'core/config/env.dart';

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

    // 1. Load environment variables
    await dotenv.load(fileName: '.env');

    // 2. Initialize timezone (for local notifications)
    tz.initializeTimeZones();

    // 3. Initialize Firebase (FCM push notifications only)
    await Firebase.initializeApp();

    // 4. Initialize Supabase (primary backend)
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      debug: false,
    );

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
