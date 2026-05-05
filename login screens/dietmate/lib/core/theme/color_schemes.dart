import 'package:flutter/material.dart';

class AppColorSchemes {
  // Light Scheme (Matches HTML "light" body class)
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8030D0),
    onPrimary: Colors.white,
    secondary: Color(0xFFA050FF),
    onSecondary: Colors.white,
    error: Color(0xFFA02030),
    onError: Colors.white,
    surface: Color(0xFFF2ECF9),
    onSurface: Color(0xFF2A0A50),
    surfaceContainer: Color(0x99FFFFFF), // rgba(255,255,255,.6)
    outline: Color(0x1FA064DC), // rgba(160,100,220,.12)
    onSurfaceVariant: Color(0xFF502878), // rgba(80,40,120,.6)
    surfaceContainerHighest: Color(0xCCFFFFFF), // rgba(255,255,255,.8)
  );

  // Dark Scheme (Matches HTML "midnight" body class)
  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC4A0FF),
    onPrimary: Color(0xFF1C1A2E),
    secondary: Color(0xFFA060FF),
    onSecondary: Colors.white,
    error: Color(0xFFFF8090),
    onError: Color(0xFF330000),
    surface: Color(0xFF1C1A2E),
    onSurface: Color(0xFFEDE6FF),
    surfaceContainer: Color(0x0FA78BFF), // rgba(167,139,255,.06)
    outline: Color(0x21A78BFF), // rgba(167,139,255,.13)
    onSurfaceVariant: Color(0x8CEDE6FF), // rgba(200,185,255,.55)
    surfaceContainerHighest: Color(0x12A78BFF), // rgba(167,139,255,.07)
  );

  // Amoled Scheme (Matches HTML default/dark body class with #000)
  static const amoledScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC080FF),
    onPrimary: Colors.black,
    secondary: Color(0xFFA050FF),
    onSecondary: Colors.white,
    error: Color(0xFFFF8090),
    onError: Color(0xFF330000),
    surface: Colors.black,
    onSurface: Colors.white,
    surfaceContainer: Color(0x0AFFFFFF), // rgba(255,255,255,.04)
    outline: Color(0x14FFFFFF), // rgba(255,255,255,.08)
    onSurfaceVariant: Color(0x80FFFFFF), // rgba(255,255,255,.5)
    surfaceContainerHighest: Color(0x0DFFFFFF), // rgba(255,255,255,.05)
  );
}

