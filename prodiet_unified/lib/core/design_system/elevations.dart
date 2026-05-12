import 'package:flutter/material.dart';

/// Centralized elevation tokens for the ProDiet design system.
class AppElevations {
  AppElevations._();

  static const double none = 0.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;

  // Specific shadow colors (usually handled by ColorScheme.shadow but can be defined here)
  static Color shadowColor(BuildContext context) => Theme.of(context).shadowColor.withValues(alpha: 0.1);
}
