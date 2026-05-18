import 'package:flutter/material.dart';

/// Centralized utility for semantic labeling and accessibility interaction
class AppAccessibility {
  /// Wraps a widget with semantic information for screen readers
  static Widget semanticWrap({
    required Widget child,
    required String label,
    String? hint,
    bool isButton = false,
    bool isHeader = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      header: isHeader,
      child: child,
    );
  }

  /// Minimum touch target size per Material Design / WCAG
  static const double minTouchTargetSize = 48.0;

  /// Ensures a widget meets the minimum touch target size
  static Widget touchTarget({
    required Widget child,
    double size = minTouchTargetSize,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: size,
        minHeight: size,
      ),
      child: child,
    );
  }
}

/// Extension for easy access to accessibility scaling checks
extension AccessibilityExtension on BuildContext {
  bool get isTextScalingEnabled => MediaQuery.textScalerOf(this) != TextScaler.noScaling;
  
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1.0);

  /// Helper to determine if we should switch to a more vertical layout 
  /// because the user has extremely large font sizes enabled.
  bool get useAccessibilityLayout => textScaleFactor > 1.5;
}
