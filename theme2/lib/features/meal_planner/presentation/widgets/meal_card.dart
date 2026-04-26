import 'package:flutter/material.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/core/theme/text_styles.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import 'package:dietmate_pro/shared/widgets/dm_button.dart';
import 'package:dietmate_pro/shared/widgets/dm_macro_chip.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final skyColor = const Color(0xFF38BFFF);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: DmCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "LUNCH",
                  style: AppTextStyles.sectionLabel(colorScheme),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: skyColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Upcoming",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: skyColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "480",
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 56,
                color: theme.colorScheme.primary,
                height: 1.0,
              ),
            ),
            Text(
              "kcal · 12:30 PM",
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Quinoa Bowl\n+ Grilled Chicken",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 20,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DmButton(
                    label: "Mark Done",
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: DmButton(
                    label: "Steps",
                    variant: DmButtonVariant.ghost,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: DmButton(
                    label: "Skip",
                    variant: DmButtonVariant.danger,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
