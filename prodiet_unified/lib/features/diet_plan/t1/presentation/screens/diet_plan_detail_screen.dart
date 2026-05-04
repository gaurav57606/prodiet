import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_macro_chip.dart';

class DietPlanDetailScreen extends StatelessWidget {
  final DietMeal meal;

  const DietPlanDetailScreen({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(T1Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DmCard(
              child: Column(
                children: [
                  Text(
                    'Nutritional Summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: T1Spacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DmMacroChip(
                        value: '${meal.calories.toInt()}',
                        label: 'KCAL',
                        type: MacroType.calories,
                        large: true,
                      ),
                      DmMacroChip(
                        value: '${meal.proteinG.toInt()}g',
                        label: 'PROT',
                        type: MacroType.protein,
                        large: true,
                      ),
                      DmMacroChip(
                        value: '${meal.carbsG.toInt()}g',
                        label: 'CARB',
                        type: MacroType.carbs,
                        large: true,
                      ),
                      DmMacroChip(
                        value: '${meal.fatG.toInt()}g',
                        label: 'FAT',
                        type: MacroType.fat,
                        large: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: T1Spacing.xl),
            Text(
              'INGREDIENTS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: T1Spacing.md),
            if (meal.ingredients.isEmpty)
              const Text('No ingredients listed')
            else
              ...meal.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ing,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
