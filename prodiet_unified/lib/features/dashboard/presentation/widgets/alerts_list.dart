import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class AlertsList extends StatelessWidget {
  const AlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md),
      child: Column(
        children: [
          _buildAlertTile(
            context,
            'Snack skipped · Dinner adjusted',
            '+15g protein added tonight',
            const Color(0xFFFFB040),
            const Color(0xFFFFD070).withValues(alpha: 0.13),
          ),
          const SizedBox(height: 8),
          _buildAlertTile(
            context,
            'Quinoa Bowl ready to cook',
            'All ingredients in stock · 25 min',
            const Color(0xFFC090FF),
            const Color(0xFFA178FF).withValues(alpha: 0.13),
          ),
          const SizedBox(height: 8),
          _buildAlertTile(
            context,
            '3 of 4 macros above 60%',
            'Great progress on targets today',
            const Color(0xFF40D8B8),
            const Color(0xFF28C8AA).withValues(alpha: 0.13),
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
    final tokens = context.tokens;
    
    return AppCard(
      padding: const EdgeInsets.all(12),
      color: bgColor,
      border: BorderSide(color: accentColor.withValues(alpha: 0.22)),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tokens.typography.labelMedium.copyWith(
                    fontSize: 12,
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: tokens.colors.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
