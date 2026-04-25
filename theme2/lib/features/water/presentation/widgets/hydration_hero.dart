import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class HydrationHero extends StatelessWidget {
  final bool isOverdue;

  const HydrationHero({super.key, required this.isOverdue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skyColor = const Color(0xFF38BFFF);
    final coralColor = const Color(0xFFFF5C3A);
    final color = isOverdue ? coralColor : skyColor;
    
    return Padding(
      padding: const EdgeInsets.all(18),
      child: DmCard(
        padding: const EdgeInsets.all(20),
        borderSide: isOverdue ? BorderSide(color: coralColor.withOpacity(0.4), width: 1.5) : null,
        child: Column(
          children: [
            Text(
              isOverdue ? "Overdue!" : "18m",
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 64,
                color: color,
                height: 1.0,
              ),
            ),
            Text(
              isOverdue ? "Drink water NOW" : "Next reminder",
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 14),
            if (isOverdue) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: coralColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: coralColor.withOpacity(0.2)),
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
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: isOverdue ? 0.38 : 0.62,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isOverdue 
                  ? "950ml of 2,500ml · Behind schedule"
                  : "1,550ml of 2,500ml · 62%",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isOverdue ? coralColor : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
