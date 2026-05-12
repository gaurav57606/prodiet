import 'package:flutter/material.dart';

/// Centralized spacing tokens for the ProDiet design system.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Edge Insets helper
  static const EdgeInsets edgeInsetsXs = EdgeInsets.all(xs);
  static const EdgeInsets edgeInsetsSm = EdgeInsets.all(sm);
  static const EdgeInsets edgeInsetsMd = EdgeInsets.all(md);
  static const EdgeInsets edgeInsetsLg = EdgeInsets.all(lg);
  static const EdgeInsets edgeInsetsXl = EdgeInsets.all(xl);
  
  // Symmetric helpers
  static const EdgeInsets symmetricHsm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets symmetricHmd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets symmetricHlg = EdgeInsets.symmetric(horizontal: lg);
  
  static const EdgeInsets symmetricVsm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets symmetricVmd = EdgeInsets.symmetric(vertical: md);
}
