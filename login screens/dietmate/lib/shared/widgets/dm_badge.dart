import 'package:flutter/material.dart';
import 'package:dietmate/core/utils/extensions.dart';

class DmBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const DmBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? context.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: textColor ?? context.colorScheme.onPrimary,
          fontSize: 10,
        ),
      ),
    );
  }
}

