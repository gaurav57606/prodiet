import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:prodiet_unified/core/config/app_config.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';
import 'package:prodiet_unified/core/widgets/error_boundary.dart';
import 'package:prodiet_unified/core/security/secure_supabase_storage.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

enum BootstrapState { loading, ready, failed }

final bootstrapStateProvider = StateProvider<BootstrapState>((ref) => BootstrapState.loading);
final bootstrapErrorProvider = StateProvider<Object?>((ref) => null);
final bootstrapStackTraceProvider = StateProvider<StackTrace?>((ref) => null);

enum BootstrapStep {
  systemSettings('System Settings'),
  envValidation('Environment Config'),
  firebaseInit('Firebase Observability'),
  supabaseInit('Supabase Connection'),
  remoteConfig('Feature Configuration'),
  themeLoad('User Theme Settings'),
  warmup('Warming Up Services');

  final String label;
  const BootstrapStep(this.label);
}

enum StepStatus { pending, running, success, failed }

/// Pure Flutter Startup Loading View (Uses Riverpod Centralized State)
class BootstrapLoadingScreen extends ConsumerStatefulWidget {
  const BootstrapLoadingScreen({super.key});

  @override
  ConsumerState<BootstrapLoadingScreen> createState() => _BootstrapLoadingScreenState();
}

class _BootstrapLoadingScreenState extends ConsumerState<BootstrapLoadingScreen> {
  final Map<BootstrapStep, StepStatus> _statuses = {
    for (var step in BootstrapStep.values) step: StepStatus.pending,
  };

