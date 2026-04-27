import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/text_styles.dart';
import '../widgets/calorie_summary_card.dart';
import '../widgets/hydration_card.dart';
import '../widgets/macro_grid.dart';
import '../widgets/today_meals_row.dart';
import '../widgets/activity_grid.dart';
import '../widgets/alerts_list.dart';

import '../../../../core/widgets/theme_toggle.dart';

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
            
            const SliverToBoxAdapter(child: HydrationCard()),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: _SectionHeader(
                  title: 'Macros Today',
                  onAction: () {},
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: MacroGrid()),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: _SectionHeader(
                  title: 'Next Meal',
                  onAction: () {},
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: TodayMealsRow()),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: _SectionHeader(
                  title: 'Activity · Fitband',
                  onAction: () => context.pushNamed(AppRoutes.activitySyncName),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: ActivityGrid()),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
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
          style: AppTextStyleExtensions.sectionLabel(scheme),
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
