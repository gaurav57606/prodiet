import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'dm_button.dart';

class DmErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const DmErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(T2Spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: T2Spacing.md),
            Text(
              "Something went wrong",
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: T2Spacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: T2Spacing.xl),
              DmButton(
                label: "Try Again",
                onPressed: onRetry,
                variant: DmButtonVariant.outline,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
