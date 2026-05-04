// T1 COLORS — exact copy of theme1 color files
import 'package:flutter/material.dart';

// DO NOT import from t2/ files

class T1ColorSchemes {
  // Accent tokens
  static const Color accentPink = Color(0xFFFF6B9D);
  static const Color accentOrange = Color(0xFFFF9650);
  static const Color accentTeal = Color(0xFF40D9B0);
  static const Color accentBrown = Color(0xFF8B6914);
  static const Color accentViolet = Color(0xFFC080FF);

  // Chart tokens
  static const Color chartBurned = Color(0xFF40D9B0); // teal
  static const Color chartConsumed = Color(0xFF8B6914); // brown/gold

  // Light Scheme
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8030D0),
    onPrimary: Colors.white,
    secondary: Color(0xFFC05030),
    onSecondary: Colors.white,
    tertiary: Color(0xFFFF6B9D), // pink accent
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
  static const List<Color> heroGradient = [
    Color(0xFF12121A),
    Color(0xFF08080F),
    Color(0xFF08080F)
  ];
  static const List<Color> heroGradientLightMode = [
    Color(0xFFE8D5FF),
    Color(0xFFF5DEFF),
    Color(0xFFFFE8F0),
    Color(0xFFFFF0E4)
  ];
}

class T1ColorsLight {
  T1ColorsLight._();

  // Backgrounds
  static const Color bgPage = Color(0xFFF2ECF9); // --bg-page
  static const Color bgPhone = Color(0xFFF2ECF9); // --bg-phone
  static const Color bgCard =
      Color(0x99FFFFFF); // --card-bg rgba(255,255,255,.6)
  static const Color bgCardShine =
      Color(0xE6FFFFFF); // --card-shine rgba(255,255,255,.9)
  static const Color bgElevated = Color(0xFFFFFFFF); // white elevated surface

  // Borders
  static const Color border =
      Color(0x1FA064DC); // --card-bd rgba(160,100,220,.12)
  static const Color phoneBorder =
      Color(0x33A064DC); // --phone-border rgba(160,100,220,.2)

  // Primary accent (nav, FAB, active)
  static const Color primary = Color(0xFF8030D0); // --nav-on
  static const Color primaryLight = Color(0xFFA050FF); // fab gradient start

  // Text
  static const Color text1 = Color(0xFF2A0A50); // --text1
  static const Color text2 = Color(0x992850A0); // --text2 rgba(80,40,120,.6)
  static const Color text3 = Color(0x592850A0); // --text3 rgba(80,40,120,.35)

  // Hero section
  static const Color heroName = Color(0xFF3A1060); // --hero-name
  static const Color heroEm = Color(0xFF8030D0); // --hero-em
  static const Color heroSub =
      Color(0x73643CA0); // --hero-sub rgba(100,60,160,.45)
  static const Color heroCal = Color(0xFF3A1060); // --hero-cal
  static const Color streakNumber = Color(0xFFC07010); // --streak-n
  static const Color streakLabel =
      Color(0x80B46E00); // --streak-l rgba(180,110,0,.5)

  // Section headers
  static const Color sectionTitle =
      Color(0x59503278); // --sh-t rgba(80,50,120,.35)
  static const Color sectionLink = Color(0xFF8030D0); // --sh-l

  // Nav / FAB
  static const Color navBg =
      Color(0xF2F2ECFC); // --nav-bg rgba(242,236,252,.95)
  static const Color navBorder =
      Color(0x26B48CFF); // --nav-bd rgba(180,140,255,.15)
  static const Color navIcon =
      Color(0x40643CA0); // --nav-ic rgba(100,60,160,.25)
  static const Color navLabel = Color(0x40643CA0); // --nav-lbl
  static const Color fabShadow =
      Color(0x598C3CDC); // --fab-shadow rgba(140,60,220,.35)

  // Macro tiles
  static const Color tileCalStart = Color(0xFFC890FF); // --t-cal gradient
  static const Color tileCalEnd = Color(0xFF9040E0);
  static const Color tileProStart = Color(0xFFFFB0D0); // --t-pro gradient
  static const Color tileProEnd = Color(0xFFE0508A);
  static const Color tileCarStart = Color(0xFFFFD090); // --t-car gradient
  static const Color tileCarEnd = Color(0xFFE0880A);
  static const Color tileFatBg =
      Color(0xB3FFFFFF); // --t-fat-bg rgba(255,255,255,.7)
  static const Color tileFatBorder =
      Color(0x333CC8B4); // --t-fat-bd rgba(60,200,180,.2)
  static const Color tileFatColor = Color(0xFF208080); // --t-fat-c
  static const Color tileFatDim =
      Color(0x7314A08C); // --t-fat-cd rgba(20,160,140,.45)

