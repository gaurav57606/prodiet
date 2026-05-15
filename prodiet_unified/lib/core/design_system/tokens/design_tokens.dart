import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../motion/app_motion.dart';
import 'layout_tokens.dart';

class DesignTokens {
  final AppColors colors;
  final AppSpacing spacing;
  final AppRadius radius;
  final AppMotion motion;
  // Typography and others can be added here

  const DesignTokens({
    required this.colors,
    this.spacing = const AppSpacing(),
    this.radius = const AppRadius(),
    this.motion = const AppMotion(),
  });
}

/// Helper to access tokens from context via theme extension
extension DesignTokensExtension on BuildContext {
  DesignTokens get tokens => Theme.of(this).extension<DesignTokens>()!;
}
