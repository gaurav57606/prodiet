import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import '../mock/diet_plan_mock.dart';

class DaySelector extends StatefulWidget {
  const DaySelector({super.key});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: T1Spacing.md),
        itemCount: DietPlanMockData.weekDays.length,
        itemBuilder: (context, index) {
          final day = DietPlanMockData.weekDays[index];
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? (isDark ? const Color(0xFFC090FF).withValues(alpha: 0.2) : const Color(0xFF6020A0).withValues(alpha: 0.15))
                    : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected 
                      ? (isDark ? const Color(0xFFC090FF) : const Color(0xFF6020A0))
                      : theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSelected ? (isDark ? const Color(0xFFC090FF) : const Color(0xFF6020A0)) : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      fontSize: 8,
                    ),
                  ),
                  Text(
                    day.date,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected ? (isDark ? const Color(0xFFC090FF) : const Color(0xFF6020A0)) : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
