import 'package:flutter/foundation.dart';
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

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: _onAppResume,
      onPause: _onAppPause,
    );
    // Await theme init so the correct theme is active before first redirect
    ref.read(activeThemeProvider.notifier).init().then((_) {
      // Notify router to re-evaluate redirect after theme is loaded
      if (mounted) setState(() {});
    });
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
      
      if (!kIsWeb) {
        final deviceInfo = DeviceInfoPlugin();
        // Use defaultTargetPlatform instead of Platform.isXXX to avoid dart:io dependency
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
            osVersion: kIsWeb ? 'Web' : 'Mobile', // Simple fallback, or use device_info_plus more extensively
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
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => child!,
    );
  }
}
