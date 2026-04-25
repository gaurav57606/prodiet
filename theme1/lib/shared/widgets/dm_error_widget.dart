import 'package:flutter/material.dart';
import 'dm_button.dart';
import '../../core/theme/app_spacing.dart';

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
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              DmButton(
                label: 'Try Again',
                onPressed: onRetry,
                variant: DmButtonVariant.outline,
                width: 150,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
