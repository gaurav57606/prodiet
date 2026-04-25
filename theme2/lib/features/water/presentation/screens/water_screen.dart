import 'package:flutter/material.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import '../widgets/hydration_hero.dart';
import '../widgets/quick_add_grid.dart';
import '../widgets/water_log_list.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hydration",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HydrationHero(isOverdue: false),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(
                "QUICK ADD",
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const QuickAddGrid(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(
                "Today's Log",
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const WaterLogList(),

            const SizedBox(height: 20),
            Center(
              child: Text(
                "← Overdue state demo →",
                style: theme.textTheme.bodySmall,
              ),
            ),
            const HydrationHero(isOverdue: true),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
