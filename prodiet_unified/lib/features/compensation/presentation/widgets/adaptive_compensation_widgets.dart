import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaptiveMissedMealCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdaptiveMissedMealCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    const coralColor = Color(0xFFFF5C3A);

    if (isT2) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: coralColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: coralColor.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MISSED MEAL',
              style: GoogleFonts.barlowCondensed(
                fontSize: 12,
                letterSpacing: 1.5,
                color: coralColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.barlowCondensed(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: coralColor,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle.toUpperCase(),
              style: GoogleFonts.barlowCondensed(
                fontSize: 12,
                color: tokens.colors.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Missed Meal Detected',
            style: tokens.typography.titleSmall.copyWith(
              color: tokens.colors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: tokens.typography.headlineMedium.copyWith(
              color: tokens.colors.error,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: tokens.typography.labelSmall.copyWith(
              color: tokens.colors.error.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class AdaptiveAdjustmentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String delta;
  final bool isLast;

  const AdaptiveAdjustmentTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.delta,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isT2 ? title.toUpperCase() : title,
                  style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.titleSmall).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isT2 ? subtitle.toUpperCase() : subtitle,
                  style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Text(
            delta,
            style: GoogleFonts.barlowCondensed(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: tokens.colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
