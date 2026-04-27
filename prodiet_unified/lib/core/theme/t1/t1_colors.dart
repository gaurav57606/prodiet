// ═══════════════════════════════════════════════════════════
// T1 COLORS  —  EXACT COPY of theme1/lib/core/theme/color_schemes.dart
//              and theme1/lib/core/theme/app_colors_light.dart
// Class names prefixed with T1 to prevent any collision with t2.
// DO NOT import this file from any t2/ screen or widget.
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class T1ColorSchemes {
  // ── Accent tokens ─────────────────────────────────────────
  static const Color accentPink    = Color(0xFFFF6B9D);
  static const Color accentOrange  = Color(0xFFFF9650);
  static const Color accentTeal    = Color(0xFF40D9B0);
  static const Color accentBrown   = Color(0xFF8B6914);
  static const Color accentViolet  = Color(0xFFC080FF);

  // ── Chart tokens ──────────────────────────────────────────
  static const Color chartBurned   = Color(0xFF40D9B0);
  static const Color chartConsumed = Color(0xFF8B6914);

  // ── Light Scheme ──────────────────────────────────────────
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8030D0),
    onPrimary: Colors.white,
    secondary: Color(0xFFC05030),
    onSecondary: Colors.white,
    tertiary: Color(0xFFFF6B9D),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFF9650),
    onTertiaryContainer: Colors.white,
    error: Color(0xFFA02040),
    onError: Colors.white,
    surface: Color(0xFFF2ECF9),
    onSurface: Color(0xFF2A0A50),
    surfaceContainerHighest: Color(0xFFE0C8FF),
    onSurfaceVariant: Color(0xFF8040C0),
    outline: Color(0x26B48CFF),
    shadow: Color(0x33783CC8),
  );

  // ── Dark Scheme ───────────────────────────────────────────
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
    surface: Color(0xFF08080F),
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF12121A),
    onSurfaceVariant: Color(0xFFA050FF),
    outline: Color(0x1AFFFFFF),
    shadow: Colors.black,
  );

  // ── Amoled Scheme ─────────────────────────────────────────
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
    surfaceContainerHighest: Color(0xFF0A0010),
    onSurfaceVariant: Color(0xFFA050FF),
    outline: Color(0x1AFFFFFF),
    shadow: Colors.black,
  );

  // ── Gradient helpers ──────────────────────────────────────
  static const List<Color> heroGradient = [
    Color(0xFF12121A),
    Color(0xFF08080F),
    Color(0xFF08080F),
  ];
  static const List<Color> heroGradientLightMode = [
    Color(0xFFE8D5FF),
    Color(0xFFF5DEFF),
    Color(0xFFFFE8F0),
    Color(0xFFFFF0E4),
  ];
}

// ── Light-mode detailed color palette ─────────────────────
// Exact copy of theme1/lib/core/theme/app_colors_light.dart
class T1ColorsLight {
  T1ColorsLight._();

  static const Color bgPage         = Color(0xFFF2ECF9);
  static const Color bgPhone        = Color(0xFFF2ECF9);
  static const Color bgCard         = Color(0x99FFFFFF);
  static const Color bgCardShine    = Color(0xE6FFFFFF);
  static const Color bgElevated     = Color(0xFFFFFFFF);

  static const Color border         = Color(0x1FA064DC);
  static const Color phoneBorder    = Color(0x33A064DC);

  static const Color primary        = Color(0xFF8030D0);
  static const Color primaryLight   = Color(0xFFA050FF);

  static const Color text1          = Color(0xFF2A0A50);
  static const Color text2          = Color(0x992850A0);
  static const Color text3          = Color(0x592850A0);

  static const Color heroName       = Color(0xFF3A1060);
  static const Color heroEm         = Color(0xFF8030D0);
  static const Color heroSub        = Color(0x73643CA0);
  static const Color heroCal        = Color(0xFF3A1060);
  static const Color streakNumber   = Color(0xFFC07010);
  static const Color streakLabel    = Color(0x80B46E00);

  static const Color sectionTitle   = Color(0x59503278);
  static const Color sectionLink    = Color(0xFF8030D0);

  static const Color navBg          = Color(0xF2F2ECFC);
  static const Color navBorder      = Color(0x26B48CFF);
  static const Color navIcon        = Color(0x40643CA0);
  static const Color navLabel       = Color(0x40643CA0);
  static const Color fabShadow      = Color(0x598C3CDC);

  static const Color tileCalStart   = Color(0xFFC890FF);
  static const Color tileCalEnd     = Color(0xFF9040E0);
  static const Color tileProStart   = Color(0xFFFFB0D0);
  static const Color tileProEnd     = Color(0xFFE0508A);
  static const Color tileCarStart   = Color(0xFFFFD090);
  static const Color tileCarEnd     = Color(0xFFE0880A);
  static const Color tileFatBg      = Color(0xB3FFFFFF);
  static const Color tileFatBorder  = Color(0x333CC8B4);
  static const Color tileFatColor   = Color(0xFF208080);
  static const Color tileFatDim     = Color(0x7314A08C);

  static const Color alertAmberBg   = Color(0x33FFBE50);
  static const Color alertAmberBd   = Color(0x40FFB43C);
  static const Color alertAmber     = Color(0xFF904800);
  static const Color alertAmberDot  = Color(0xFFC07010);

  static const Color alertVioletBg  = Color(0x2EB482FF);
  static const Color alertVioletBd  = Color(0x38AA78FF);
  static const Color alertViolet    = Color(0xFF6020A0);
  static const Color alertVioletDot = Color(0xFF8040C0);

  static const Color alertGreenBg   = Color(0x2428C8AA);
  static const Color alertGreenBd   = Color(0x3328C8AA);
  static const Color alertGreen     = Color(0xFF106050);
  static const Color alertGreenDot  = Color(0xFF20A080);

  static const Color waterBg        = Color(0x40B4DCFF);
  static const Color waterBorder    = Color(0x4D78B4FF);
  static const Color waterLabel     = Color(0x993C78C8);
  static const Color waterOkColor   = Color(0xFF106050);
  static const Color waterWarnColor = Color(0xFF906000);
  static const Color waterOverColor = Color(0xFFA02040);

  static const Color tagLow         = Color(0xFFA02040);
  static const Color tagOk          = Color(0xFF106050);
  static const Color barLow         = Color(0xFFC03050);
  static const Color barMed         = Color(0xFFA07000);
  static const Color barOk          = Color(0xFF208070);

  static const Color dotDone        = Color(0xFF208070);
  static const Color dotMiss        = Color(0xFFC03050);
  static const Color dotPending     = Color(0x33502878);

  static const Color compMissBg     = Color(0x14C82846);
  static const Color compMissBd     = Color(0x2EC82846);
  static const Color compAdjBg      = Color(0x14149082);
  static const Color compAdjBd      = Color(0x26149082);

  static const Color tagNormalBg    = Color(0x99FFFFFF);
  static const Color tagNormalBd    = Color(0x26A064DC);
  static const Color tagNormalColor = Color(0x80502878);
  static const Color tagSelBg       = Color(0x1AC82846);
  static const Color tagSelBd       = Color(0x40C82846);
  static const Color tagSelColor    = Color(0xFFA02040);
  static const Color tagDietBg      = Color(0x1A8C50DC);
  static const Color tagDietBd      = Color(0x408C50DC);
  static const Color tagDietColor   = Color(0xFF6020A0);

  static const Color statusBar      = Color(0x66503278);
}
