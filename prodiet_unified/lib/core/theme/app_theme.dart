import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'active_theme_provider.dart';
import 'theme_tokens.dart';
import 't1/t1_tokens.dart';
import 't2/t2_tokens.dart';
import 'pro_diet_theme_extension.dart';

final appThemeTokensProvider = Provider<AppThemeTokens>((ref) {
  final activeTheme = ref.watch(activeThemeProvider);
  
  switch (activeTheme) {
    case ActiveTheme.t1Light:
      return T1Tokens.light;
    case ActiveTheme.t1Dark:
      return T1Tokens.dark;
    case ActiveTheme.t1Amoled:
      return T1Tokens.amoled;
    case ActiveTheme.t2Light:
      return T2Tokens.light;
    case ActiveTheme.t2Dark:
      return T2Tokens.dark;
    case ActiveTheme.t2Amoled:
      return T2Tokens.amoled;
  }
});

class AppTheme {
  static ThemeData buildTheme(AppThemeTokens tokens, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.colors.primary,
      onPrimary: tokens.colors.onPrimary,
      secondary: tokens.colors.secondary,
      onSecondary: tokens.colors.onSecondary,
      surface: tokens.colors.background,
      onSurface: tokens.colors.onSurface,
      error: tokens.colors.error,
      onError: tokens.colors.onError,
      surfaceContainerHighest: tokens.colors.surface,
      onSurfaceVariant: tokens.colors.onBackground.withValues(alpha: 0.6),
      outline: tokens.colors.onBackground.withValues(alpha: 0.1),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.colors.background,
      textTheme: _buildTextTheme(tokens, colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.colors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: tokens.typography.headlineSmall.copyWith(
          color: tokens.colors.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        color: tokens.colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radius.lg),
          side: BorderSide(
            color: tokens.colors.primary.withValues(alpha: 0.1),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.colors.primary,
          foregroundColor: tokens.colors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radius.sm),
          ),
          textStyle: tokens.typography.labelLarge,
        ),
      ),
      extensions: [
        ProDietThemeExtension(
          cardRadius: tokens.radius.lg,
          buttonRadius: tokens.radius.sm,
          cardBackground: tokens.colors.surface,
          cardBorder: BorderSide(
            color: tokens.colors.primary.withValues(alpha: 0.1),
          ),
          sectionLabelStyle: tokens.typography.labelSmall.copyWith(
            color: tokens.colors.onSurface.withValues(alpha: 0.5),
          ),
          brandGradient: tokens.gradients.brand,
          macroCalories: tokens.colors.calories,
          macroProtein: tokens.colors.protein,
          macroCarbs: tokens.colors.carbs,
          macroFat: tokens.colors.fat,
          macroCaloriesGradient: tokens.gradients.calories,
          macroProteinGradient: tokens.gradients.protein,
          macroCarbsGradient: tokens.gradients.carbs,
          macroFatGradient: tokens.gradients.fat,
          water: tokens.colors.water,
          waterGradient: tokens.gradients.water,
          activity: tokens.colors.activity,
          activityGradient: tokens.gradients.activity,
          heroGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: tokens.gradients.hero,
          ),
          shadowColor: tokens.shadows.low.first.color,
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(AppThemeTokens tokens, ColorScheme scheme) {
    return TextTheme(
      headlineLarge: tokens.typography.headlineLarge,
      headlineMedium: tokens.typography.headlineMedium,
      headlineSmall: tokens.typography.headlineSmall,
      bodyLarge: tokens.typography.bodyLarge,
      bodyMedium: tokens.typography.bodyMedium,
      bodySmall: tokens.typography.bodySmall,
      labelLarge: tokens.typography.labelLarge,
      labelMedium: tokens.typography.labelMedium,
      labelSmall: tokens.typography.labelSmall,
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
  }
}
