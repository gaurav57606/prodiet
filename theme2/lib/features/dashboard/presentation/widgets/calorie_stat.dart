import 'package:flutter/material.dart';

class CalorieStatWidget extends StatelessWidget {
  final String value;
  final String label;
  final bool isMain;

  const CalorieStatWidget({
    super.key,
    required this.value,
    required this.label,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: isMain ? 32 : 20,
            color: isMain ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
