// T1 TEXT STYLES — using google_fonts for runtime fetching
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class T1TextStyles {
  static TextTheme getTextTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 50,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        textBaseline: TextBaseline.alphabetic,
      ),
      labelSmall: GoogleFonts.outfit(
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
  static TextStyle sectionLabel(ColorScheme scheme) => GoogleFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.4,
    color: scheme.onSurface.withValues(alpha: 0.45),
  );
}

