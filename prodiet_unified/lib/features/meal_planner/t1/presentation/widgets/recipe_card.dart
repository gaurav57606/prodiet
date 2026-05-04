import 'package:flutter/material.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';

class RecipeCard extends StatelessWidget {
  final Meal meal;

  const RecipeCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final accentColor = meal.mealType == 'breakfast'
        ? const Color(0xFFFFB870)
        : meal.mealType == 'lunch'
            ? const Color(0xFF8B5CF6)
            : const Color(0xFFFF3060);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 12,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        accentColor.withValues(alpha: 0.2),
                        accentColor.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      meal.mealType == 'breakfast'
                          ? Icons.wb_sunny_rounded
                          : Icons.restaurant_rounded,
                      size: 48,
                      color: accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                if (meal.status == 'completed')
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF40D8B8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.mealType.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor.withValues(alpha: 0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMacro(
                          theme,
                          'P',
                          '${meal.nutritionalValues.proteinG}g',
                          const Color(0xFFFF3060)),
                      _buildMacro(
                          theme,
                          'C',
                          '${meal.nutritionalValues.carbsG}g',
                          const Color(0xFFFFB870)),
                      _buildMacro(theme, 'F', '${meal.nutritionalValues.fatG}g',
                          const Color(0xFF40D8B8)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacro(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
