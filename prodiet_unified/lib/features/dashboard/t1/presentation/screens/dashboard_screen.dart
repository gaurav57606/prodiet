import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_text_styles.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/calorie_summary_card.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/hydration_card.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/macro_grid.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/today_meals_row.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/activity_grid.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/alerts_list.dart';

import 'package:prodiet_unified/core/widgets/theme_toggle.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: const [
                ThemeToggle(),
                SizedBox(width: 8),
              ],
            ),
            const SliverToBoxAdapter(child: CalorieSummaryCard()),
            
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: T1Spacing.lg),
                child: HydrationCard(),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                child: _SectionHeader(
                  title: 'Macros Today',
                  onAction: () => context.go('/meals'),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: MacroGrid()),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                child: _SectionHeader(
                  title: 'Next Meal',
                  onAction: () => context.go('/meals'),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: TodayMealsRow()),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                child: _SectionHeader(
                  title: 'Activity · Fitband',
                  onAction: () => context.pushNamed(AppRoutes.activitySyncName),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: ActivityGrid()),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                child: _SectionHeader(
                  title: 'Alerts',
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: AlertsList()),
            
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.onAction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: T1TextStyleExtensions.sectionLabel(scheme),
        ),
        if (onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              'Full view ›',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
