import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class WaterBanner extends StatelessWidget {
  final int consumed;
  final int target;
  final double progress;

  const WaterBanner({
    super.key,
    required this.consumed,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    const skyColor = T2Colors.sky;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: skyColor.withValues(alpha: 0.10),
        border: Border.symmetric(
          horizontal: BorderSide(color: skyColor.withValues(alpha: 0.18), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: skyColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.water_drop, color: skyColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Almost time — prepare',
                  style: TextStyle(
                    fontSize: 14,
                    color: skyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${(consumed / 1000).toStringAsFixed(1)}L of ${(target / 1000).toStringAsFixed(1)}L · On track',
                  style: const TextStyle(
                    fontSize: 12,
                    color: T2Colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: skyColor,
                ),
              ),
              Text(
                'GOAL',
                style: TextStyle(
                  fontSize: 7,
                  letterSpacing: 1.2,
                  color: skyColor.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
