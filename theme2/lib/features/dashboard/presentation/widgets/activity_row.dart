import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/core/theme/color_schemes.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          _buildActivityItem('STEPS', '8,420', Icons.directions_walk, AppColors.lime),
          const SizedBox(width: 6),
          _buildActivityItem('ACTIVE', '42 min', Icons.timer, AppColors.coral),
          const SizedBox(width: 6),
          _buildActivityItem('BURNED', '312 kcal', Icons.whatshot, AppColors.amber),
          const SizedBox(width: 6),
          _buildActivityItem('HEART', '74 bpm', Icons.favorite, AppColors.purple),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String label, String value, IconData iconData, Color tileColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
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
                  style: TextStyle(
                    fontSize: 8,
                    letterSpacing: 1.2,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.barlowCondensed(
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
