import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_chip.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';
import '../widgets/recipe_card.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final mealsAsync = ref.watch(todayMealsProvider(todayStr));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_rounded),
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
              prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
              children: [
                _categoryChip('All', true),
                _categoryChip('Breakfast', false),
                _categoryChip('Lunch', false),
                _categoryChip('Dinner', false),
                _categoryChip('Snacks', false),
              ],
            ),
          ),
          const SizedBox(height: T1Spacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
            child: Text(
              'YOUR MEALS TODAY',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: T1Spacing.md),
          Expanded(
            child: mealsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (meals) {
                if (meals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu_rounded, 
                          size: 64, 
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.1)
                        ),
                        const SizedBox(height: 16),
                        Text('No meals planned for today',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return RecipeCard(meal: meal);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/meals/create'),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
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
