import 'package:flutter/material.dart';

class AppColors {
  // Primary / Lime
  static const Color lime = Color(0xFFC2FF2A);
  static const Color limeDark = Color(0xFF8FCC00);
  static const Color limeLight = Color(0x1AC2FF2A);

  // Coral / Error
  static const Color coral = Color(0xFFFF5C3A);
  static const Color coralLight = Color(0x1FFF5C3A);

  // Sky / Water
  static const Color sky = Color(0xFF38BFFF);
  static const Color skyLight = Color(0x1F38BFFF);

  // Amber / Warning
  static const Color amber = Color(0xFFFFB800);
  static const Color amberLight = Color(0x1FFFB800);

  // Purple / Order
  static const Color purple = Color(0xFFB06EFF);
  static const Color purpleLight = Color(0x1FB06EFF);

  // Green / Success
  static const Color green = Color(0xFF3DCC7E);
  static const Color greenLight = Color(0x1F3DCC7E);

  // Neutral / Backgrounds
  static const Color bgDefault = Color(0xFF0D0D0B);
  static const Color bgSurface = Color(0xFF161614);
  static const Color bgElevated = Color(0xFF1E1E1A);
  static const Color bgDeep = Color(0xFF272720);

  // Amoled
  static const Color amoledSurface    = Color(0xFF000000);
  static const Color amoledElevated   = Color(0xFF0A0A0A);
  static const Color amoledDeep       = Color(0xFF111110);

  // Text
  static const Color textPrimary = Color(0xFFF2F2EC);
  static const Color textSecondary = Color(0xFF9A9A8A);
  static const Color textMuted = Color(0xFF4E4E44);

  // Borders
  static const Color border = Color(0xFF252520);

  // Aliases
  static const Color bgCard = bgElevated;
  static const Color divider = border;
}

final lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.limeDark,
  onPrimary: Colors.black,
  secondary: AppColors.purple,
  onSecondary: Colors.white,
  error: AppColors.coral,
  onError: Colors.white,
  surface: Color(0xFFF5F5F0),
  onSurface: Colors.black,
  surfaceContainerHighest: Color(0xFFFFFFFF), // Using this as the 'background' equivalent
  onSurfaceVariant: AppColors.textMuted,
  outline: Color(0xFFE0E0DA),
);

final darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.lime,
  onPrimary: AppColors.bgDefault,
  secondary: AppColors.purple,
  onSecondary: Colors.white,
  error: AppColors.coral,
  onError: Colors.white,
  surface: AppColors.bgSurface,
  onSurface: AppColors.textPrimary,
  surfaceContainerHighest: AppColors.bgElevated,
  onSurfaceVariant: AppColors.textSecondary,
  outline: AppColors.border,
);

final amoledScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.lime,
  onPrimary: Colors.black,
  secondary: AppColors.purple,
  onSecondary: Colors.white,
  error: AppColors.coral,
  onError: Colors.white,
  surface: AppColors.amoledSurface,
  onSurface: AppColors.textPrimary,
  surfaceContainerHighest: AppColors.amoledElevated,
  onSurfaceVariant: AppColors.textSecondary,
  outline: AppColors.border,
);
