import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.35), width: 1),
          ),
          child: Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: T2Colors.textSecondary,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
