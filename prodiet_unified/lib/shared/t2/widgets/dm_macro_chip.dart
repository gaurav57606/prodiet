import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/shared/widgets/base_macro_stat.dart';

enum MacroType { protein, carbs, fat, fibre, calories }

class DmMacroChip extends StatelessWidget {
  final String value;
  final String label;
  final MacroType type;

  const DmMacroChip({
    super.key,
    required this.value,
    required this.label,
    required this.type,
  });

  Color _getColor() {
    switch (type) {
      case MacroType.protein:
        return T2Colors.coral;
      case MacroType.carbs:
        return T2Colors.amber;
      case MacroType.fat:
        return T2Colors.purple;
      case MacroType.fibre:
        return T2Colors.sky;
      case MacroType.calories:
        return T2Colors.lime;
    }
  }
  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final theme = Theme.of(context);

    return BaseMacroStat(
      value: value,
      label: label,
      valueStyle: theme.textTheme.labelLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        color: T2Colors.textSecondary,
        fontSize: 9,
      ),
      valueDecoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      valuePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      spacing: 4,
    );
  }
}
