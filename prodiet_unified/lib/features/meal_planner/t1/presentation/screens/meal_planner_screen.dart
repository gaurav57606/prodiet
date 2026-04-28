import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_chip.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';
import '../mock/meal_planner_mock.dart';
import '../widgets/recipe_card.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Explorer'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.md),
            child: DmTextField(
              hintText: 'Search for keto recipes...',
              prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
              children: [
                _categoryChip('All', true),
                _categoryChip('Keto', false),
                _categoryChip('High Protein', false),
                _categoryChip('Vegan', false),
                _categoryChip('Quick (15m)', false),
              ],
            ),
          ),
          const SizedBox(height: T1Spacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
            child: Text(
              'RECOMMENDED FOR YOU',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: T1Spacing.md),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: MealPlannerMockData.suggestions.length,
              itemBuilder: (context, index) {
                final recipe = MealPlannerMockData.suggestions[index];
                return RecipeCard(recipe: recipe);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DmChip(
        label: label,
        isSelected: isSelected,
        onSelected: (val) {},
      ),
    );
  }
}
