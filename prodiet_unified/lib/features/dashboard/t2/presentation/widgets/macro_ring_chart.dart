import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class MacroRingChart extends StatelessWidget {
  const MacroRingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMacroItem(context, "69%", "1,380 kcal", "Cals", T2Colors.lime, 0.69),
        const SizedBox(width: 6),
        _buildMacroItem(context, "58%", "87g", "Protein", T2Colors.coral, 0.58),
        const SizedBox(width: 6),
        _buildMacroItem(context, "80%", "200g", "Carbs", T2Colors.amber, 0.80),
        const SizedBox(width: 6),
        _buildMacroItem(context, "40%", "28g", "Fat", T2Colors.purple, 0.40),
      ],
    );
  }

  Widget _buildMacroItem(BuildContext context, String percentStr, String gramStr, String label, Color color, double percent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: T2Colors.bgElevated,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 5,
                      color: const Color(0xFF252520),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 5,
                      color: color,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              percentStr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              gramStr,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: T2Colors.textSecondary,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 8,
                letterSpacing: 1.2,
                color: T2Colors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
