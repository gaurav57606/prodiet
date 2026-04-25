import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/features/diet_plan/presentation/widgets/diet_hero.dart';
import 'package:dietmate_pro/features/diet_plan/presentation/widgets/day_tabs.dart';
import 'package:dietmate_pro/features/diet_plan/presentation/widgets/daily_schedule_list.dart';
import 'package:dietmate_pro/features/dashboard/presentation/widgets/alert_strip.dart';

class DietPlanScreen extends StatelessWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Diet Plan",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.pushNamed('dietPlanDetail'),
              child: const DietHero(),
            ),
            const DayTabs(),
            const AlertStrip(
              message: "Skipped snack — lunch adjusted",
              subMessage: "+15g protein auto-added to dinner",
              isWarning: true,
            ),
            
            Padding(
              padding: const EdgeInsets.all(18),
              child: GestureDetector(
                onTap: () => context.pushNamed('preferences'),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB06EFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x33B06EFF)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: Color(0xFFB06EFF), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Import Nutritionist Chart",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB06EFF),
                              ),
                            ),
                            Text(
                              "Scan or upload · Auto-extract diet info",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const DailyScheduleList(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
