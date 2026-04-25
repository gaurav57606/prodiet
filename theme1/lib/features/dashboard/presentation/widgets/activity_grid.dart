import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class ActivityGrid extends StatelessWidget {
  const ActivityGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildActivityTile(
            context,
            '4,820',
            'STEPS',
            const Color(0xFF3A1080),
            const Color(0xFFD090FF),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActivityTile(
            context,
            '312',
            'BURNED',
            const Color(0xFFFF5082).withOpacity(0.08),
            const Color(0xFFFF90B0),
            border: Border.all(color: const Color(0xFFFF5082).withOpacity(0.15)),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActivityTile(
            context,
            '48m',
            'ACTIVE',
            const Color(0xFF00C8B4).withOpacity(0.07),
            const Color(0xFF40D8C0),
            border: Border.all(color: const Color(0xFF00C8B4).withOpacity(0.13)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(
    BuildContext context,
    String value,
    String label,
    Color bgColor,
    Color textColor, {
    BoxBorder? border,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
                color: textColor.withOpacity(0.4),
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
