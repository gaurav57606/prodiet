import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class WaterBanner extends StatelessWidget {
  const WaterBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final skyColor = T2Colors.sky;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: skyColor.withOpacity(0.10),
        border: Border.symmetric(
          horizontal: BorderSide(color: skyColor.withOpacity(0.18), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: skyColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(Icons.water_drop, color: skyColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Almost time — prepare',
                  style: TextStyle(
                    fontSize: 14,
                    color: skyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '1.5L of 2.5L · On track',
                  style: TextStyle(
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
                '18m',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: skyColor,
                ),
              ),
              Text(
                'NEXT DRINK',
                style: TextStyle(
                  fontSize: 7,
                  letterSpacing: 1.2,
                  color: skyColor.withOpacity(0.5),
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
