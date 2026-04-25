import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class AlertsList extends StatelessWidget {
  const AlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          _buildAlertTile(
            context,
            'Snack skipped · Dinner adjusted',
            '+15g protein added tonight',
            const Color(0xFFFFB040),
            const Color(0xFFFFD070).withOpacity(0.1),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildAlertTile(
            context,
            'Quinoa Bowl ready to cook',
            'All ingredients in stock · 25 min',
            const Color(0xFFC090FF),
            const Color(0xFFA178FF).withOpacity(0.1),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildAlertTile(
            context,
            '3 of 4 macros above 60%',
            'Great progress on targets today',
            const Color(0xFF40D8B8),
            const Color(0xFF28C8AA).withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTile(
    BuildContext context,
    String title,
    String subtitle,
    Color accentColor,
    Color bgColor,
  ) {
    final theme = Theme.of(context);
    
    return DmCard(
      padding: const EdgeInsets.all(12),
      color: bgColor,
      borderSide: BorderSide(color: accentColor.withOpacity(0.18)),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    color: accentColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
