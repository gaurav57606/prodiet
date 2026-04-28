import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/macro_ring_chart.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/water_banner.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/next_meal_card.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/activity_row.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/alert_strip.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/calorie_stat.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
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
                            color: T2Colors.textSecondary,
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
                            color: T2Colors.lime,
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
                            color: T2Colors.textSecondary,
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
                            color: T2Colors.lime,
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'of 2,000',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: T2Colors.textSecondary,
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
              child: Divider(color: T2Colors.border, height: 1, thickness: 1),
            ),

            // Water Banner
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => context.goNamed('t2Water'),
                child: const WaterBanner(),
              ),
            ),
            
            // Macros Today Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(T2Spacing.lg, T2Spacing.lg, T2Spacing.lg, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "MACROS TODAY",
                      style: T2TextStyles.sectionLabel(colorScheme),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed('t2DietPlan'),
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
                padding: EdgeInsets.fromLTRB(T2Spacing.lg, T2Spacing.md, T2Spacing.lg, T2Spacing.md),
                child: MacroRingChart(),
              ),
            ),

            // Next Meal Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: T2Spacing.lg, vertical: T2Spacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "NEXT MEAL",
                      style: T2TextStyles.sectionLabel(colorScheme),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed('t2Meals'),
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
                padding: const EdgeInsets.symmetric(horizontal: T2Spacing.lg, vertical: T2Spacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ACTIVITY · FITBAND",
                      style: T2TextStyles.sectionLabel(colorScheme),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed('t2Fitband'),
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
                onTap: () => context.goNamed('t2Compensation'),
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
