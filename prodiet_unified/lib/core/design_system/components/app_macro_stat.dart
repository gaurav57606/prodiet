import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

enum MacroType { calories, protein, carbs, fat, fibre, water }

class AppMacroStat extends StatelessWidget {
  final String value;
  final String label;
  final MacroType? type;
  final Color? color;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final bool showDecoration;

  const AppMacroStat({
    super.key,
    required this.value,
    required this.label,
    this.type,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 4.0,
    this.showDecoration = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    Color effectiveColor = color ?? tokens.colors.primary;
    if (type != null) {
      effectiveColor = switch (type!) {
        MacroType.calories => tokens.colors.calories,
        MacroType.protein => tokens.colors.protein,
        MacroType.carbs => tokens.colors.carbs,
        MacroType.fat => tokens.colors.fat,
        MacroType.fibre => tokens.colors.activity,
        MacroType.water => tokens.colors.water,
      };
    }

    Widget valueWidget = Text(
      value,
      style: (showDecoration ? tokens.typography.labelLarge : tokens.typography.headlineSmall).copyWith(
        color: effectiveColor,
        fontWeight: FontWeight.w800,
      ),
    );

    if (showDecoration) {
      valueWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(tokens.radius.sm),
          border: Border.all(color: effectiveColor.withValues(alpha: 0.2), width: 1),
        ),
        child: valueWidget,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        valueWidget,
        SizedBox(height: spacing),
        Text(
          label.toUpperCase(),
          style: tokens.typography.labelSmall.copyWith(
            color: tokens.colors.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

