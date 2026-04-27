import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_chip.dart';
import '../../../../shared/widgets/dm_macro_chip.dart';

class TodayMealsRow extends StatelessWidget {
  const TodayMealsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DmCard(
      padding: EdgeInsets.zero,
      color: isDark ? const Color(0xFFFF8C64).withOpacity(0.08) : const Color(0xFFFFE6D7).withOpacity(0.85),
      borderSide: BorderSide(color: const Color(0xFFFF8C64).withOpacity(0.18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LUNCH · 12:30 PM',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFFFF8C64).withOpacity(0.6),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const DmChip(
                      label: 'In 2h 15m',
                      isSelected: true,
                      backgroundColor: Color(0x2EFF965A),
                      textColor: Color(0xFFFFB870),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Quinoa Bowl +\nGrilled Chicken',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '480 kcal · High protein · Easy prep',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.12)),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(value: '38g', label: 'PROT', type: MacroType.protein),
                    ),
                  ),
                ),
                _buildDivider(),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(value: '45g', label: 'CARB', type: MacroType.carbs),
                    ),
                  ),
                ),
                _buildDivider(),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(value: '12g', label: 'FAT', type: MacroType.fat),
                    ),
                  ),
                ),
                _buildDivider(),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(value: '4g', label: 'FIBRE', type: MacroType.fibre),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withOpacity(0.12),
    );
  }
}
