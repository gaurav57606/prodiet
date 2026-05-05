import 'package:flutter/material.dart';
import '../font_config.dart';

class T2TextStyles {
  static TextTheme getTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: AppFonts.barlowCondensed(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface,
        letterSpacing: 1.0,
      ),
      displayMedium: AppFonts.barlowCondensed(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface,
      ),
      headlineLarge: AppFonts.barlowCondensed(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
      ),
      headlineMedium: AppFonts.barlowCondensed(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
      ),
      headlineSmall: AppFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      titleLarge: AppFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      titleMedium: AppFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: AppFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      bodyLarge: AppFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyMedium: AppFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodySmall: AppFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: AppFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
      labelSmall: AppFonts.dmSans(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.4,
      ),
    );
  }

  static TextStyle sectionLabel(ColorScheme colorScheme) {
    return AppFonts.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurfaceVariant,
      letterSpacing: 1.5,
    );
  }
}
