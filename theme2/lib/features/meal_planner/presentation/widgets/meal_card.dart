import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_button.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
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
            Row(
              children: [
                _buildMacro(context, "38g", "Protein", const Color(0xFFFF5C3A)),
                const SizedBox(width: 5),
                _buildMacro(context, "45g", "Carbs", const Color(0xFFFFB800)),
                const SizedBox(width: 5),
                _buildMacro(context, "12g", "Fat", const Color(0xFFB06EFF)),
                const SizedBox(width: 5),
                _buildMacro(context, "4g", "Fibre", const Color(0xFF3DCC7E)),
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

  Widget _buildMacro(BuildContext context, String value, String label, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 14, color: color),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
