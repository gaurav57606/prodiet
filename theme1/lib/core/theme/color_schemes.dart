import 'package:flutter/material.dart';

class AppColorSchemes {
  // Light Scheme
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8030D0),
    onPrimary: Colors.white,
    secondary: Color(0xFFC05030),
    onSecondary: Colors.white,
    error: Color(0xFFA02040),
    onError: Colors.white,
    surface: Color(0xFFF2ECF9),
    onSurface: Color(0xFF2A0A50),
    surfaceContainerHighest: Color(0xFFE8D5FF), // Hero background approximation
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
    error: Color(0xFFFF6080),
    onError: Colors.white,
    surface: Color(0xFF0D0020), // Darker surface
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF1A0030),
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
    error: Color(0xFFFF6080),
    onError: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF1A0030),
    onSurfaceVariant: Color(0xFFA050FF),
    outline: Color(0x1AFFFFFF),
    shadow: Colors.black,
  );

  // Custom Gradient colors extracted from HTML
  static const List<Color> heroGradientDark = [Color(0xFF1A0030), Color(0xFF0D0020), Colors.black];
  static const List<Color> heroGradientLight = [Color(0xFFE8D5FF), Color(0xFFF5DEFF), Color(0xFFFFE8F0), Color(0xFFFFF0E4)];
}
