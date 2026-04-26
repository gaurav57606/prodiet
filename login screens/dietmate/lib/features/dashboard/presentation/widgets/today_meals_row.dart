import 'package:flutter/material.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_card.dart';

class TodayMealsRow extends StatelessWidget {
  const TodayMealsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TODAY\'S MEALS', style: context.textTheme.labelLarge),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMealCard(context, 'Breakfast', 'Oatmeal with berries', '350 kcal', Icons.wb_sunny_outlined),
              const SizedBox(width: AppSpacing.md),
              _buildMealCard(context, 'Lunch', 'Chicken Salad', '450 kcal', Icons.wb_cloudy_outlined),
              const SizedBox(width: AppSpacing.md),
              _buildMealCard(context, 'Snack', 'Greek Yogurt', '150 kcal', Icons.coffee_outlined),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, String title, String menu, String cals, IconData icon) {
    return DmCard(
      padding: 14,
      borderRadius: 20,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.colorScheme.primary, size: 20),
            const SizedBox(height: 12),
            Text(title, style: context.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              menu,
              style: context.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              cals,
              style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

