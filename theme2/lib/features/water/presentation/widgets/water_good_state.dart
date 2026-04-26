import 'package:flutter/material.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';

class WaterGoodState extends StatelessWidget {
  const WaterGoodState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skyColor = const Color(0xFF38BFFF);
    
    return Padding(
      padding: const EdgeInsets.all(18),
      child: DmCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "18m",
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 64,
                color: skyColor,
                height: 1.0,
              ),
            ),
            Text(
              "NEXT REMINDER",
              style: theme.textTheme.labelSmall?.copyWith(
                color: skyColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: 0.62,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(skyColor),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "1,550ml of 2,500ml · 62%",
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
