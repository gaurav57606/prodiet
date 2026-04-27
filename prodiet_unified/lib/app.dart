import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/active_theme_provider.dart';
import 'core/theme/t1/t1_theme.dart';
import 'core/theme/t2/t2_theme.dart';

class ProDietApp extends ConsumerWidget {
  const ProDietApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      routerConfig: appRouter,
      // Preserve theme1's textScaler: no scaling — keeps all screens pixel perfect
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
