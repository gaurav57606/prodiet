// ═══════════════════════════════════════════════════════════
// T2 COLORS  —  EXACT COPY of theme2/lib/core/theme/color_schemes.dart
// Class names prefixed with T2 to prevent any collision with t1.
// DO NOT import this file from any t1/ screen or widget.
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class T2Colors {
  // ── Palette tokens ────────────────────────────────────────
  static const Color lime          = Color(0xFFC2FF2A);
  static const Color limeDark      = Color(0xFF8FCC00);
  static const Color limeLight     = Color(0x1AC2FF2A);

  static const Color coral         = Color(0xFFFF5C3A);
  static const Color coralLight    = Color(0x1FFF5C3A);

  static const Color sky           = Color(0xFF38BFFF);
  static const Color skyLight      = Color(0x1F38BFFF);

  static const Color amber         = Color(0xFFFFB800);
  static const Color amberLight    = Color(0x1FFFB800);

  static const Color purple        = Color(0xFFB06EFF);
  static const Color purpleLight   = Color(0x1FB06EFF);

  static const Color green         = Color(0xFF3DCC7E);
  static const Color greenLight    = Color(0x1F3DCC7E);

  // ── Backgrounds ───────────────────────────────────────────
  static const Color bgDefault     = Color(0xFF0D0D0B);
  static const Color bgSurface     = Color(0xFF161614);
  static const Color bgElevated    = Color(0xFF1E1E1A);
  static const Color bgDeep        = Color(0xFF272720);

  // ── AMOLED backgrounds ────────────────────────────────────
  static const Color amoledSurface  = Color(0xFF000000);
  static const Color amoledElevated = Color(0xFF0A0A0A);
  static const Color amoledDeep     = Color(0xFF111110);

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF2F2EC);
  static const Color textSecondary = Color(0xFF9A9A8A);
  static const Color textMuted     = Color(0xFF4E4E44);

  // ── Borders ───────────────────────────────────────────────
  static const Color border        = Color(0xFF252520);
}

// ── ColorScheme instances (exact copy of theme2 color_schemes.dart) ──

final t2LightScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF8FCC00),
  onPrimary: Colors.black,
  secondary: Color(0xFFB06EFF),
  onSecondary: Colors.white,
  error: Color(0xFFFF5C3A),
  onError: Colors.white,
  surface: Color(0xFFF5F5F0),
  onSurface: Colors.black,
  surfaceContainerHighest: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF4E4E44),
  outline: Color(0xFFE0E0DA),
);

final t2DarkScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFC2FF2A),
  onPrimary: Color(0xFF0D0D0B),
  secondary: Color(0xFFB06EFF),
  onSecondary: Colors.white,
  error: Color(0xFFFF5C3A),
  onError: Colors.white,
  surface: Color(0xFF161614),
  onSurface: Color(0xFFF2F2EC),
  surfaceContainerHighest: Color(0xFF1E1E1A),
  onSurfaceVariant: Color(0xFF9A9A8A),
  outline: Color(0xFF252520),
);

final t2AmoledScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFC2FF2A),
  onPrimary: Colors.black,
  secondary: Color(0xFFB06EFF),
  onSecondary: Colors.white,
  error: Color(0xFFFF5C3A),
  onError: Colors.white,
  surface: Color(0xFF000000),
  onSurface: Color(0xFFF2F2EC),
  surfaceContainerHighest: Color(0xFF0A0A0A),
  onSurfaceVariant: Color(0xFF9A9A8A),
  outline: Color(0xFF252520),
);
