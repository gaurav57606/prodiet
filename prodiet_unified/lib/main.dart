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
    ErrorBoundary.setup();
    GoogleFonts.config.allowRuntimeFetching = true;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logger.e('Flutter Error: ${details.exception}',
          error: details.exception, stackTrace: details.stack);
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      } catch (_) {}
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.e('Platform Error: $error', error: error, stackTrace: stack);
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } catch (_) {}
      return true;
    };

    // Validate config — show error UI instead of white screen if keys missing
    try {
      AppConfig.assertValid();
    } catch (e) {
      runApp(
        MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFF0D0D0D),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  '⚠️ Build Config Error\n\n$e\n\nRun with:\nflutter run --dart-define-from-file=.env.json',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
      return; // Stop execution — don't proceed to Supabase.initialize
    }

    tz.initializeTimeZones();

    try {

      // Init Supabase
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );

      // Init Firebase
      if (!kIsWeb) {
        try {
          await Firebase.initializeApp();
          await FirebaseCrashlytics.instance
              .setCrashlyticsCollectionEnabled(!kDebugMode);
        } catch (e) {
          logger.e('Firebase init failed: $e');
        }
      }

      runApp(
        const ProviderScope(
          child: ErrorBoundary(
            child: ProDietApp(),
          ),
        ),
      );
    } catch (e, st) {
      logger.e('Initialization failed: $e', error: e, stackTrace: st);
      // If initialization fails, show a clear error UI instead of a blank screen
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: const Color(0xFF111111),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⚙️', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 24),
                    const Text('Configuration Error',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(e.toString().replaceAll('StateError: ', ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFF888888), fontSize: 14)),
                    const SizedBox(height: 32),
                    const Text(
                        'Please ensure you built the app with:\n--dart-define-from-file=.env.json',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFD4F263),
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }, (Object error, StackTrace stack) {
    logger.e('Zone Error: $error', error: error, stackTrace: stack);
  });
}
