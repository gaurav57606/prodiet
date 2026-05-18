// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'app_theme_tokens.dart';

class AppMotion {
  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Curve standard;
  final Curve emphasized;
  final Curve decelerate;

  const AppMotion({
    required this.fast,
    required this.normal,
    required this.slow,
    required this.standard,
    required this.emphasized,
    required this.decelerate,
  });

  AppMotion lerp(AppMotion other, double t) {
    if (t < 0.5) return this;
    return other;
  }

  static const standard_motion = AppMotion(
    fast: Duration(milliseconds: 150),
    normal: Duration(milliseconds: 300),
    slow: Duration(milliseconds: 500),
    standard: Curves.easeInOut,
    emphasized: Curves.easeOutQuart,
    decelerate: Curves.decelerate,
  );

  /// A subtle scale and fade animation typically used for cards or buttons appearing.
  static Widget scaleFade({
    required BuildContext context,
    required Widget child,
    bool isVisible = true,
  }) {
    final tokens = context.tokens;
    return AnimatedScale(
      scale: isVisible ? 1.0 : 0.95,
      duration: tokens.motion.fast,
      curve: tokens.motion.standard,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: tokens.motion.fast,
        curve: tokens.motion.standard,
        child: child,
      ),
    );
  }

  /// A smooth slide-in animation from the bottom.
  static Widget slideIn({
    required BuildContext context,
    required Widget child,
    bool isVisible = true,
    Offset offset = const Offset(0, 0.1),
  }) {
    final tokens = context.tokens;
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : offset,
      duration: tokens.motion.normal,
      curve: tokens.motion.emphasized,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: tokens.motion.normal,
        curve: tokens.motion.standard,
        child: child,
      ),
    );
  }

  /// Interactive hover effect: subtle scale up.
  static Widget hoverEffect({
    required BuildContext context,
    required Widget child,
    required bool isHovered,
  }) {
    final tokens = context.tokens;
    return AnimatedContainer(
      duration: tokens.motion.fast,
      curve: tokens.motion.standard,
      transform: isHovered 
          ? (Matrix4.identity()..scale(1.02, 1.02)) 
          : Matrix4.identity(),
      child: child,
    );
  }
}

