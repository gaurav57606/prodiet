import 'package:flutter/material.dart';
import 'package:dietmate_pro/core/theme/text_styles.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import '../widgets/water_good_state.dart';
import '../widgets/water_overdue_state.dart';
import '../widgets/quick_add_grid.dart';
import '../widgets/water_log_list.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  bool isOverdue = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hydration",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        centerTitle: false,
        actions: [
          // Demo toggle
          Switch(
            value: isOverdue,
            onChanged: (val) => setState(() => isOverdue = val),
            activeColor: const Color(0xFFFF5C3A),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DUAL STATE HERO
            if (isOverdue)
              const WaterOverdueState()
            else
              const WaterGoodState(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(
                "QUICK ADD",
                style: AppTextStyles.sectionLabel(colorScheme),
              ),
            ),
            const QuickAddGrid(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(
                "TODAY'S LOG",
                style: AppTextStyles.sectionLabel(colorScheme),
              ),
            ),
            const WaterLogList(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
