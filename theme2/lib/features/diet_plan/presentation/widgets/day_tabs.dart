import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class DayTabs extends StatelessWidget {
  const DayTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final days = [
      {'d': 'Today', 'n': 'Sat'},
      {'d': 'Sun', 'n': '22'},
      {'d': 'Mon', 'n': '23'},
      {'d': 'Tue', 'n': '24'},
      {'d': 'Wed', 'n': '25'},
      {'d': 'Thu', 'n': '26'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: days.map((day) {
          final isToday = day['d'] == 'Today';
          return _buildTab(context, day['d']!, day['n']!, isToday);
        }).toList(),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String day, String date, bool isSelected) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? primary.withOpacity(0.12) : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isSelected ? primary.withOpacity(0.3) : theme.colorScheme.outline,
        ),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 8,
              color: isSelected ? primary : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            date,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 11,
              color: isSelected ? primary : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
