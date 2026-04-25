import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class DietMateApp extends ConsumerWidget {
  const DietMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, we would watch a theme provider here
    // For now, we default to the Dark Theme as per the HTML design
    final themeMode = ThemeMode.dark; 

    return MaterialApp.router(
      title: 'DietMate Pro',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: themeMode,

      // Router Configuration
      routerConfig: routerProvider,

      // Global Builder for potential overlay widgets (ads, notifications)
      builder: (context, child) {
        return child!;
      },
    );
  }
}
