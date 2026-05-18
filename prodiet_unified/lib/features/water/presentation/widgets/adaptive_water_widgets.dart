import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:intl/intl.dart';

class AdaptiveWaterHero extends StatelessWidget {
  final int consumed;
  final int target;
  final double progress;

  const AdaptiveWaterHero({
    super.key,
    required this.consumed,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final formatter = NumberFormat('#,###');
    final isT2 = tokens.useUpperCasing;
    
    const t1Color = Color(0xFF00CED1); // Accent Teal
    const t2Color = Color(0xFF00E5FF); // T2 Sky
    final color = isT2 ? t2Color : t1Color;

    return Container(
      width: double.infinity,
      padding: isT2 ? EdgeInsets.zero : const EdgeInsets.all(24),
      decoration: isT2
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
      child: Column(
        crossAxisAlignment: isT2 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (isT2) ...[
            Text(
              'WATER',
              style: tokens.typography.displayLarge.copyWith(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: color,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: formatter.format(consumed),
                    style: tokens.typography.displayLarge.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: tokens.colors.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: ' ml / ${formatter.format(target)} ml',
                    style: tokens.typography.displayLarge.copyWith(
                      fontSize: 16,
                      color: tokens.colors.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  formatter.format(consumed),
                  style: tokens.typography.displayLarge.copyWith(
                    color: color,
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ml',
                  style: tokens.typography.headlineMedium.copyWith(
                    color: color.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Text(
              'OF ${formatter.format(target)} ML TARGET',
              style: tokens.typography.labelSmall.copyWith(
                color: color.withValues(alpha: 0.6),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.1),
              color: color,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ],
      ),
    );
  }
}

class AdaptiveWaterQuickAdd extends StatelessWidget {
  final Function(int) onAdd;

  const AdaptiveWaterQuickAdd({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.waterQuickAddCrossAxisCount == 3;

    final amounts = [
      {'val': 250, 'lbl': '250ml', 'icon': Icons.local_drink_rounded},
      {'val': 500, 'lbl': '500ml', 'icon': Icons.water_drop_rounded},
      {'val': 750, 'lbl': '750ml', 'icon': Icons.wine_bar_rounded},
      {'val': 1000, 'lbl': '1L', 'icon': Icons.coffee_rounded},
      if (isT2) ...[
        {'val': 1500, 'lbl': '1.5L', 'icon': Icons.opacity_rounded},
        {'val': 2000, 'lbl': '2L', 'icon': Icons.waves_rounded},
      ],
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: tokens.waterQuickAddCrossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isT2 ? 1.8 : 1.5,
      children: amounts.map((a) {
        final val = a['val'] as int;
        return InkWell(
          onTap: () => onAdd(val),
          borderRadius: BorderRadius.circular(isT2 ? 16 : 24),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tokens.colors.surfaceContainerHigh.withValues(alpha: isT2 ? 0.3 : 1.0),
              borderRadius: BorderRadius.circular(isT2 ? 12 : 24),
              border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isT2) ...[
                  Icon(a['icon'] as IconData, color: const Color(0xFF00CED1), size: 20),
                  const SizedBox(width: 12),
                ],
                Text(
                  a['lbl'] as String,
                  style: (isT2 ? tokens.typography.labelMedium.copyWith(fontSize: 14) : tokens.typography.titleMedium).copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
