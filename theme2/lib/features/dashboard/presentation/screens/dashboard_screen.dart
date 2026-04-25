import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/macro_ring_chart.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/water_banner.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/next_meal_card.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/activity_row.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/alert_strip.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.surface,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Eat Right,", style: theme.textTheme.displayMedium),
                    Text("Stay Fit", style: theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildCalorieStat(context, "1,240", "kcal left", true),
                        const SizedBox(width: 20),
                        _buildCalorieStat(context, "840", "eaten", false),
                        const SizedBox(width: 20),
                        _buildCalorieStat(context, "320", "burned", false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GestureDetector(
                  onTap: () => context.pushNamed('water'),
                  child: const WaterBanner(),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Macros Today", style: theme.textTheme.titleLarge),
                      GestureDetector(
                        onTap: () => context.goNamed('dietPlan'),
                        child: Text(
                          "Full view",
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: MacroRingChart(),
                ),

                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Next Meal", style: theme.textTheme.titleLarge),
                      GestureDetector(
                        onTap: () => context.goNamed('meals'),
                        child: Text(
                          "Meal plan ›",
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const NextMealCard(),

                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Activity · Fitband", style: theme.textTheme.titleLarge),
                      GestureDetector(
                        onTap: () => context.pushNamed('fitband'),
                        child: Text(
                          "Details",
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const ActivityRow(),

                GestureDetector(
                  onTap: () => context.pushNamed('compensation'),
                  child: const AlertStrip(
                    message: "Skipped snack → Dinner adjusted",
                    subMessage: "+15g protein auto-added to dinner",
                    isWarning: true,
                  ),
                ),
                
                const SizedBox(height: 100), // Space for FAB/Nav
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieStat(BuildContext context, String value, String label, bool isMain) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: isMain ? 32 : 20,
            color: isMain ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
