import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/font_config.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';

class CalorieStat extends StatelessWidget {
  final int consumed;
  final int burned;
  final int net;

  const CalorieStat({
    super.key,
    required this.consumed,
    required this.burned,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark 
            ? const Color(0xFF1E1E1A) 
            : theme.colorScheme.surfaceContainerHighest,
        border: Border.symmetric(
          horizontal: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCell(theme, 'CONSUMED', consumed.toString(), ext.macroCalories),
          _vDivider(theme),
          _statCell(theme, 'BURNED', burned.toString(), ext.macroProtein),
          _vDivider(theme),
          _statCell(theme, 'NET', net.toString(), theme.colorScheme.onSurface),
        ],
      ),
    );
  }

  Widget _statCell(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 8,
            letterSpacing: 1.4,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppFonts.barlowCondensed(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _vDivider(ThemeData theme) {
    return Container(
      height: 36,
      width: 1,
      color: theme.colorScheme.outline,
    );
  }
}
