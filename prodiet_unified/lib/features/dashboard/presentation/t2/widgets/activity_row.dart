import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildActivityItem(context, 'STEPS', '8,420', Icons.directions_walk, ext.activity),
          const SizedBox(width: 6),
          _buildActivityItem(context, 'ACTIVE', '42 min', Icons.timer, ext.macroProtein),
          const SizedBox(width: 6),
          _buildActivityItem(context, 'BURNED', '312 kcal', Icons.whatshot, ext.macroCarbs),
          const SizedBox(width: 6),
          _buildActivityItem(context, 'HEART', '74 bpm', Icons.favorite, ext.macroFat),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String label, String value, IconData iconData, Color tileColor) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark 
              ? const Color(0xFF1E1E1A) 
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Icon(iconData, color: tileColor, size: 14),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 8,
                    letterSpacing: 1.2,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: tileColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
