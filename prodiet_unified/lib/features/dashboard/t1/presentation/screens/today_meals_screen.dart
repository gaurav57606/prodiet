import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_macro_chip.dart';

class TodayMealsScreen extends StatelessWidget {
  const TodayMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Meals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(T1Spacing.lg),
        children: [
          _buildSummaryHeader(theme),
          const SizedBox(height: T1Spacing.xl),
          Text(
            'LOGGED MEALS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: T1Spacing.md),
          _buildMealCard(
            theme,
            'BREAKFAST',
            'Oatmeal with Blueberries',
            '08:15 AM',
            320,
            {'PROT': '12g', 'CARB': '45g', 'FAT': '8g'},
            const Color(0xFFC080FF),
          ),
          const SizedBox(height: 12),
          _buildMealCard(
            theme,
            'LUNCH',
            'Grilled Chicken Quinoa Bowl',
            '01:30 PM',
            480,
            {'PROT': '38g', 'CARB': '42g', 'FAT': '12g'},
            const Color(0xFFFF8C64),
          ),
          const SizedBox(height: 12),
          _buildMealCard(
            theme,
            'SNACK',
            'Greek Yogurt & Nuts',
            '04:45 PM',
            180,
            {'PROT': '15g', 'CARB': '12g', 'FAT': '10g'},
            const Color(0xFF40D8B8),
          ),
          const SizedBox(height: 12),
          _buildEmptyMealCard(theme, 'DINNER', 'Scheduled for 07:30 PM'),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('LOG MEAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme) {
    return DmCard(
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryStat(theme, 'TOTAL KCAL', '980', theme.colorScheme.primary),
          _buildSummaryStat(theme, 'REMAINING', '1020', const Color(0xFF40D8B8)),
          _buildSummaryStat(theme, 'MEALS', '3/4', Colors.white.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 8,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(
    ThemeData theme,
    String type,
    String name,
    String time,
    int kcal,
    Map<String, String> macros,
    Color accentColor,
  ) {
    return DmCard(
      padding: EdgeInsets.zero,
      color: accentColor.withOpacity(0.06),
      borderSide: BorderSide(color: accentColor.withOpacity(0.15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$type · $time',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: accentColor.withOpacity(0.6),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$kcal kcal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: macros.entries.map((e) {
                return Row(
                  children: [
                    Text(
                      e.key,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      e.value,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMealCard(ThemeData theme, String type, String subtext) {
    return DmCard(
      color: Colors.white.withOpacity(0.02),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtext,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Icon(Icons.add_circle_outline_rounded, color: theme.colorScheme.primary.withOpacity(0.4)),
        ],
      ),
    );
  }
}
