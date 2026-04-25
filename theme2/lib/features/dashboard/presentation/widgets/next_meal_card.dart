import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class NextMealCard extends StatelessWidget {
  const NextMealCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
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
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Text(
                "480 kcal · High protein",
                style: theme.textTheme.bodySmall,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.colorScheme.outline)),
              ),
              child: Row(
                children: [
                  _buildStat(context, "38g", "Protein", const Color(0xFFFF5C3A)),
                  _buildStat(context, "45g", "Carbs", const Color(0xFFFFB800)),
                  _buildStat(context, "12g", "Fat", const Color(0xFFB06EFF)),
                  _buildStat(context, "4g", "Fibre", const Color(0xFF3DCC7E), isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label, Color color, {bool isLast = false}) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          border: isLast ? null : Border(right: BorderSide(color: theme.colorScheme.outline)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 15, color: color),
            ),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 8, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
