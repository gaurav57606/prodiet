import 'package:flutter/material.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/core/theme/text_styles.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import 'package:dietmate_pro/shared/widgets/dm_macro_chip.dart';

class NextMealCard extends StatelessWidget {
  const NextMealCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LUNCH · 12:30 PM",
                    style: AppTextStyles.sectionLabel(colorScheme),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "In 2h 15m",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                "Quinoa Bowl\n+ Grilled Chicken",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 22,
                  height: 1.1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                "480 kcal · High protein",
                style: theme.textTheme.bodySmall,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.5))),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: DmMacroChip(
                      value: "38g",
                      label: "Protein",
                      type: MacroType.protein,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: DmMacroChip(
                      value: "45g",
                      label: "Carbs",
                      type: MacroType.carbs,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: DmMacroChip(
                      value: "12g",
                      label: "Fat",
                      type: MacroType.fat,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: DmMacroChip(
                      value: "4g",
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
    );
  }
}
