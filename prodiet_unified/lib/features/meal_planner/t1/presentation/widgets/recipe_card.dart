import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import '../mock/meal_planner_mock.dart';

class RecipeCard extends StatelessWidget {
  final RecipeData recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final accentColor = recipe.isExotic
        ? const Color(0xFFFF3060)
        : const Color(0xFF8B5CF6);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
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
                        accentColor.withOpacity(0.2),
                        accentColor.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      recipe.type == 'Breakfast' ? Icons.wb_sunny_rounded : Icons.restaurant_rounded,
                      size: 48,
                      color: accentColor.withOpacity(0.3),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '25m',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
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
                    recipe.type.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor.withOpacity(0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.name,
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
                      _buildMacro(theme, 'P', recipe.protein, const Color(0xFFFF3060)),
                      _buildMacro(theme, 'C', recipe.carbs, const Color(0xFFFFB870)),
                      _buildMacro(theme, 'F', recipe.fat, const Color(0xFF40D8B8)),
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
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
