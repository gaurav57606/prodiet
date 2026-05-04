import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:prodiet_unified/core/config/app_config.dart';
import 'package:prodiet_unified/core/widgets/error_boundary.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
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
    GoogleFonts.config.allowRuntimeFetching = false;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logger.e('Flutter Error: ${details.exception}',
          error: details.exception, stackTrace: details.stack);
      // Only call Crashlytics after Firebase is initialized
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      } catch (_) {}
      ErrorBoundary.reportError(
          details.exception, details.stack ?? StackTrace.empty);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.e('Platform Error: $error', error: error, stackTrace: stack);
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } catch (_) {}
      return true;
    };

    // 1. Validate config FIRST — throws StateError with clear message if keys missing
    // This replaces the old assert() which was silently skipped in release/profile builds
    AppConfig.assertValid();

    // 2. Initialize timezone (for local notifications)
    tz.initializeTimeZones();

    // 3. Init Supabase
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );

    // 4. Init Firebase — wrapped so a bad google-services.json shows a clear error
    try {
      await Firebase.initializeApp();
      // Enable Crashlytics in release; disable verbose logging in debug
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    } catch (e, st) {
      logger.e('Firebase init failed: $e', error: e, stackTrace: st);
      // App can still run without Firebase — Supabase is the primary backend
    }

    // 5. Wire FCM navigator to GoRouter's root navigator key
    AppRouterNavigator.setKey(appRouterNavigatorKey);

    logger.i('[Main] All services initialized. '
        'Supabase: ${AppConfig.supabaseUrl.substring(0, 20)}...');

    runApp(
      const ProviderScope(
        child: ErrorBoundary(
          child: ProDietApp(),
        ),
      ),
    );
  }, (Object error, StackTrace stack) {
    logger.e('Zone Error: $error', error: error, stackTrace: stack);
    // Report unhandled zone errors to Crashlytics
    try {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } catch (_) {}
  });
}
