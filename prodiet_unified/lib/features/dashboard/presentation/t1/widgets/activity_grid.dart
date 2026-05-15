import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';
import 'package:intl/intl.dart';

class ActivityGrid extends StatelessWidget {
  final int steps;
  final int caloriesBurned;
  final int netCalories;

  const ActivityGrid({
    super.key,
    required this.steps,
    required this.caloriesBurned,
    required this.netCalories,
  });

  @override
  Widget build(BuildContext context) {
    final stepFormat = NumberFormat('#,###');
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildActivityTile(
            context,
            stepFormat.format(steps),
            'STEPS',
            null,
            Colors.white,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ext.activityGradient,
            ),
          ),
          const SizedBox(width: 8),
          _buildActivityTile(
            context,
            '$caloriesBurned',
            'BURNED',
            ext.macroProtein.withValues(alpha: 0.08),
            ext.macroProtein,
            border: Border.all(color: ext.macroProtein.withValues(alpha: 0.15)),
          ),
          const SizedBox(width: 8),
          _buildActivityTile(
            context,
            '$netCalories',
            'NET KCAL',
            ext.macroFat.withValues(alpha: 0.07),
            ext.macroFat,
            border: Border.all(color: ext.macroFat.withValues(alpha: 0.13)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(
    BuildContext context,
    String value,
    String label,
    Color? bgColor,
    Color textColor, {
    BoxBorder? border,
    Gradient? gradient,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          border: border,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor.withValues(alpha: 0.4),
                letterSpacing: 0.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
