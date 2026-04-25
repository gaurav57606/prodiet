import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_styles.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData buildTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextStyles.getTextTheme(scheme),
      scaffoldBackgroundColor: scheme.surface,
      
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.getTextTheme(scheme).headlineSmall?.copyWith(
          color: scheme.onSurface,
        ),
      ),

      cardTheme: CardThemeData(
        color: scheme.brightness == Brightness.dark 
            ? Colors.white.withOpacity(0.04) 
            : Colors.white.withOpacity(0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(
            color: scheme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.08)
                : const Color(0xFFA064DC).withOpacity(0.12),
            width: 1.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
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
          textStyle: AppTextStyles.getTextTheme(scheme).titleSmall,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface.withOpacity(0.92),
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withOpacity(0.25),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.getTextTheme(scheme).labelSmall,
        unselectedLabelStyle: AppTextStyles.getTextTheme(scheme).labelSmall,
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
            color: scheme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFA064DC).withOpacity(0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        hintStyle: AppTextStyles.getTextTheme(scheme).bodyMedium?.copyWith(
          color: scheme.onSurface.withOpacity(0.35),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => buildTheme(AppColorSchemes.lightScheme);
  static ThemeData get darkTheme => buildTheme(AppColorSchemes.darkScheme);
  static ThemeData get amoledTheme => buildTheme(AppColorSchemes.amoledScheme);
}
