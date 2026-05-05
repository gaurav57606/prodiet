import 'package:flutter/material.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import 'package:dietmate_pro/core/theme/color_schemes.dart';

class WaterOverdueState extends StatelessWidget {
  const WaterOverdueState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coralColor = const Color(0xFFFF5C3A);
    
    return Padding(
      padding: const EdgeInsets.all(18),
      child: DmCard(
        padding: const EdgeInsets.all(20),
        backgroundColor: AppColors.coralLight,
        borderSide: BorderSide(color: AppColors.coral.withValues(alpha: 0.35), width: 1),
        child: Column(
          children: [
            Text(
              "OVERDUE!",
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: coralColor,
                height: 1.0,
              ),
            ),
            Text(
              "DRINK WATER NOW",
              style: theme.textTheme.labelSmall?.copyWith(
                color: coralColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: coralColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: coralColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, color: coralColor, size: 14),
                  const SizedBox(width: 7),
                  Text(
                    "42 minutes since last drink",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: coralColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: 0.38,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(coralColor),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "950ml of 2,500ml · Behind schedule",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: coralColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
