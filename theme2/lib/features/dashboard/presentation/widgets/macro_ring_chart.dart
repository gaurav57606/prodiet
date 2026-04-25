import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class MacroRingChart extends StatelessWidget {
  const MacroRingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          _buildMacroItem(context, "69%", "Cals", Theme.of(context).colorScheme.primary, 0.69),
          const SizedBox(width: 6),
          _buildMacroItem(context, "58%", "Protein", const Color(0xFFFF5C3A), 0.58),
          const SizedBox(width: 6),
          _buildMacroItem(context, "80%", "Carbs", const Color(0xFFFFB800), 0.80),
          const SizedBox(width: 6),
          _buildMacroItem(context, "40%", "Fat", const Color(0xFFB06EFF), 0.40),
        ],
      ),
    );
  }

  Widget _buildMacroItem(BuildContext context, String value, String label, Color color, double percent) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: DmCard(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Column(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 4,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 4,
                      color: color,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 14,
                color: color,
              ),
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
