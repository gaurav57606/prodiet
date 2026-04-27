import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dietmate_pro/core/theme/color_schemes.dart';

class CalorieStat extends StatelessWidget {
  const CalorieStat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.bgElevated,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCell('CONSUMED', '1,380', AppColors.lime),
          _vDivider(),
          _statCell('BURNED', '312', AppColors.coral),
          _vDivider(),
          _statCell('NET', '1,068', AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _statCell(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            letterSpacing: 1.4,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.barlowCondensed(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _vDivider() {
    return Container(
      height: 36,
      width: 1,
      color: AppColors.border,
    );
  }
}
