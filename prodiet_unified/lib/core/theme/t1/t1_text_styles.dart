import 'package:flutter/material.dart';
import '../font_config.dart';

class T1TextStyles {
  static TextTheme getTextTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: AppFonts.outfit(
        fontSize: 50,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0,
      ),
      displayMedium: AppFonts.outfit(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0,
      ),
      headlineLarge: AppFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      headlineMedium: AppFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      headlineSmall: AppFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      titleLarge: AppFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: AppFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
      titleSmall: AppFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: AppFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: AppFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: AppFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: AppFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
      labelSmall: AppFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
  }
}

class T1TextStyleExtensions {
  static TextStyle sectionLabel(ColorScheme scheme) => AppFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.4,
    color: scheme.onSurface.withValues(alpha: 0.45),
  );
}

