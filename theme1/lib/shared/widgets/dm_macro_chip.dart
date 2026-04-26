import 'package:flutter/material.dart';
import '../../core/theme/color_schemes.dart';

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
    MacroType.calories => AppColorSchemes.accentViolet,
    MacroType.protein  => AppColorSchemes.accentPink,
    MacroType.carbs    => AppColorSchemes.accentOrange,
    MacroType.fat      => s.secondary,
    MacroType.fibre    => AppColorSchemes.accentTeal,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _colorFor(type, scheme);
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: large ? 20 : 15,
            fontWeight: FontWeight.w800,
            color: color,
            fontFamily: 'Outfit',
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface.withOpacity(0.45),
            letterSpacing: 0.8,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }
}
