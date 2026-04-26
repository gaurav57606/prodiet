import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class DietMateApp extends ConsumerWidget {
  const DietMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    ThemeData getTheme() {
      switch (themeMode) {
        case AppThemeMode.light:
          return AppTheme.light;
        case AppThemeMode.dark:
          return AppTheme.dark;
        case AppThemeMode.amoled:
          return AppTheme.amoled;
      }
    }

    return MaterialApp.router(
      title: 'DietMate Pro',
      debugShowCheckedModeBanner: false,
      theme: getTheme(),
      routerConfig: appRouter,
    );
  }
}

