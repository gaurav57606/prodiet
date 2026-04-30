import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    final isDark = activeTheme == ActiveTheme.t1Dark || activeTheme == ActiveTheme.t1Amoled || 
                   activeTheme == ActiveTheme.t2Dark || activeTheme == ActiveTheme.t2Amoled;

    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        final current = ref.read(activeThemeProvider);
        // Simplified toggle logic for the unified structure
        if (current == ActiveTheme.t1Dark || current == ActiveTheme.t1Amoled) {
          ref.read(activeThemeProvider.notifier).setTheme(ActiveTheme.t1Light);
        } else if (current == ActiveTheme.t1Light) {
          ref.read(activeThemeProvider.notifier).setTheme(ActiveTheme.t1Dark);
        } else if (current == ActiveTheme.t2Dark || current == ActiveTheme.t2Amoled) {
          ref.read(activeThemeProvider.notifier).setTheme(ActiveTheme.t2Light);
        } else if (current == ActiveTheme.t2Light) {
          ref.read(activeThemeProvider.notifier).setTheme(ActiveTheme.t2Dark);
        }
      },
      tooltip: 'Toggle Theme',
    );
  }
}
