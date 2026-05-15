import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/macro_components.dart';

class MacroGrid extends StatelessWidget {
  final int calories;
  final double calorieProgress;
  final int protein;
  final double proteinProgress;
  final int carbs;
  final double carbsProgress;
  final int fat;
  final double fatProgress;

  const MacroGrid({
    super.key,
    required this.calories,
    required this.calorieProgress,
    required this.protein,
    required this.proteinProgress,
    required this.carbs,
    required this.carbsProgress,
    required this.fat,
    required this.fatProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.92,
        children: [
          _buildMacroTile(
            context,
            'CALORIES',
            '$calories',
            'kcal',
            calorieProgress,
            ext.macroCaloriesGradient,
            Icons.local_fire_department_rounded,
          ),
          _buildMacroTile(
            context,
            'PROTEIN',
            '$protein',
            'g',
            proteinProgress,
            ext.macroProteinGradient,
            Icons.favorite_rounded,
          ),
          _buildMacroTile(
            context,
            'CARBS',
            '$carbs',
            'g',
            carbsProgress,
            ext.macroCarbsGradient,
            Icons.bolt_rounded,
          ),
          _buildMacroTile(
            context,
            'FAT',
            '$fat',
            'g',
            fatProgress,
            ext.macroFatGradient,
            Icons.water_drop_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTile(
    BuildContext context,
    String label,
    String value,
    String unit,
    double percentage,
    List<Color> gradient,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 1.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          AppMacroLinearBar(
            progress: percentage,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
