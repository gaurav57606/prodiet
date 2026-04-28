import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/error/app_error.dart';

class ProDietErrorWidget extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;
  const ProDietErrorWidget({required this.error, this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    // Use existing app theme colors — no hardcoded colors
    final isOffline = error is OfflineError || error is NetworkError;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              size: 48,
              // Use theme color — do not hardcode
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              error.displayMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
