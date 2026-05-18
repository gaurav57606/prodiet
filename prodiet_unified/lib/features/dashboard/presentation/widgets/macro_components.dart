import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';

class AppMacroRing extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;

  const AppMacroRing({
    super.key,
    required this.progress,
    required this.color,
    this.size = 44,
    this.strokeWidth = 5,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              color: tokens.colors.surfaceContainerHighest.withValues(alpha: 0.2),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              color: color,
              strokeCap: StrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }
}

class AppMacroLinearBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const AppMacroLinearBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: tokens.colors.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}

enum AppMacroType { calories, protein, carbs, fat, fibre }

class AppMacroChip extends StatelessWidget {
  final String value;
  final String label;
  final AppMacroType type;
  final bool large;

  const AppMacroChip({
    super.key,
    required this.value,
    required this.label,
    required this.type,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final color = switch (type) {
      AppMacroType.calories => tokens.colors.primary,
      AppMacroType.protein => const Color(0xFFC6FF00),
      AppMacroType.carbs => const Color(0xFF00E5FF),
      AppMacroType.fat => const Color(0xFFFF4081),
      AppMacroType.fibre => const Color(0xFF7C4DFF),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: tokens.typography.titleMedium.copyWith(
            fontSize: large ? 20 : 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: tokens.typography.labelSmall.copyWith(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: tokens.colors.onSurface.withValues(alpha: 0.4),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
