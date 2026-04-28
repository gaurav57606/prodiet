import 'package:flutter/material.dart';

// Full-screen loading overlay
class ProDietLoader extends StatelessWidget {
  final String? message;
  const ProDietLoader({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

// Small inline loader for cards
class CardLoader extends StatelessWidget {
  const CardLoader({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}
