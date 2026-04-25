import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/calorie_summary_card.dart';
import '../widgets/hydration_card.dart';
import '../widgets/macro_grid.dart';
import '../widgets/today_meals_row.dart';
import '../widgets/activity_grid.dart';
import '../widgets/alerts_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: CalorieSummaryCard()),
          
          SliverPadding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            sliver: SliverToBoxAdapter(child: const HydrationCard()),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Macros Today',
                onAction: () {},
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: MacroGrid()),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Next Meal',
                onAction: () {},
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: TodayMealsRow()),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Activity · Fitband',
                onAction: () {},
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: ActivityGrid()),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Alerts',
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: AlertsList()),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.25),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
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
