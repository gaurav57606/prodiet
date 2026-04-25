import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/extensions.dart';

class DmDivider extends StatelessWidget {
  final String? label;

  const DmDivider({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Divider(color: context.colorScheme.outline, height: 1);
    }

    return Row(
      children: [
        Expanded(child: Divider(color: context.colorScheme.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label!,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
        ),
        Expanded(child: Divider(color: context.colorScheme.outline)),
      ],
    );
  }
}
