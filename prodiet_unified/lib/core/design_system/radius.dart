import 'package:flutter/material.dart';

/// Centralized border radius tokens for the ProDiet design system.
class AppRadius {
  AppRadius._();

  // T1 specific radii
  static const double t1RadiusSm = 8.0;
  static const double t1RadiusMd = 12.0;
  static const double t1RadiusLg = 18.0;
  static const double t1RadiusXl = 20.0;
  static const double t1RadiusMax = 44.0;

  // T2 specific radii
  static const double t2RadiusSmall = 10.0;
  static const double t2RadiusMedium = 14.0;
  static const double t2RadiusLarge = 18.0;
  static const double t2RadiusExtraLarge = 36.0;

  // Generic tokens (mapped to primary theme or common values)
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 18.0;
  static const double max = 44.0;
  static const double pill = 100.0;

  // BorderRadius objects
  static final BorderRadius circularSm = BorderRadius.circular(sm);
  static final BorderRadius circularMd = BorderRadius.circular(md);
  static final BorderRadius circularLg = BorderRadius.circular(lg);
  static final BorderRadius circularMax = BorderRadius.circular(max);
}
