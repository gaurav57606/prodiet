import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class DietMateApp extends ConsumerWidget {
  const DietMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, you would watch a theme provider here.
    // For now, we'll default to Dark mode to match the premium design intent.
    const themeMode = ThemeMode.dark;

    return MaterialApp.router(
      title: 'DietMate Pro',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Router Configuration
      routerConfig: appRouter,
      
      // Global builder for potential overlays or text scaling
      builder: (context, child) {
        return MediaQuery(
          // Ensure accessible text scaling while maintaining design integrity
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}
