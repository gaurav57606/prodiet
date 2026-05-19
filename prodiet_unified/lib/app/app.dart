import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prodiet_unified/app/bootstrap_screen.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:prodiet_unified/app/router.dart';
import 'package:prodiet_unified/core/services/connectivity_service.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/core/theme/app_theme.dart';
import 'package:prodiet_unified/shared/components/production_error_screen.dart';
import 'package:prodiet_unified/core/observability/monitoring/app_health_monitor.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';
import 'package:prodiet_unified/core/sync/sync_providers.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';


class ProDietApp extends ConsumerStatefulWidget {
  final bool isTest;
  const ProDietApp({super.key, this.isTest = false});

  @override
  ConsumerState<ProDietApp> createState() => _ProDietAppState();
}

class _ProDietAppState extends ConsumerState<ProDietApp> with WidgetsBindingObserver {
  late final AppLifecycleListener _listener;
  bool _warmedUp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listener = AppLifecycleListener(
      onResume: _onAppResume,
      onPause: _onAppPause,
    );
    if (!widget.isTest) {
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return ProductionErrorScreen(error: details.exception);
      };
    }
    // Await theme init so the correct theme is active before first redirect
    ref.read(activeThemeProvider.notifier).init().timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        // Force-mark as initialized with default theme so app can proceed
        ref.read(activeThemeInitializedProvider.notifier).state = true;
      },
    ).catchError((e) {
      // On any error, force-mark as initialized with default theme
      ref.read(activeThemeInitializedProvider.notifier).state = true;
    }).whenComplete(() {
      if (mounted) {
        setState(() {});
        if (!widget.isTest) {
          ref.read(appHealthMonitorProvider).recordStartupComplete();
        }
      }
    });
  }

  void _runDeferredWarmup() {
    try {
      AppLogger.info('[App] Starting deferred startup warmup...');

      // 1. Safe initialization of sync and background processes
      ref.read(syncManagerProvider).start();

      // 2. Bind FCM token updates & synchronization to authenticated user lifecycle
      ref.listenManual(currentUserIdProvider, (previous, next) {
        if (next.isNotEmpty) {
          ref.read(fcmServiceProvider)?.initialize(next);
          ref.read(syncManagerProvider).processQueue();
          ref.read(analyticsManagerProvider).setUserId(next);
        }
      });

      // 3. Fast check of initial auth provider state to start session checking in background
      ref.read(authProvider);

      AppLogger.info('[App] Deferred startup warmup complete.');
    } catch (e, st) {
      AppLogger.error('[App] Critical error in deferred warmup', error: e, stack: st);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _listener.dispose();
    super.dispose();
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    if (!widget.isTest) {
      ref.read(appHealthMonitorProvider).recordMemoryPressure('critical');
    }
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    String deviceModel = 'Unknown';
    String appVersion = '1.0.0';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      
      if (!kIsWeb) {
        final deviceInfo = DeviceInfoPlugin();
        if (defaultTargetPlatform == TargetPlatform.android) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.utsname.machine;
        }
      } else {
        deviceModel = 'Web Browser';
      }
    } catch (_) {}
    return {'deviceModel': deviceModel, 'appVersion': appVersion};
  }

  void _onAppResume() {
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      final userId = authState.user.id;
      _getDeviceInfo().then((info) {
        if (mounted) {
          ref.read(analyticsServiceProvider).startSession(
            userId,
            deviceModel: info['deviceModel'] ?? 'Unknown',
            osVersion: kIsWeb ? 'Web' : 'Mobile',
            appVersion: info['appVersion'] ?? '1.0.0',
          );
        }
      });
    }
  }

  void _onAppPause() {
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      ref.read(analyticsServiceProvider).endSession(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bootstrapState = ref.watch(bootstrapStateProvider);

    if (bootstrapState == BootstrapState.loading) {
      return const MaterialApp(
        title: 'ProDiet',
        debugShowCheckedModeBanner: false,
        home: BootstrapLoadingScreen(),
      );
    }

    if (bootstrapState == BootstrapState.failed) {
      return const MaterialApp(
        title: 'ProDiet',
        debugShowCheckedModeBanner: false,
        home: BootstrapErrorScreen(),
      );
    }

    // Handle deferred warmup exactly once when transition to ready state completes
    if (bootstrapState == BootstrapState.ready && !_warmedUp) {
      _warmedUp = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _runDeferredWarmup();
      });
    }

    final tokens = ref.watch(appThemeTokensProvider);
    final active = ref.watch(activeThemeProvider);
    
    final brightness = (active == ActiveTheme.t1Light || active == ActiveTheme.t2Light)
        ? Brightness.light
        : Brightness.dark;

    return MaterialApp.router(
      title: 'ProDiet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(tokens, brightness),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final clamped = mediaQuery.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.3,
        );
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clamped),
          child: Column(
            children: [
              const _ConnectivityBanner(),
              Expanded(
                child: child ?? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

class _ConnectivityBanner extends ConsumerWidget {
  const _ConnectivityBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityProvider);
    final isOffline = status.value == ConnectivityStatus.offline;
    final topPadding = MediaQuery.maybeOf(context)?.padding.top ?? 0.0;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOffline ? 32 + topPadding : 0,
      color: const Color(0xFFFF6B35),
      padding: EdgeInsets.only(top: isOffline ? topPadding : 0),
      child: isOffline
          ? const Center(
              child: Text(
                '📵  No internet — working offline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
    );
  }
}
