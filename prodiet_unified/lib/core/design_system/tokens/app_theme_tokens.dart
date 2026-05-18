import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'app_motion.dart';
import 'app_radius.dart';
import 'app_shadows.dart';
import 'app_gradients.dart';

enum AppDashboardLayout {
  grid,
  curved;

  static const AppDashboardLayout t1 = grid;
  static const AppDashboardLayout t2 = curved;
}

class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  final AppColors colors;
  final AppTypography typography;
  final AppSpacing spacing;
  final AppRadius radius;
  final AppGradients gradients;
  final AppShadows shadows;
  final AppMotion motion;
  final AppDashboardLayout dashboardLayout;
  
  // Semantic Layout and Component Tokens
  final bool useFloatingHeader;
  final bool useUpperCasing;
  final bool customCheckboxShape;
  final int waterQuickAddCrossAxisCount;
  final bool showAlertList;

  const AppThemeTokens({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.gradients,
    required this.shadows,
    required this.motion,
    this.dashboardLayout = AppDashboardLayout.grid,
    this.useFloatingHeader = true,
    this.useUpperCasing = false,
    this.customCheckboxShape = false,
    this.waterQuickAddCrossAxisCount = 2,
    this.showAlertList = true,
  });

  @override
  AppThemeTokens copyWith({
    AppColors? colors,
    AppTypography? typography,
    AppSpacing? spacing,
    AppRadius? radius,
    AppGradients? gradients,
    AppShadows? shadows,
    AppMotion? motion,
    AppDashboardLayout? dashboardLayout,
    bool? useFloatingHeader,
    bool? useUpperCasing,
    bool? customCheckboxShape,
    int? waterQuickAddCrossAxisCount,
    bool? showAlertList,
  }) {
    return AppThemeTokens(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      gradients: gradients ?? this.gradients,
      shadows: shadows ?? this.shadows,
      motion: motion ?? this.motion,
      dashboardLayout: dashboardLayout ?? this.dashboardLayout,
      useFloatingHeader: useFloatingHeader ?? this.useFloatingHeader,
      useUpperCasing: useUpperCasing ?? this.useUpperCasing,
      customCheckboxShape: customCheckboxShape ?? this.customCheckboxShape,
      waterQuickAddCrossAxisCount: waterQuickAddCrossAxisCount ?? this.waterQuickAddCrossAxisCount,
      showAlertList: showAlertList ?? this.showAlertList,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) return this;
    return AppThemeTokens(
      colors: colors.lerp(other.colors, t),
      typography: typography.lerp(other.typography, t),
      spacing: spacing.lerp(other.spacing, t),
      radius: radius.lerp(other.radius, t),
      gradients: gradients.lerp(other.gradients, t),
      shadows: shadows.lerp(other.shadows, t),
      motion: motion.lerp(other.motion, t),
      dashboardLayout: t < 0.5 ? dashboardLayout : other.dashboardLayout,
      useFloatingHeader: t < 0.5 ? useFloatingHeader : other.useFloatingHeader,
      useUpperCasing: t < 0.5 ? useUpperCasing : other.useUpperCasing,
      customCheckboxShape: t < 0.5 ? customCheckboxShape : other.customCheckboxShape,
      waterQuickAddCrossAxisCount: t < 0.5 ? waterQuickAddCrossAxisCount : other.waterQuickAddCrossAxisCount,
      showAlertList: t < 0.5 ? showAlertList : other.showAlertList,
    );
  }
}

extension AppThemeTokensExtension on BuildContext {
  AppThemeTokens get tokens => Theme.of(this).extension<AppThemeTokens>()!;
}
