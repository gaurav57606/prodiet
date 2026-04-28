import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class CalorieStat extends StatelessWidget {
  final int consumed;
  final int burned;
  final int net;

  const CalorieStat({
    super.key,
    required this.consumed,
    required this.burned,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: T2Colors.bgElevated,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCell('CONSUMED', consumed.toString(), T2Colors.lime),
          _vDivider(),
          _statCell('BURNED', burned.toString(), T2Colors.coral),
          _vDivider(),
          _statCell('NET', net.toString(), T2Colors.textPrimary),
        ],
      ),
    );
  }

  Widget _statCell(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            letterSpacing: 1.4,
            color: T2Colors.textMuted,
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
      color: T2Colors.border,
    );
  }
}
