import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dietmate_pro/core/theme/color_schemes.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MEALS',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lime,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '5 scheduled meals for today',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildMealCard(
                  time: '08:00 AM',
                  name: 'Oatmeal with Berries',
                  kcal: '320',
                  status: 'Done',
                  accentColor: AppColors.textMuted,
                  isDone: true,
                ),
                const SizedBox(height: 12),
                _buildMealCard(
                  time: '11:00 AM',
                  name: 'Protein Shake',
                  kcal: '180',
                  status: 'MISSING',
                  accentColor: AppColors.coral,
                  isMissing: true,
                ),
                const SizedBox(height: 12),
                _buildMealCard(
                  time: '01:30 PM',
                  name: 'Quinoa Bowl + Chicken',
                  kcal: '480',
                  status: 'Upcoming',
                  accentColor: AppColors.lime,
                ),
                const SizedBox(height: 12),
                _buildMealCard(
                  time: '04:30 PM',
                  name: 'Mixed Nuts',
                  kcal: '150',
                  status: 'Upcoming',
                  accentColor: AppColors.lime,
                ),
                const SizedBox(height: 12),
                _buildMealCard(
                  time: '08:00 PM',
                  name: 'Grilled Salmon & Veggies',
                  kcal: '520',
                  status: 'Upcoming',
                  accentColor: AppColors.lime,
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String time,
    required String name,
    required String kcal,
    required String status,
    required Color accentColor,
    bool isDone = false,
    bool isMissing = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMissing ? AppColors.coral.withOpacity(0.5) : AppColors.border,
          width: isMissing ? 1.5 : 1.0,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: isDone ? Colors.transparent : accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (isMissing)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.coral.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'MISSING',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: AppColors.coral,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDone ? AppColors.textMuted : Colors.white,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: kcal,
                                style: GoogleFonts.barlowCondensed(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: isDone ? AppColors.textMuted : AppColors.lime,
                                ),
                              ),
                              TextSpan(
                                text: ' kcal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (!isDone)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                'Swap',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        if (isDone)
                          const Icon(Icons.check_circle, color: AppColors.textMuted, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
