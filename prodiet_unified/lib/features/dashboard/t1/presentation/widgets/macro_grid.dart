import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
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
            [const Color(0xFF3B1FA8), const Color(0xFF6B35FF)],
            Icons.local_fire_department_rounded,
          ),
          _buildMacroTile(
            context,
            'PROTEIN',
            '$protein',
            'g',
            proteinProgress,
            [const Color(0xFFFF3060), const Color(0xFFFF6B9D)],
            Icons.favorite_rounded,
          ),
          _buildMacroTile(
            context,
            'CARBS',
            '$carbs',
            'g',
            carbsProgress,
            [const Color(0xFFFF8C30), const Color(0xFFFFB870)],
            Icons.bolt_rounded,
          ),
          _buildMacroTile(
            context,
            'FAT',
            '$fat',
            'g',
            fatProgress,
            [const Color(0xFF108070), const Color(0xFF40D8B8)],
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
      padding: const EdgeInsets.all(T1Spacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(T1Spacing.radiusLg),
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
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.7),
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
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
