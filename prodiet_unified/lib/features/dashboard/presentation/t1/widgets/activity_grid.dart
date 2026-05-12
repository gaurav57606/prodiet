import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: T1Spacing.md),
      child: Row(
        children: [
          _buildActivityTile(
            context,
            stepFormat.format(steps),
            'STEPS',
            null,
            Colors.white,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3A1060), Color(0xFF5020A0)],
            ),
          ),
          const SizedBox(width: T1Spacing.sm),
          _buildActivityTile(
            context,
            '$caloriesBurned',
            'BURNED',
            const Color(0xFFFF5082).withValues(alpha: 0.08),
            const Color(0xFFFF90B0),
            border: Border.all(color: const Color(0xFFFF5082).withValues(alpha: 0.15)),
          ),
          const SizedBox(width: T1Spacing.sm),
          _buildActivityTile(
            context,
            '$netCalories',
            'NET KCAL',
            const Color(0xFF00C8B4).withValues(alpha: 0.07),
            const Color(0xFF40D8C0),
            border: Border.all(color: const Color(0xFF00C8B4).withValues(alpha: 0.13)),
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
        padding: const EdgeInsets.symmetric(vertical: T1Spacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(T1Spacing.radiusLg),
          border: border,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor.withValues(alpha: 0.4),
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
