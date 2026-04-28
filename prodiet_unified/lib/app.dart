import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onAppResume() {
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      ref.read(analyticsServiceProvider).startSession(
        authState.user.id,
        deviceModel: 'Generic Device', // Requires device_info_plus
        osVersion: Platform.operatingSystemVersion,
        appVersion: '1.0.0', // Requires package_info_plus
      );
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
      routerConfig: createAppRouter(ref),
      // Preserves theme1's pixel-perfect layout — no system font scaling
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}