  bool _booting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBootFlow();
    });
  }

  Future<void> _startBootFlow() async {
    if (_booting) return;
    setState(() {
      _booting = true;
      for (var step in BootstrapStep.values) {
        _statuses[step] = StepStatus.pending;
      }
    });

    try {
      // Step 1: System Settings
      await _executeStep(BootstrapStep.systemSettings, () async {
        ErrorBoundary.setup();
        GoogleFonts.config.allowRuntimeFetching = true;
        tz.initializeTimeZones();
      });

      // Step 2: Env Validation
      await _executeStep(BootstrapStep.envValidation, () async {
        final missing = AppConfig.missingVars;
        if (missing.isNotEmpty) {
          throw Exception('Required environment variables are missing.');
        }
      });

      // Step 3: Firebase Init
      await _executeStep(BootstrapStep.firebaseInit, () async {
        if (!kIsWeb) {
          try {
            await Firebase.initializeApp();
            await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
            FlutterError.onError = (details) {
              FlutterError.presentError(details);
              FirebaseCrashlytics.instance.recordFlutterFatalError(details);
            };
            FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
            AppLogger.info('[Bootstrap] Firebase initialized successfully.');
          } catch (e) {
            AppLogger.error('[Bootstrap] Firebase early initialization failure absorbed: $e');
          }
        }
      });

      // Step 4: Supabase Init
      await _executeStep(BootstrapStep.supabaseInit, () async {
        if (AppConfig.isValid) {
          await Supabase.initialize(
            url: AppConfig.supabaseUrl,
            anonKey: AppConfig.supabaseAnonKey,
            authOptions: kIsWeb
                ? const FlutterAuthClientOptions()
                : const FlutterAuthClientOptions(
                    localStorage: SecureSupabaseStorage(),
                  ),
          );
          AppLogger.info('[Bootstrap] Supabase client initialized.');
        } else {
          throw Exception('Supabase config is invalid or missing URL/Keys.');
        }
      });

      // Step 5: Remote Config
      await _executeStep(BootstrapStep.remoteConfig, () async {
        // Simulated for visual checkpoint, will lazily initialize inside Riverpod
        await Future.delayed(const Duration(milliseconds: 300));
      });

      // Step 6: Theme Load
      await _executeStep(BootstrapStep.themeLoad, () async {
        // Simulated for visual checkpoint, will initialize inside ProDietApp initState
        await Future.delayed(const Duration(milliseconds: 300));
      });

      // Step 7: Warmup
      await _executeStep(BootstrapStep.warmup, () async {
        // Simulated for visual checkpoint, sync manager will warm up inside ProDietApp scope
        await Future.delayed(const Duration(milliseconds: 300));
      });

      // Delay slightly for smooth transition animation
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        ref.read(bootstrapStateProvider.notifier).state = BootstrapState.ready;
      }
    } catch (e, st) {
      AppLogger.critical('[Bootstrap] Fatal startup sequence failure', error: e, stack: st, feature: 'bootstrap');
      if (mounted) {
        ref.read(bootstrapErrorProvider.notifier).state = e;
        ref.read(bootstrapStackTraceProvider.notifier).state = st;
        ref.read(bootstrapStateProvider.notifier).state = BootstrapState.failed;
      }
    }
  }

  Future<void> _executeStep(BootstrapStep step, Future<void> Function() action) async {
    if (!mounted) return;
    setState(() {
      _statuses[step] = StepStatus.running;
    });

    try {
      await action().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Initialization step timed out.'),
      );
      if (!mounted) return;
      setState(() {
        _statuses[step] = StepStatus.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statuses[step] = StepStatus.failed;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B5CF6);
    const surfaceColor = Color(0xFF12121A);

    return Scaffold(
      backgroundColor: surfaceColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      primaryColor.withOpacity(0.0),
                    ],
                  ),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 56,
                    width: 56,
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'PRODIET',
                style: TextStyle(
                  letterSpacing: 6,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Starting up intelligent engine...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 0.5,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: BootstrapStep.values.map((step) {
                    final status = _statuses[step] ?? StepStatus.pending;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          _buildStepIndicator(status, primaryColor),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              step.label,
                              style: TextStyle(
                                color: _getStepColor(status),
                                fontSize: 13.5,
                                fontWeight: status == StepStatus.running
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(StepStatus status, Color primary) {
    switch (status) {
      case StepStatus.pending:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
        );
      case StepStatus.running:
        return SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            color: primary,
            strokeWidth: 2,
          ),
        );
      case StepStatus.success:
        return const Icon(
          Icons.check_circle_rounded,
          size: 16,
          color: Color(0xFF4CAF50),
        );
      case StepStatus.failed:
        return const Icon(
          Icons.cancel_rounded,
          size: 16,
          color: Color(0xFFFF5252),
        );
    }
  }

  Color _getStepColor(StepStatus status) {
    switch (status) {
      case StepStatus.pending:
        return Colors.white.withOpacity(0.25);
      case StepStatus.running:
        return Colors.white;
      case StepStatus.success:
        return Colors.white.withOpacity(0.8);
      case StepStatus.failed:
        return const Color(0xFFFF5252);
    }
  }
}

/// Pure Flutter Resilient Startup Diagnostics & Fault Recovery view
class BootstrapErrorScreen extends ConsumerWidget {
  const BootstrapErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFF8B5CF6);
    const surfaceColor = Color(0xFF12121A);

    final error = ref.watch(bootstrapErrorProvider) ?? 'Unknown startup error';
    final stackTrace = ref.watch(bootstrapStackTraceProvider);
    final missingVars = AppConfig.missingVars;

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                '⚠️  Startup Fault',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              if (missingVars.isNotEmpty) ...[
                const Text(
                  'Environment configurations are missing! The app cannot connect to the backend without these environment variables set:',
                  style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 16),
                ...missingVars.map((v) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222230),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFF6B35), width: 1),
                    ),
                    child: Text(
                      v,
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                const Text(
                  'Run parameters instruction:',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F1B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2E2E3E)),
                  ),
                  child: const Text(
                    'flutter run --dart-define-from-file=.env.json',
                    style: TextStyle(
                      color: Color(0xFF58A6FF),
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please make sure your .env.json is placed in the project root, or launch via VS Code using F5 key.',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 13, height: 1.4),
                ),
              ] else ...[
                const Text(
                  'Critical error occurred while initializing core application subsystems:',
                  style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEB).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
                  ),
                  child: Text(
                    error.toString().replaceFirst('Exception: ', ''),
                    style: const TextStyle(color: Color(0xFFFF8B5E), fontFamily: 'monospace', fontSize: 13),
                  ),
                ),
                if (kDebugMode && stackTrace != null) ...[
                  const SizedBox(height: 20),
                  const Text('Stack Trace (Debug Mode Only):', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                     height: 220,
                     width: double.infinity,
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: const Color(0xFF0F0F1B),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: SingleChildScrollView(
                       child: Text(
                         stackTrace.toString(),
                         style: const TextStyle(color: Color(0xFF8888AA), fontFamily: 'monospace', fontSize: 11),
                       ),
                     ),
                  ),
                ],
              ],
              const SizedBox(height: 36),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(bootstrapErrorProvider.notifier).state = null;
                    ref.read(bootstrapStackTraceProvider.notifier).state = null;
                    ref.read(bootstrapStateProvider.notifier).state = BootstrapState.loading;
                  },
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  label: const Text('RETRY INITIALIZATION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lightweight Fallback Bootstrap placeholder for GoRouter mapping
class BootstrapScreen extends StatelessWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF12121A),
      body: Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            color: Color(0xFF8B5CF6),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}
