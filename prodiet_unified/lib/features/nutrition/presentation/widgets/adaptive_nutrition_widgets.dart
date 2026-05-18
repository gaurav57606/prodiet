import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';
import 'package:prodiet_unified/core/design_system/components/app_macro_stat.dart';

class AdaptiveMacroSection extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fats;

  const AdaptiveMacroSection({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return AppCard(
      padding: EdgeInsets.all(isT2 ? 24 : tokens.spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppMacroStat(
            value: '${protein.toInt()}g',
            label: 'Protein',
            type: MacroType.protein,
            showDecoration: isT2,
          ),
          AppMacroStat(
            value: '${carbs.toInt()}g',
            label: 'Carbs',
            type: MacroType.carbs,
            showDecoration: isT2,
          ),
          AppMacroStat(
            value: '${fats.toInt()}g',
            label: 'Fats',
            type: MacroType.fat,
            showDecoration: isT2,
          ),
        ],
      ),
    );
  }
}

