import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/macro_components.dart';

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
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    return Row(
      children: [
        _buildMacroItem(
          context, 
          "${(calorieProgress * 100).toInt()}%", 
          "$calories kcal", 
          "Cals", 
          ext.macroCalories, 
          calorieProgress,
        ),
        const SizedBox(width: 6),
        _buildMacroItem(
          context, 
          "${(proteinProgress * 100).toInt()}%", 
          "${protein}g", 
          "Protein", 
          ext.macroProtein, 
          proteinProgress,
        ),
        const SizedBox(width: 6),
        _buildMacroItem(
          context, 
          "${(carbsProgress * 100).toInt()}%", 
          "${carbs}g", 
          "Carbs", 
          ext.macroCarbs, 
          carbsProgress,
        ),
        const SizedBox(width: 6),
        _buildMacroItem(
          context, 
          "${(fatProgress * 100).toInt()}%", 
          "${fat}g", 
          "Fat", 
          ext.macroFat, 
          fatProgress,
        ),
      ],
    );
  }

  Widget _buildMacroItem(BuildContext context, String percentStr, String gramStr, String label, Color color, double percent) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: ext.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            AppMacroRing(
              progress: percent,
              color: color,
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
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 8,
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
