import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_colors.dart';
import 'package:prodiet_unified/shared/widgets/base_macro_stat.dart';

enum MacroType { calories, protein, carbs, fat, fibre }

class DmMacroChip extends StatelessWidget {
  final String value;
  final String label;
  final MacroType type;
  final bool large;

  const DmMacroChip({
    super.key,
    required this.value,
    required this.label,
    required this.type,
    this.large = false,
  });

  Color _colorFor(MacroType t, ColorScheme s) => switch (t) {
    MacroType.calories => T1ColorSchemes.accentViolet,
    MacroType.protein  => T1ColorSchemes.accentPink,
    MacroType.carbs    => T1ColorSchemes.accentOrange,
    MacroType.fat      => s.secondary,
    MacroType.fibre    => T1ColorSchemes.accentTeal,
  };
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = _colorFor(type, scheme);

    return BaseMacroStat(
      value: value,
      label: label.toUpperCase(),
      valueStyle: TextStyle(
        fontSize: large ? 20 : 15,
        fontWeight: FontWeight.w800,
        color: color,
        fontFamily: 'Outfit',
      ),
      labelStyle: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface.withValues(alpha: 0.45),
        letterSpacing: 0.8,
        fontFamily: 'Outfit',
      ),
      spacing: 0,
    );
  }
}
