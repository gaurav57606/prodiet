import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        ref.read(themeProvider.notifier).state =
            isDark ? ThemeMode.light : ThemeMode.dark;
      },
      tooltip: 'Toggle Theme',
    );
  }
}
