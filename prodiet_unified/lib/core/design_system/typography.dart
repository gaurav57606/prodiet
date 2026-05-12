import 'package:flutter/material.dart';
import '../theme/font_config.dart';

/// Centralized typography tokens for the ProDiet design system.
class AppTypography {
  AppTypography._();

  // Font weights
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;

  // T1 Style tokens (Outfit)
  static TextStyle t1DisplayLarge = AppFonts.outfit(fontSize: 50, fontWeight: weightExtraBold, letterSpacing: -2.0);
  static TextStyle t1HeadlineLarge = AppFonts.outfit(fontSize: 28, fontWeight: weightExtraBold, letterSpacing: -0.3);
  static TextStyle t1TitleMedium = AppFonts.outfit(fontSize: 15, fontWeight: weightExtraBold);
  static TextStyle t1BodyMedium = AppFonts.outfit(fontSize: 12, fontWeight: weightMedium);

  // T2 Style tokens (Barlow Condensed / DM Sans)
  static TextStyle t2DisplayLarge = AppFonts.barlowCondensed(fontSize: 32, fontWeight: weightBlack, letterSpacing: 1.0);
  static TextStyle t2HeadlineLarge = AppFonts.barlowCondensed(fontSize: 24, fontWeight: weightExtraBold);
  static TextStyle t2TitleMedium = AppFonts.dmSans(fontSize: 14, fontWeight: weightSemiBold);
  static TextStyle t2BodyMedium = AppFonts.dmSans(fontSize: 12, fontWeight: weightRegular);
}
