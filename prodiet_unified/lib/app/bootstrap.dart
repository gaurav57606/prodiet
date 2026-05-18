import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:prodiet_unified/core/config/app_config.dart';
import 'package:prodiet_unified/core/widgets/error_boundary.dart';
import 'package:prodiet_unified/core/security/secure_supabase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:prodiet_unified/core/observability/monitoring/app_health_monitor.dart';

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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background isolate
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

class Bootstrap {
  static Future<void> run(FutureOr<Widget> Function() builder) async {
    AppHealthMonitor.markStartupStart();
    await runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      
      // 1. Parallelize non-dependent initializations
      await Future.wait([
        _initSystemSettings(),
        _initBackend(),
      ]);

      runApp(await builder());
    }, (Object error, StackTrace stack) {
      _handleGlobalError(error, stack);
    });
  }

  static Future<void> _initSystemSettings() async {
    ErrorBoundary.setup();
    GoogleFonts.config.allowRuntimeFetching = false;
    tz.initializeTimeZones();
  }

  static Future<void> _initBackend() async {
    // Validate config first
    final configError = AppConfig.validate();
    if (configError != null) {
      throw Exception('Config Error: $configError');
    }

    // Initialize Supabase and Firebase in parallel
    await Future.wait([
      Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          localStorage: SecureSupabaseStorage(),
        ),
      ),
      if (!kIsWeb) _initFirebase(),
    ]);
  }

  static Future<void> _initFirebase() async {
    try {
      await Firebase.initializeApp();
      
      // Configure Crashlytics
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
      
      // Catch-all for Flutter-level errors
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      // Background messaging
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      logger.e('Firebase initialization failed: $e');
    }
  }

  static void _handleGlobalError(Object error, StackTrace stack) {
    logger.e('Critical Failure: $error', error: error, stackTrace: stack);
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
  }
}
