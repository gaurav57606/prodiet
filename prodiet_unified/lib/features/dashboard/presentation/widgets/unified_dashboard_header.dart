import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/widgets/theme_toggle.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';

class UnifiedDashboardHeader extends ConsumerWidget {
  const UnifiedDashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    
    if (tokens.useFloatingHeader) {
      return const SliverAppBar(
        floating: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Dashboard'),
        actions: [
          ThemeToggle(),
          SizedBox(width: 8),
        ],
      );
    }

    final user = ref.watch(currentUserProvider);
    final name = user?.name?.split(' ').first ?? 'there';
    final greeting = 'Good morning, $name';
    final summary = ref.watch(dashboardProvider).value;
    final caloriesGoal = summary?.caloriesGoal ?? 2000;
    final caloriesConsumed = summary?.caloriesConsumed ?? 0;
    final caloriesLeft = (caloriesGoal - caloriesConsumed).clamp(0, caloriesGoal);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tokens.useUpperCasing ? greeting.toUpperCase() : greeting,
                    style: tokens.typography.labelSmall.copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tokens.useUpperCasing ? "EAT" : "Eat",
                    style: tokens.typography.displayLarge.copyWith(
                      fontSize: 56, 
                      fontWeight: FontWeight.w900,
                      color: tokens.colors.onSurface,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    tokens.useUpperCasing ? "RIGHT." : "Right.",
                    style: tokens.typography.displayLarge.copyWith(
                      fontSize: 56, 
                      fontWeight: FontWeight.w900,
                      color: tokens.colors.primary,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            // Right Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tokens.useUpperCasing ? "CALORIES LEFT" : "Calories Left",
                  style: tokens.typography.labelSmall.copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: 0.4),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$caloriesLeft',
                  style: tokens.typography.displayLarge.copyWith(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: tokens.colors.primary,
                    letterSpacing: -1.5,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'of $caloriesGoal',
                  style: tokens.typography.labelSmall.copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
