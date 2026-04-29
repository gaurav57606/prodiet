import 'package:flutter/material.dart';

class ProDietEmptyState extends StatelessWidget {
  final String emoji;
  final String headline;
  final String subtext;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;
  const ProDietEmptyState({
    required this.emoji,
    required this.headline,
    required this.subtext,
    this.buttonLabel,
    this.onButtonTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              headline,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtext,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onButtonTap != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onButtonTap,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
