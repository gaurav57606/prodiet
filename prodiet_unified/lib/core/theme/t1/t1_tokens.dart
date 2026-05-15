import 'package:flutter/material.dart';
import '../theme_tokens.dart';
import '../font_config.dart';
import 't1_colors.dart';
import 't1_spacing.dart';

class T1Tokens {
  static AppThemeTokens get light => AppThemeTokens(
    colors: AppColorTokens(
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
      calories: const Color(0xFF6B35FF),
      protein: const Color(0xFFFF6B9D),
      carbs: const Color(0xFFFF9650),
      fat: const Color(0xFF40D9B0),
      water: const Color(0xFF40D8B8),
      activity: const Color(0xFF5020A0),
    ),
    typography: AppTypographyTokens(
      headlineLarge: AppFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineMedium: AppFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineSmall: AppFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      bodyLarge: AppFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
      bodyMedium: AppFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
      bodySmall: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500),
      labelLarge: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0),
      labelMedium: AppFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      labelSmall: AppFonts.outfit(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
    ),
    spacing: const AppSpacingTokens(
      xs: T1Spacing.xs,
      sm: T1Spacing.sm,
      md: T1Spacing.md,
      lg: T1Spacing.lg,
      xl: T1Spacing.xl,
      xxl: T1Spacing.xxl,
    ),
    radius: const AppRadiusTokens(
      xs: T1Spacing.radiusSm,
      sm: T1Spacing.radiusMd,
      md: T1Spacing.radiusLg,
      lg: T1Spacing.radiusXl,
      xl: T1Spacing.radiusMax,
    ),
    gradients: AppGradientTokens(
      brand: const [T1ColorsLight.primary, T1ColorsLight.primaryLight],
      calories: const [Color(0xFF3B1FA8), Color(0xFF6B35FF)],
      protein: const [Color(0xFFFF3060), Color(0xFFFF6B9D)],
      carbs: const [Color(0xFFFF8C30), Color(0xFFFFB870)],
      fat: const [Color(0xFF108070), Color(0xFF40D8B8)],
      water: const [Color(0xFF40D8B8), Color(0x9940D8B8)],
      activity: const [Color(0xFF3A1060), Color(0xFF5020A0)],
      hero: T1ColorSchemes.heroGradientLightMode,
    ),
    shadows: const AppShadowTokens(
      low: [BoxShadow(color: Color(0x1A783CC8), offset: Offset(0, 4), blurRadius: 12)],
      medium: [BoxShadow(color: Color(0x26783CC8), offset: Offset(0, 8), blurRadius: 24)],
      high: [BoxShadow(color: Color(0x33783CC8), offset: Offset(0, 12), blurRadius: 36)],
    ),
  );

  static AppThemeTokens get dark => AppThemeTokens(
    colors: AppColorTokens(
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
      calories: const Color(0xFF6B35FF),
      protein: const Color(0xFFFF6B9D),
      carbs: const Color(0xFFFF9650),
      fat: const Color(0xFF40D9B0),
      water: const Color(0xFF40D8B8),
      activity: const Color(0xFF5020A0),
    ),
    typography: AppTypographyTokens(
      headlineLarge: AppFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineMedium: AppFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      headlineSmall: AppFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      bodyLarge: AppFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
      bodyMedium: AppFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
      bodySmall: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500),
      labelLarge: AppFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0),
      labelMedium: AppFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      labelSmall: AppFonts.outfit(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
    ),
    spacing: const AppSpacingTokens(
      xs: T1Spacing.xs,
      sm: T1Spacing.sm,
      md: T1Spacing.md,
      lg: T1Spacing.lg,
      xl: T1Spacing.xl,
      xxl: T1Spacing.xxl,
    ),
    radius: const AppRadiusTokens(
      xs: T1Spacing.radiusSm,
      sm: T1Spacing.radiusMd,
      md: T1Spacing.radiusLg,
      lg: T1Spacing.radiusXl,
      xl: T1Spacing.radiusMax,
    ),
    gradients: AppGradientTokens(
      brand: [T1ColorSchemes.darkScheme.primary, T1ColorSchemes.darkScheme.primary.withValues(alpha: 0.8)],
      calories: const [Color(0xFF3B1FA8), Color(0xFF6B35FF)],
      protein: const [Color(0xFFFF3060), Color(0xFFFF6B9D)],
      carbs: const [Color(0xFFFF8C30), Color(0xFFFFB870)],
      fat: const [Color(0xFF108070), Color(0xFF40D8B8)],
      water: const [Color(0xFF40D8B8), Color(0x9940D8B8)],
      activity: const [Color(0xFF3A1060), Color(0xFF5020A0)],
      hero: T1ColorSchemes.heroGradient,
    ),
    shadows: const AppShadowTokens(
      low: [BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 12)],
      medium: [BoxShadow(color: Colors.black54, offset: Offset(0, 8), blurRadius: 24)],
      high: [BoxShadow(color: Colors.black87, offset: Offset(0, 12), blurRadius: 36)],
    ),
  );

  static AppThemeTokens get amoled => dark.copyWith(
    colors: dark.colors.copyWith(
      background: Colors.black,
      surface: const Color(0xFF0A0010),
    ),
  );
}

extension AppThemeTokensX on AppThemeTokens {
  AppThemeTokens copyWith({
    AppColorTokens? colors,
    AppTypographyTokens? typography,
    AppSpacingTokens? spacing,
    AppRadiusTokens? radius,
    AppGradientTokens? gradients,
    AppShadowTokens? shadows,
  }) {
    return AppThemeTokens(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      gradients: gradients ?? this.gradients,
      shadows: shadows ?? this.shadows,
    );
  }
}

extension AppColorTokensX on AppColorTokens {
  AppColorTokens copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? error,
    Color? onPrimary,
    Color? onSecondary,
    Color? onBackground,
    Color? onSurface,
    Color? onError,
    Color? calories,
    Color? protein,
    Color? carbs,
    Color? fat,
    Color? water,
    Color? activity,
  }) {
    return AppColorTokens(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      onError: onError ?? this.onError,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      water: water ?? this.water,
      activity: activity ?? this.activity,
    );
  }
}
