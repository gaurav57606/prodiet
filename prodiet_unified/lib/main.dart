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
import 'package:firebase_messaging/firebase_messaging.dart';
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
    GoogleFonts.config.allowRuntimeFetching = false;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logger.e('Flutter Error: ${details.exception}',
          error: details.exception, stackTrace: details.stack);
      if (!kIsWeb) {
        try {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        } catch (_) {}
      }
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.e('Platform Error: $error', error: error, stackTrace: stack);
      if (!kIsWeb) {
        try {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        } catch (_) {}
      }
      return true;
    };

    // 2. Validate config before initializing Supabase
    final configError = AppConfig.validate();
    if (configError != null) {
      runApp(_ConfigErrorApp(message: configError));
      return;
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

      // 4. Background messaging handler (must be a top-level function)
      // Only relevant for Android/iOS
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      }
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
                    const Icon(Icons.settings_suggest_rounded, size: 64, color: Colors.white60),
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

class _ConfigErrorApp extends StatelessWidget {
  const _ConfigErrorApp({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 48, color: Color(0xFFF5A623)),
                const SizedBox(height: 20),
                const Text(
                  'Build Config Error',
                  style: TextStyle(
                    color: Color(0xFFF5A623),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: SelectableText(
                    message,
                    style: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 13,
                      fontFamily: 'monospace',
                      height: 1.6,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'This screen only appears when the app is run\nwithout the required environment variables.',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `Firebase.initializeApp()` before using other Firebase services.
  await Firebase.initializeApp();
  logger.i("Handling a background message: ${message.messageId}");
}
