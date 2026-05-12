import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class MacroRingChart extends StatelessWidget {
  final double calorieProgress;
  final int calories;
  final double proteinProgress;
  final int protein;
  final double carbsProgress;
  final int carbs;
  final double fatProgress;
  final int fat;

  const MacroRingChart({
    super.key,
    required this.calorieProgress,
    required this.calories,
    required this.proteinProgress,
    required this.protein,
    required this.carbsProgress,
    required this.carbs,
    required this.fatProgress,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMacroItem(context, "${(calorieProgress * 100).toInt()}%", "$calories kcal", "Cals", T2Colors.lime, calorieProgress),
        const SizedBox(width: 6),
        _buildMacroItem(context, "${(proteinProgress * 100).toInt()}%", "${protein}g", "Protein", T2Colors.coral, proteinProgress),
        const SizedBox(width: 6),
        _buildMacroItem(context, "${(carbsProgress * 100).toInt()}%", "${carbs}g", "Carbs", T2Colors.amber, carbsProgress),
        const SizedBox(width: 6),
        _buildMacroItem(context, "${(fatProgress * 100).toInt()}%", "${fat}g", "Fat", T2Colors.purple, fatProgress),
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
                  const Center(
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 5,
                      color: Color(0xFF252520),
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
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: T2Colors.textSecondary,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
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
