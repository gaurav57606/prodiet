import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class DailyScheduleList extends StatelessWidget {
  const DailyScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final schedule = [
      {'time': '7:30', 'ap': 'AM', 'type': 'Breakfast', 'name': 'Oats + Banana Smoothie', 'cals': '320 kcal · 28g protein', 'status': 'done'},
      {'time': '10:00', 'ap': 'AM', 'type': 'Snack', 'name': 'Almonds + Fruit', 'cals': '180 kcal · 6g protein', 'status': 'miss'},
      {'time': '12:30', 'ap': 'PM', 'type': 'Lunch ⚡', 'name': 'Quinoa Bowl + Chicken', 'cals': '495 kcal · 53g protein', 'status': 'pend'},
      {'time': '4:00', 'ap': 'PM', 'type': 'Snack', 'name': 'Greek Yogurt + Honey', 'cals': '150 kcal · 15g protein', 'status': 'pend'},
      {'time': '7:30', 'ap': 'PM', 'type': 'Dinner', 'name': 'Grilled Salmon + Veggies', 'cals': '420 kcal · 42g protein', 'status': 'pend'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: schedule.length,
          separatorBuilder: (context, index) => Divider(height: 1, color: theme.colorScheme.outline),
          itemBuilder: (context, index) {
            final item = schedule[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['time']!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          item['ap']!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 34,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['type']!.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(item['name']!, style: theme.textTheme.titleMedium),
                        Text(item['cals']!, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  _buildStatus(context, item['status']!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context, String status) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final error = theme.colorScheme.error;

    if (status == 'done') {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), shape: BoxShape.circle),
        child: Icon(Icons.check, size: 10, color: primary),
      );
    } else if (status == 'miss') {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: error.withValues(alpha: 0.12), shape: BoxShape.circle),
        child: Icon(Icons.close, size: 10, color: error),
      );
    } else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.outline, width: 1.5),
        ),
      );
    }
  }
}
