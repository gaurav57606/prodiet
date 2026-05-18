import 'package:flutter/material.dart';
import '../../design_system/tokens/app_theme_tokens.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_radius.dart';
import '../../design_system/tokens/app_shadows.dart';
import '../../design_system/tokens/app_gradients.dart';
import '../../design_system/tokens/app_motion.dart';
import '../font_config.dart';
import 't1_colors.dart';
import 't1_spacing.dart';

class T1Tokens {
  static AppThemeTokens get light => AppThemeTokens(
    dashboardLayout: AppDashboardLayout.t1,
    colors: AppColors(
      primary: T1ColorsLight.primary,
      secondary: T1ColorsLight.alertGreen,
      background: T1ColorsLight.bgPage,
      surface: T1ColorsLight.bgCard,
      error: T1ColorsLight.alertAmber,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: T1ColorsLight.text1,
      onSurface: T1ColorsLight.text1,
      onError: Colors.white,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFF7F2FA),
      surfaceContainer: const Color(0xFFF3EDF7),
      surfaceContainerHigh: const Color(0xFFECE6F0),
      surfaceContainerHighest: const Color(0xFFE6E0E9),
      onSurfaceVariant: T1ColorSchemes.lightScheme.onSurfaceVariant,
      outline: T1ColorSchemes.lightScheme.outline,
      calories: const Color(0xFF6B35FF),
      protein: const Color(0xFFFF6B9D),
      carbs: const Color(0xFFFF9650),
      fat: const Color(0xFF40D9B0),
      water: const Color(0xFF40D8B8),
      activity: const Color(0xFF5020A0),
      waterOk: const Color(0xFF00E5FF),
      waterWarning: const Color(0xFFFFB040),
      waterDanger: const Color(0xFFFF6080),
    ),
    typography: AppTypography(
      displayLarge: AppFonts.outfit(fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: -1.5),
      displayMedium: AppFonts.outfit(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: AppFonts.outfit(fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: AppFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineMedium: AppFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineSmall: AppFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      titleLarge: AppFonts.outfit(fontSize: 22, fontWeight: FontWeight.w400),
      titleMedium: AppFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleSmall: AppFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: AppFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
      bodyMedium: AppFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
      bodySmall: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500),
      labelLarge: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0),
      labelMedium: AppFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      labelSmall: AppFonts.outfit(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
    ),
    spacing: const AppSpacing(
      xs: T1Spacing.xs,
      sm: T1Spacing.sm,
      md: T1Spacing.md,
      lg: T1Spacing.lg,
      xl: T1Spacing.xl,
      xxl: T1Spacing.xxl,
    ),
    radius: const AppRadius(
      xs: T1Spacing.radiusSm,
      sm: T1Spacing.radiusMd,
      md: T1Spacing.radiusLg,
      lg: T1Spacing.radiusXl,
      xl: T1Spacing.radiusMax,
      button: T1Spacing.radiusMd,
      card: T1Spacing.radiusXl,
    ),
    gradients: const AppGradients(
      brand: [T1ColorsLight.primary, T1ColorsLight.primaryLight],
      calories: [Color(0xFF3B1FA8), Color(0xFF6B35FF)],
      protein: [Color(0xFFFF3060), Color(0xFFFF6B9D)],
      carbs: [Color(0xFFFF8C30), Color(0xFFFFB870)],
      fat: [Color(0xFF108070), Color(0xFF40D8B8)],
      water: [Color(0xFF40D8B8), Color(0x9940D8B8)],
      activity: [Color(0xFF3A1060), Color(0xFF5020A0)],
      hero: T1ColorSchemes.heroGradientLightMode,
    ),
    shadows: const AppShadows(
      low: [BoxShadow(color: Color(0x1A783CC8), offset: Offset(0, 4), blurRadius: 12)],
      medium: [BoxShadow(color: Color(0x26783CC8), offset: Offset(0, 8), blurRadius: 24)],
      high: [BoxShadow(color: Color(0x33783CC8), offset: Offset(0, 12), blurRadius: 36)],
    ),
    motion: AppMotion.standard_motion,
  );

