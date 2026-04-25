import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_button.dart';
import '../mock/meal_planner_mock.dart';

class RecipeCard extends StatelessWidget {
  final RecipeData recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final headerGradient = recipe.isExotic
        ? const LinearGradient(colors: [Color(0xFF300810), Color(0xFF702030)])
        : const LinearGradient(colors: [Color(0xFF1A0040), Color(0xFF3A1090)]);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(gradient: headerGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.type.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withOpacity(0.55),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMacro(theme, recipe.protein, 'Prot'),
                      _buildMacro(theme, recipe.carbs, 'Carb'),
                      _buildMacro(theme, recipe.fat, 'Fat'),
                      _buildMacro(theme, recipe.match, 'Match', isAccent: true),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: recipe.tags.map((tag) => _buildTag(theme, tag)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DmButton(
                    label: 'Add to Plan',
                    onPressed: () {},
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacro(ThemeData theme, String value, String label, {bool isAccent = false}) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 16,
            color: isAccent ? theme.colorScheme.primary : null,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.4),
          fontSize: 9,
        ),
      ),
    );
  }
}
