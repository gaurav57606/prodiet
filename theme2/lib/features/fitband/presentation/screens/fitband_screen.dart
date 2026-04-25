import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class FitbandScreen extends StatelessWidget {
  const FitbandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Activity Sync",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 26),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: DmCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.watch, color: primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mi Band 8", style: theme.textTheme.titleLarge?.copyWith(fontSize: 14)),
                          Text("Last synced: 2 min ago · Battery 78%", style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(color: primary.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                      child: Text("Connected", style: theme.textTheme.labelLarge?.copyWith(color: primary, fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  _buildBigStat(context, "4,820", "Steps", primary),
                  const SizedBox(width: 6),
                  _buildBigStat(context, "312", "kcal Burned", const Color(0xFFFF5C3A)),
                  const SizedBox(width: 6),
                  _buildBigStat(context, "48m", "Active", const Color(0xFF38BFFF)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Diet adjusted for today's activity", style: theme.textTheme.titleMedium?.copyWith(fontSize: 12, color: primary)),
                    const SizedBox(height: 6),
                    _buildAdjustRow(context, "Extra calories allowed", "+312 kcal"),
                    _buildAdjustRow(context, "Protein target (adjusted)", "162g (+12g)"),
                    _buildAdjustRow(context, "Hydration target", "3.0L (+500ml)"),
                    _buildAdjustRow(context, "Post-workout window", "Eat within 45m", isLast: true),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text("Week Activity vs Intake", style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DmCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Calories burned vs consumed", style: theme.textTheme.labelSmall?.copyWith(fontSize: 10)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChartBar(context, "M", 40, 32),
                          _buildChartBar(context, "T", 52, 44),
                          _buildChartBar(context, "W", 35, 48, isCoral: true),
                          _buildChartBar(context, "T", 58, 40),
                          _buildChartBar(context, "F", 48, 45),
                          _buildChartBar(context, "S", 60, 38),
                          _buildChartBar(context, "S", 0, 38, isToday: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildLegendItem(context, theme.colorScheme.surfaceContainerHighest, "Calories eaten"),
                        const SizedBox(width: 12),
                        _buildLegendItem(context, primary.withOpacity(0.6), "Calories burned"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBigStat(BuildContext context, String val, String lbl, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: DmCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(val, style: theme.textTheme.displayMedium?.copyWith(fontSize: 28, color: color)),
            Text(lbl.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(fontSize: 8, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustRow(BuildContext context, String lbl, String val, {bool isLast = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: theme.colorScheme.primary.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(lbl, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(val, style: theme.textTheme.labelLarge?.copyWith(fontSize: 11, color: theme.colorScheme.primary)),
        ],
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, String day, double eatenH, double burnedH, {bool isCoral = false, bool isToday = false}) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final color = isCoral ? const Color(0xFFFF5C3A) : primary;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (eatenH > 0)
                Container(
                  height: eatenH,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                ),
              Container(
                height: burnedH,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(color: color.withOpacity(0.4), borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
              ),
              if (isToday)
                Container(
                  height: burnedH,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(color: primary, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(day, style: theme.textTheme.labelSmall?.copyWith(fontSize: 8, color: isToday ? primary : null, fontWeight: isToday ? FontWeight.w700 : null)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String lbl) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(lbl, style: theme.textTheme.bodySmall?.copyWith(fontSize: 8)),
      ],
    );
  }
}
