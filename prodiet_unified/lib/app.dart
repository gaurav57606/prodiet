import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/active_theme_provider.dart';
import 'core/theme/t1/t1_theme.dart';
import 'core/theme/t2/t2_theme.dart';

class ProDietApp extends ConsumerStatefulWidget {
  const ProDietApp({super.key});

  @override
  ConsumerState<ProDietApp> createState() => _ProDietAppState();
}

class _ProDietAppState extends ConsumerState<ProDietApp> {
  late final AppLifecycleListener _listener;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: _onAppResume,
      onPause: _onAppPause,
    );
    _router = createAppRouter(ProviderScope.containerOf(context));
    ref.read(activeThemeProvider.notifier).init();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    String deviceModel = 'Unknown';
    String appVersion = '1.0.0';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.utsname.machine;
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
            osVersion: Platform.operatingSystemVersion,
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
    final active = ref.watch(activeThemeProvider);

    ThemeData resolvedTheme() {
      switch (active) {
        case ActiveTheme.t1Light:
          return T1Theme.light;
        case ActiveTheme.t1Dark:
          return T1Theme.dark;
        case ActiveTheme.t1Amoled:
          return T1Theme.amoled;
        case ActiveTheme.t2Light:
          return T2Theme.light;
        case ActiveTheme.t2Dark:
          return T2Theme.dark;
        case ActiveTheme.t2Amoled:
          return T2Theme.amoled;
      }
    }

    return MaterialApp.router(
      title: 'ProDiet',
      debugShowCheckedModeBanner: false,
      theme: resolvedTheme(),
      routerConfig: _router,
      // Preserves theme1's pixel-perfect layout — no system font scaling
      builder: (context, child) {
        final active = ref.watch(activeThemeProvider);
        final isT1 = active == ActiveTheme.t1Light ||
                     active == ActiveTheme.t1Dark ||
                     active == ActiveTheme.t1Amoled;
        if (isT1) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: child!,
          );
        }
        return child!;
      },
    );
  }
}
