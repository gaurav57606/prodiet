import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class WaterBanner extends StatelessWidget {
  const WaterBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skyColor = const Color(0xFF38BFFF);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: DmCard(
        backgroundColor: skyColor.withOpacity(0.12),
        borderSide: BorderSide(color: skyColor.withOpacity(0.25)),
        borderRadius: AppSpacing.radiusMedium,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: skyColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.water_drop, color: skyColor, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Next water in",
                    style: theme.textTheme.labelLarge?.copyWith(color: skyColor),
                  ),
                  Text(
                    "1.5L of 2.5L · On track",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              "18m",
              style: theme.textTheme.displayMedium?.copyWith(
                color: skyColor,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
