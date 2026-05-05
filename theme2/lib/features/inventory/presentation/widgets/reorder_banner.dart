import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class ReorderBanner extends StatelessWidget {
  const ReorderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coralColor = const Color(0xFFFF5C3A);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: coralColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: coralColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: coralColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.warning_amber_rounded, color: coralColor, size: 13),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "4 items running low",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: coralColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Paneer, Oats, Almonds, Spinach",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Text(
              "Order ›",
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFFFF5C3A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
