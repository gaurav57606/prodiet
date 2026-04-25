import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class WaterLogList extends StatelessWidget {
  const WaterLogList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skyColor = const Color(0xFF38BFFF);
    
    final logs = [
      {'amt': '500ml', 'time': '9:00 AM', 'ago': '3h ago'},
      {'amt': '300ml', 'time': '7:45 AM', 'ago': '4h ago'},
      {'amt': '750ml', 'time': '7:00 AM', 'ago': '5h ago'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: theme.colorScheme.outline,
          ),
          itemBuilder: (context, index) {
            final log = logs[index];
            return Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: skyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(log['amt']!, style: theme.textTheme.titleMedium),
                      Text(log['time']!, style: theme.textTheme.labelSmall),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    log['ago']!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