  static AppThemeTokens get dark => AppThemeTokens(
    dashboardLayout: AppDashboardLayout.t1,
    colors: AppColors(
      primary: T1ColorSchemes.darkScheme.primary,
      secondary: T1ColorSchemes.darkScheme.secondary,
      background: T1ColorSchemes.darkScheme.surface,
      surface: T1ColorSchemes.darkScheme.surfaceContainerHighest,
      error: T1ColorSchemes.darkScheme.error,
      onPrimary: T1ColorSchemes.darkScheme.onPrimary,
      onSecondary: T1ColorSchemes.darkScheme.onSecondary,
      onBackground: T1ColorSchemes.darkScheme.onSurface,
      onSurface: T1ColorSchemes.darkScheme.onSurface,
      onError: T1ColorSchemes.darkScheme.onError,
      surfaceContainerLowest: const Color(0xFF0F0F15),
      surfaceContainerLow: const Color(0xFF16161F),
      surfaceContainer: const Color(0xFF1E1E26),
      surfaceContainerHigh: const Color(0xFF282830),
      surfaceContainerHighest: T1ColorSchemes.darkScheme.surfaceContainerHighest,
      onSurfaceVariant: T1ColorSchemes.darkScheme.onSurfaceVariant,
      outline: T1ColorSchemes.darkScheme.outline,
      calories: const Color(0xFF6B35FF),
      protein: const Color(0xFFFF6B9D),
      carbs: const Color(0xFFFF9650),
      fat: const Color(0xFF40D9B0),
      water: const Color(0xFF40D8B8),
      activity: const Color(0xFF5020A0),
      waterOk: const Color(0xFF00E5FF),
      waterWarning: const Color(0xFFFFB040),
      waterDanger: const Color(0xFFFF6080),
    ),
    typography: AppTypography(
      displayLarge: AppFonts.outfit(fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: -1.5),
      displayMedium: AppFonts.outfit(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: AppFonts.outfit(fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: AppFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineMedium: AppFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineSmall: AppFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      titleLarge: AppFonts.outfit(fontSize: 22, fontWeight: FontWeight.w400),
      titleMedium: AppFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleSmall: AppFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: AppFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
      bodyMedium: AppFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
      bodySmall: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500),
      labelLarge: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0),
      labelMedium: AppFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      labelSmall: AppFonts.outfit(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
    ),
    spacing: const AppSpacing(
      xs: T1Spacing.xs,
      sm: T1Spacing.sm,
      md: T1Spacing.md,
      lg: T1Spacing.lg,
      xl: T1Spacing.xl,
      xxl: T1Spacing.xxl,
    ),
    radius: const AppRadius(
      xs: T1Spacing.radiusSm,
      sm: T1Spacing.radiusMd,
      md: T1Spacing.radiusLg,
      lg: T1Spacing.radiusXl,
      xl: T1Spacing.radiusMax,
      button: T1Spacing.radiusMd,
      card: T1Spacing.radiusXl,
    ),
    gradients: AppGradients(
      brand: [T1ColorSchemes.darkScheme.primary, T1ColorSchemes.darkScheme.primary.withValues(alpha: 0.8)],
      calories: const [Color(0xFF3B1FA8), Color(0xFF6B35FF)],
      protein: const [Color(0xFFFF3060), Color(0xFFFF6B9D)],
      carbs: const [Color(0xFFFF8C30), Color(0xFFFFB870)],
      fat: const [Color(0xFF108070), Color(0xFF40D8B8)],
      water: const [Color(0xFF40D8B8), Color(0x9940D8B8)],
      activity: const [Color(0xFF3A1060), Color(0xFF5020A0)],
      hero: T1ColorSchemes.heroGradient,
    ),
    shadows: const AppShadows(
      low: [BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 12)],
      medium: [BoxShadow(color: Colors.black54, offset: Offset(0, 8), blurRadius: 24)],
      high: [BoxShadow(color: Colors.black87, offset: Offset(0, 12), blurRadius: 36)],
    ),
    motion: AppMotion.standard_motion,
  );

  static AppThemeTokens get amoled => dark.copyWith(
    colors: dark.colors.copyWith(
      background: Colors.black,
      surface: const Color(0xFF0A0010),
    ),
  );
}

