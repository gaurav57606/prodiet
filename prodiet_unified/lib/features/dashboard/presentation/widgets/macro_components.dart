import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';

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
    final theme = Theme.of(context);
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              color: theme.brightness == Brightness.dark 
                  ? const Color(0xFF252520) 
                  : theme.colorScheme.outline.withValues(alpha: 0.5),
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
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
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
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    final color = switch (type) {
      AppMacroType.calories => ext.macroCalories,
      AppMacroType.protein => ext.macroProtein,
      AppMacroType.carbs => ext.macroCarbs,
      AppMacroType.fat => ext.macroFat,
      AppMacroType.fibre => ext.water,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: large ? 20 : 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
