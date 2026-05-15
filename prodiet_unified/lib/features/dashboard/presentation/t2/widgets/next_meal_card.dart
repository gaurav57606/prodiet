import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/font_config.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/macro_components.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';
import 'package:prodiet_unified/shared/widgets/app_card.dart';

class NextMealCard extends StatelessWidget {
  final Meal? meal;

  const NextMealCard({super.key, this.meal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;

    if (meal == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            "No more meals today!", 
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        ),
      );
    }

    final timeStr = DateFormat('HH:mm').format(meal!.scheduledTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: ext.macroCalories),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${meal!.mealType.toUpperCase()} · $timeStr",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        meal!.name,
                        style: AppFonts.barlowCondensed(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: meal!.nutritionalValues.calories.toString(),
                                  style: AppFonts.barlowCondensed(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: ext.macroCalories,
                                  ),
                                ),
                                TextSpan(
                                  text: ' kcal',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppMacroChip(
                              value: "${meal!.nutritionalValues.proteinG}g",
                              label: "Protein",
                              type: AppMacroType.protein,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: AppMacroChip(
                              value: "${meal!.nutritionalValues.carbsG}g",
                              label: "Carbs",
                              type: AppMacroType.carbs,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: AppMacroChip(
                              value: "${meal!.nutritionalValues.fatG}g",
                              label: "Fat",
                              type: AppMacroType.fat,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: AppMacroChip(
                              value: "${meal!.nutritionalValues.fiberG}g",
                              label: "Fibre",
                              type: AppMacroType.fibre,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
