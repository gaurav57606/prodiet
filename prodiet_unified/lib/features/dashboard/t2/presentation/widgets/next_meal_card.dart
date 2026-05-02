import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_macro_chip.dart';

class NextMealCard extends StatelessWidget {
  final Meal? meal;

  const NextMealCard({super.key, this.meal});

  @override
  Widget build(BuildContext context) {
    if (meal == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("No more meals today!", style: TextStyle(color: Colors.white70))),
      );
    }

    final timeStr = DateFormat('HH:mm').format(meal!.scheduledTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: T2Spacing.lg, vertical: T2Spacing.md),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: T2Colors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: T2Colors.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: T2Colors.lime),
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
                            style: const TextStyle(
                              fontSize: 8,
                              letterSpacing: 1.2,
                              color: T2Colors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        meal!.name,
                        style: GoogleFonts.barlowCondensed(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: T2Colors.textPrimary,
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
                                  style: GoogleFonts.barlowCondensed(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: T2Colors.lime,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' kcal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: T2Colors.textSecondary,
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
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: T2Colors.border)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DmMacroChip(
                              value: "${meal!.nutritionalValues.proteinG}g",
                              label: "Protein",
                              type: MacroType.protein,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: DmMacroChip(
                              value: "${meal!.nutritionalValues.carbsG}g",
                              label: "Carbs",
                              type: MacroType.carbs,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: DmMacroChip(
                              value: "${meal!.nutritionalValues.fatG}g",
                              label: "Fat",
                              type: MacroType.fat,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: DmMacroChip(
                              value: "${meal!.nutritionalValues.fiberG}g",
                              label: "Fibre",
                              type: MacroType.fibre,
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
