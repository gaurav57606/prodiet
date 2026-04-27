import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/core/theme/color_schemes.dart';
import 'package:dietmate_pro/core/theme/text_styles.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/macro_ring_chart.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/water_banner.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/next_meal_card.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/activity_row.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/alert_strip.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/calorie_stat.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.bgDefault,
      body: SafeArea(
        top: true,
        child: CustomScrollView(
          slivers: [
            // Static Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good morning, Rohan",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "EAT",
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          "RIGHT.",
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: AppColors.lime,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    // Right Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "CALORIES LEFT",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "620",
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: AppColors.lime,
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'of 2,000',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Calorie Stat Bar
            const SliverToBoxAdapter(
              child: CalorieStat(),
            ),

            // Divider
            const SliverToBoxAdapter(
              child: Divider(color: AppColors.border, height: 1, thickness: 1),
            ),

            // Water Banner
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => context.goNamed('water'),
                child: const WaterBanner(),
              ),
            ),
            
            // Macros Today Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "MACROS TODAY",
                      style: AppTextStyles.sectionLabel(colorScheme),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed('dietPlan'),
                      child: Text(
                        "Full view",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
                child: MacroRingChart(),
              ),
            ),

            // Next Meal Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "NEXT MEAL",
                      style: AppTextStyles.sectionLabel(colorScheme),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed('meals'),
                      child: Text(
                        "Meal plan ›",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: NextMealCard(),
            ),

            // Activity Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ACTIVITY · FITBAND",
                      style: AppTextStyles.sectionLabel(colorScheme),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed('fitband'),
                      child: Text(
                        "Details",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: ActivityRow(),
            ),

            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => context.goNamed('compensation'),
                child: const AlertStrip(
                  message: "Skipped snack → Dinner adjusted",
                  subMessage: "+15g protein auto-added to dinner",
                  isWarning: true,
                ),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
