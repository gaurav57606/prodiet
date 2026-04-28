// T2 TEXT STYLES — BarlowCondensed + DmSans, uses google_fonts
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class T2TextStyles {
  static TextTheme getTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: GoogleFonts.barlowCondensed(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface,
        letterSpacing: 1.0,
      ),
      displayMedium: GoogleFonts.barlowCondensed(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface,
      ),
      headlineLarge: GoogleFonts.barlowCondensed(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
      ),
      headlineMedium: GoogleFonts.barlowCondensed(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
      ),
      headlineSmall: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.4,
      ),
    );
  }

  static TextStyle sectionLabel(ColorScheme colorScheme) {
    return GoogleFonts.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurfaceVariant,
      letterSpacing: 1.5,
    );
  }
}
