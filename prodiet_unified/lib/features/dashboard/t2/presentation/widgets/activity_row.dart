import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: T2Spacing.lg, vertical: T2Spacing.md),
      child: Row(
        children: [
          _buildActivityItem(context, 'STEPS', '8,420', Icons.directions_walk, T2Colors.lime),
          const SizedBox(width: 6),
          _buildActivityItem(context, 'ACTIVE', '42 min', Icons.timer, T2Colors.coral),
          const SizedBox(width: 6),
          _buildActivityItem(context, 'BURNED', '312 kcal', Icons.whatshot, T2Colors.amber),
          const SizedBox(width: 6),
          _buildActivityItem(context, 'HEART', '74 bpm', Icons.favorite, T2Colors.purple),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String label, String value, IconData iconData, Color tileColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: T2Colors.bgElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: T2Colors.border),
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
                  style: const TextStyle(
                    fontSize: 8,
                    letterSpacing: 1.2,
                    color: T2Colors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
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
