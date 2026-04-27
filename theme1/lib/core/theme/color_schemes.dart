import 'package:flutter/material.dart';

class AppColorSchemes {
  // Accent tokens
  static const Color accentPink     = Color(0xFFFF6B9D);
  static const Color accentOrange   = Color(0xFFFF9650);
  static const Color accentTeal     = Color(0xFF40D9B0);
  static const Color accentBrown    = Color(0xFF8B6914);
  static const Color accentViolet   = Color(0xFFC080FF);
  
  // Chart tokens
  static const Color chartBurned    = Color(0xFF40D9B0);  // teal
  static const Color chartConsumed  = Color(0xFF8B6914);  // brown/gold

  // Light Scheme
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8030D0),
    onPrimary: Colors.white,
    secondary: Color(0xFFC05030),
    onSecondary: Colors.white,
    tertiary: Color(0xFFFF6B9D),          // pink accent
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFF9650), // orange accent
    onTertiaryContainer: Colors.white,
    error: Color(0xFFA02040),
    onError: Colors.white,
    surface: Color(0xFFF2ECF9),
    onSurface: Color(0xFF2A0A50),
    surfaceContainerHighest: Color(0xFFE0C8FF), // lighter card bg
    onSurfaceVariant: Color(0xFF8040C0),
    outline: Color(0x26B48CFF),
    shadow: Color(0x33783CC8),
  );

  // Dark Scheme
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC080FF),
    onPrimary: Colors.black,
    secondary: Color(0xFFFFB870),
    onSecondary: Colors.black,
    tertiary: Color(0xFFFF6B9D),
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFFFFB870),
    onTertiaryContainer: Colors.black,
    error: Color(0xFFFF6080),
    onError: Colors.white,
    surface: Color(0xFF08080F), // True deep purple-black
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF12121A),
    onSurfaceVariant: Color(0xFFA050FF),
    outline: Color(0x1AFFFFFF),
    shadow: Colors.black,
  );

  // Amoled Scheme
  static const ColorScheme amoledScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC080FF),
    onPrimary: Colors.black,
    secondary: Color(0xFFFFB870),
    onSecondary: Colors.black,
    tertiary: Color(0xFFFF6B9D),
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFFFFB870),
    onTertiaryContainer: Colors.black,
    error: Color(0xFFFF6080),
    onError: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF0A0010), // near-black
    onSurfaceVariant: Color(0xFFA050FF),
    outline: Color(0x1AFFFFFF),
    shadow: Colors.black,
  );

  // Custom Gradient colors extracted from HTML
  static const List<Color> heroGradient = [Color(0xFF12121A), Color(0xFF08080F), Color(0xFF08080F)];
  static const List<Color> heroGradientLightMode = [Color(0xFFE8D5FF), Color(0xFFF5DEFF), Color(0xFFFFE8F0), Color(0xFFFFF0E4)];
}
