import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_styles.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData buildTheme(ColorScheme scheme) {
    final tt = AppTextStyles.getTextTheme(scheme);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: tt,
      scaffoldBackgroundColor: scheme.surface,
      
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: tt.headlineSmall?.copyWith(
          color: scheme.onSurface,
        ),
      ),

      cardTheme: CardThemeData(
        color: scheme.brightness == Brightness.dark 
            ? scheme.surfaceContainerHighest.withOpacity(0.6) 
            : Colors.white.withOpacity(0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(
            color: scheme.primary.withOpacity(0.12),
            width: 1.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          return scheme.onSurface.withOpacity(0.4);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return scheme.onSurface.withOpacity(0.15);
        }),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: tt.titleSmall,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface.withOpacity(0.92),
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withOpacity(0.25),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: tt.labelSmall,
        unselectedLabelStyle: tt.labelSmall,
        selectedIconTheme: IconThemeData(
          color: scheme.primary,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: scheme.onSurface.withOpacity(0.25),
          size: 22,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: scheme.primary.withOpacity(0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        hintStyle: tt.bodyMedium?.copyWith(
          color: scheme.onSurface.withOpacity(0.35),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => buildTheme(AppColorSchemes.lightScheme);
  static ThemeData get darkTheme => buildTheme(AppColorSchemes.darkScheme);
  static ThemeData get amoledTheme => buildTheme(AppColorSchemes.amoledScheme);
}
