import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import '../mock/diet_plan_mock.dart';

class MealTimelineItem extends StatelessWidget {
  final MealTimelineItemData data;
  final bool isLast;

  const MealTimelineItem({
    super.key,
    required this.data,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color statusColor;
    IconData? statusIcon;
    switch (data.status) {
      case MealStatus.done:
        statusColor = const Color(0xFF40D8B8);
        statusIcon = Icons.check_rounded;
        break;
      case MealStatus.missed:
        statusColor = const Color(0xFFFF6080);
        statusIcon = Icons.close_rounded;
        break;
      case MealStatus.pending:
        statusColor = theme.colorScheme.onSurface.withOpacity(0.2);
        statusIcon = null;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          // Time section
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.time,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  data.period,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: T1Spacing.md),

          // Timeline line and dot
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: data.status == MealStatus.pending
                      ? Colors.transparent
                      : statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: data.status == MealStatus.pending
                      ? Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.1),
                          width: 1.5)
                      : null,
                ),
                child: statusIcon != null
                    ? Icon(statusIcon, size: 12, color: statusColor)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: T1Spacing.md),

          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: T1Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.type,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    data.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    data.calories,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
