import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/macro_components.dart';

class UnifiedMacroSection extends StatelessWidget {
  final int calories;
  final double calorieProgress;
  final int protein;
  final double proteinProgress;
  final int carbs;
  final double carbsProgress;
  final int fat;
  final double fatProgress;

  const UnifiedMacroSection({
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
    final tokens = context.tokens;

    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return _buildT2MacroRingChart(context);
    }

    return _buildT1MacroGrid(context);
  }

  Widget _buildT1MacroGrid(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              _buildMacroTile(context, 'CALORIES', '$calories', 'kcal', calorieProgress, LinearGradient(colors: tokens.gradients.calories), Icons.local_fire_department_rounded),
              SizedBox(width: tokens.spacing.md),
              _buildMacroTile(context, 'PROTEIN', '$protein', 'g', proteinProgress, LinearGradient(colors: tokens.gradients.protein), Icons.favorite_rounded),
            ],
          ),
          SizedBox(height: tokens.spacing.md),
          Row(
            children: [
              _buildMacroTile(context, 'CARBS', '$carbs', 'g', carbsProgress, LinearGradient(colors: tokens.gradients.carbs), Icons.bolt_rounded),
              SizedBox(width: tokens.spacing.md),
              _buildMacroTile(context, 'FAT', '$fat', 'g', fatProgress, LinearGradient(colors: tokens.gradients.fat), Icons.water_drop_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildT2MacroRingChart(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
      child: Row(
        children: [
          _buildRingItem(context, "${(calorieProgress * 100).toInt()}%", "$calories kcal", "Cals", tokens.colors.calories, calorieProgress),
          SizedBox(width: tokens.spacing.xs),
          _buildRingItem(context, "${(proteinProgress * 100).toInt()}%", "${protein}g", "Protein", tokens.colors.protein, proteinProgress),
          SizedBox(width: tokens.spacing.xs),
          _buildRingItem(context, "${(carbsProgress * 100).toInt()}%", "${carbs}g", "Carbs", tokens.colors.carbs, carbsProgress),
          SizedBox(width: tokens.spacing.xs),
          _buildRingItem(context, "${(fatProgress * 100).toInt()}%", "${fat}g", "Fat", tokens.colors.fat, fatProgress),
        ],
      ),
    );
  }

  // T1 Helpers
  Widget _buildMacroTile(BuildContext context, String label, String value, String unit, double percentage, Gradient gradient, IconData icon) {
    final tokens = context.tokens;
    return Expanded(
      child: AspectRatio(
        aspectRatio: 0.92,
        child: Container(
          padding: EdgeInsets.all(tokens.spacing.md),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(tokens.radius.lg),
            boxShadow: [
              BoxShadow(
                color: (gradient as LinearGradient).colors.last.withValues(alpha: 0.2),
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
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(tokens.radius.sm)),
                    child: Icon(icon, size: 16, color: Colors.white),
                  ),
                  Text('${(percentage * 100).toInt()}%', style: tokens.typography.labelSmall.copyWith(color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: value, style: tokens.typography.headlineMedium.copyWith(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, height: 1)),
                    TextSpan(text: ' $unit', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(label, style: tokens.typography.labelSmall.copyWith(color: Colors.white.withValues(alpha: 0.5), letterSpacing: 1.0, fontWeight: FontWeight.w700)),
              SizedBox(height: tokens.spacing.sm),
              AppMacroLinearBar(progress: percentage, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  // T2 Helpers
  Widget _buildRingItem(BuildContext context, String percentStr, String gramStr, String label, Color color, double percent) {
    final tokens = context.tokens;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: tokens.spacing.md, horizontal: tokens.spacing.xs),
        decoration: BoxDecoration(color: tokens.colors.surfaceContainerLowest, borderRadius: BorderRadius.circular(tokens.radius.md)),
        child: Column(
          children: [
            AppMacroRing(progress: percent, color: color),
            SizedBox(height: tokens.spacing.sm),
            Text(percentStr, style: tokens.typography.labelLarge.copyWith(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            Text(gramStr, style: tokens.typography.labelSmall.copyWith(fontSize: 10, color: tokens.colors.onSurface.withValues(alpha: 0.6))),
            Text(label.toUpperCase(), style: tokens.typography.labelSmall.copyWith(fontSize: 8, letterSpacing: 1.2, color: tokens.colors.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