  // Alert colors
  static const Color alertAmberBg = Color(0x33FFBE50); // --al-a-bg
  static const Color alertAmberBd =
      Color(0x40FFB43C); // --al-a-bd rgba(255,180,60,.25)
  static const Color alertAmber = Color(0xFF904800); // --al-a-c
  static const Color alertAmberDot = Color(0xFFC07010); // --al-a-dot

  static const Color alertVioletBg = Color(0x2EB482FF); // --al-v-bg
  static const Color alertVioletBd =
      Color(0x38AA78FF); // --al-v-bd rgba(170,120,255,.22)
  static const Color alertViolet = Color(0xFF6020A0); // --al-v-c
  static const Color alertVioletDot = Color(0xFF8040C0); // --al-v-dot

  static const Color alertGreenBg = Color(0x2428C8AA); // --al-m-bg
  static const Color alertGreenBd =
      Color(0x3328C8AA); // --al-m-bd rgba(40,200,170,.2)
  static const Color alertGreen = Color(0xFF106050); // --al-m-c
  static const Color alertGreenDot = Color(0xFF20A080); // --al-m-dot

  // Water
  static const Color waterBg =
      Color(0x40B4DCFF); // --w-bg rgba(180,220,255,.25)
  static const Color waterBorder =
      Color(0x4D78B4FF); // --w-bd rgba(120,180,255,.3)
  static const Color waterLabel =
      Color(0x993C78C8); // --w-lbl rgba(60,120,200,.6)
  static const Color waterOkColor = Color(0xFF106050); // --ok-c light
  static const Color waterWarnColor = Color(0xFF906000); // --wn-c light
  static const Color waterOverColor = Color(0xFFA02040); // --ov-c light

  // Inventory
  static const Color tagLow = Color(0xFFA02040); // --tag-low-c
  static const Color tagOk = Color(0xFF106050); // --tag-ok-c
  static const Color barLow = Color(0xFFC03050); // --bar-low
  static const Color barMed = Color(0xFFA07000); // --bar-med
  static const Color barOk = Color(0xFF208070); // --bar-ok

  // Meal plan
  static const Color dotDone = Color(0xFF208070); // --dot-done
  static const Color dotMiss = Color(0xFFC03050); // --dot-miss
  static const Color dotPending =
      Color(0x33502878); // --dot-pend rgba(80,40,120,.2)

  // Compensation
  static const Color compMissBg =
      Color(0x14C82846); // --comp-miss rgba(200,40,70,.08)
  static const Color compMissBd =
      Color(0x2EC82846); // --comp-miss-bd rgba(200,40,70,.18)
  static const Color compAdjBg =
      Color(0x14149082); // --comp-adj rgba(20,160,130,.08)
  static const Color compAdjBd =
      Color(0x26149082); // --comp-adj-bd rgba(20,160,130,.15)

  // Tags
  static const Color tagNormalBg =
      Color(0x99FFFFFF); // --tag-n-bg rgba(255,255,255,.6)
  static const Color tagNormalBd =
      Color(0x26A064DC); // --tag-n-bd rgba(160,100,220,.15)
  static const Color tagNormalColor =
      Color(0x80502878); // --tag-n-c rgba(80,40,120,.5)
  static const Color tagSelBg =
      Color(0x1AC82846); // --tag-sel-bg rgba(200,40,70,.1)
  static const Color tagSelBd =
      Color(0x40C82846); // --tag-sel-bd rgba(200,40,70,.25)
  static const Color tagSelColor = Color(0xFFA02040); // --tag-sel-c
  static const Color tagDietBg =
      Color(0x1A8C50DC); // --tag-diet-bg rgba(140,80,220,.1)
  static const Color tagDietBd =
      Color(0x408C50DC); // --tag-diet-bd rgba(140,80,220,.25)
  static const Color tagDietColor = Color(0xFF6020A0); // --tag-diet-c

  // Status bar
  static const Color statusBar = Color(0x66503278); // --sb-c rgba(80,50,120,.4)
}
