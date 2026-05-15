import 'package:flutter/material.dart';

/// Define core design tokens that are independent of Flutter's ThemeData.
/// This allows us to share tokens across different visual themes (T1, T2).
class AppThemeTokens {
  final AppColorTokens colors;
  final AppTypographyTokens typography;
  final AppSpacingTokens spacing;
  final AppRadiusTokens radius;
  final AppGradientTokens gradients;
  final AppShadowTokens shadows;

  const AppThemeTokens({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.gradients,
    required this.shadows,
  });
}

class AppColorTokens {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;
  
  // Macros
  final Color calories;
  final Color protein;
  final Color carbs;
  final Color fat;
  final Color water;
  final Color activity;

  const AppColorTokens({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.water,
    required this.activity,
  });
}

class AppTypographyTokens {
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  const AppTypographyTokens({
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });
}

class AppSpacingTokens {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  const AppSpacingTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });
}

class AppRadiusTokens {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  const AppRadiusTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });
}

class AppGradientTokens {
  final List<Color> brand;
  final List<Color> calories;
  final List<Color> protein;
  final List<Color> carbs;
  final List<Color> fat;
  final List<Color> water;
  final List<Color> activity;
  final List<Color> hero;

  const AppGradientTokens({
    required this.brand,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.water,
    required this.activity,
    required this.hero,
  });
}

class AppShadowTokens {
  final List<BoxShadow> low;
  final List<BoxShadow> medium;
  final List<BoxShadow> high;

  const AppShadowTokens({
    required this.low,
    required this.medium,
    required this.high,
  });
}
