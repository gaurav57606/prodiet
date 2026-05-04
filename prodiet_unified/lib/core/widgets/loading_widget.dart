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

// Full-page loading for auth transitions (splash → dashboard)
// Shows pulsing logo + message. Never looks "stuck".
class ProDietAuthLoader extends StatefulWidget {
  final String message;
  const ProDietAuthLoader({
    this.message = 'Getting things ready...',
    super.key,
  });
  @override
  State<ProDietAuthLoader> createState() => _ProDietAuthLoaderState();
}

class _ProDietAuthLoaderState extends State<ProDietAuthLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: const Text(
                '🥗',
                style: TextStyle(fontSize: 72),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ProDiet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
