import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/fitband/application/fitband_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/features/progress/application/progress_providers.dart';
import 'package:prodiet_unified/features/progress/presentation/widgets/adaptive_activity_widgets.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:google_fonts/google_fonts.dart';


class ActivitySyncScreen extends ConsumerStatefulWidget {
  const ActivitySyncScreen({super.key});

  @override
  ConsumerState<ActivitySyncScreen> createState() => _ActivitySyncScreenState();
}

class _ActivitySyncScreenState extends ConsumerState<ActivitySyncScreen> {
  @override
  void initState() {
    super.initState();
    final activeTheme = ref.read(activeThemeProvider);
    final isT2 = activeTheme == ActiveTheme.t2Light || 
                 activeTheme == ActiveTheme.t2Dark || 
                 activeTheme == ActiveTheme.t2Amoled;
    if (isT2) {
      Future.microtask(() => ref.read(fitbandProvider.notifier).init());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    
    // Platform guard for BLE/Sensors simulation (relevant for T2 fitband logic)
    final isFitSupported = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'ACTIVITY' : 'Activity Sync'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isT2 ? _buildT2Layout(context, isFitSupported) : _buildT1Layout(context),
    );
  }

  Widget _buildT1Layout(BuildContext context) {
    final tokens = context.tokens;
    final summaryAsync = ref.watch(dashboardProvider.select((v) => v.whenData((s) => (
      stepsToday: s.stepsToday,
      caloriesBurned: s.caloriesBurned,
    ))));

    return AsyncValueWidget(
      value: summaryAsync,
      builder: (summary) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AdaptiveDeviceConnectionCard(
                    deviceName: 'Google Fit',
                    status: 'Connected and syncing calories',
                    isActive: true,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AdaptiveActivityStatTile(
                          label: 'Steps',
                          value: summary.stepsToday.toString(),
                          icon: Icons.directions_walk,
                          color: const Color(0xFF9181F4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AdaptiveActivityStatTile(
                          label: 'Burned',
                          value: summary.caloriesBurned.toString(),
                          icon: Icons.local_fire_department,
                          color: const Color(0xFFFF529B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: AdaptiveActivityStatTile(
                          label: 'Active',
                          value: '0m',
                          icon: Icons.timer,
                          color: Color(0xFF40D8B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'WEEK ACTIVITY',
                    style: tokens.typography.labelLarge.copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.25),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildT1ActivityChart(context, summary),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildT2Layout(BuildContext context, bool isFitSupported) {
    if (!isFitSupported) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.watch_off_rounded, color: Colors.grey, size: 64),
            const SizedBox(height: 24),
            Text(
              'DEVICE NOT SUPPORTED',
              style: GoogleFonts.barlowCondensed(
                color: context.tokens.colors.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Fitband integration requires a physical mobile device with BLE support.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    final fitState = ref.watch(fitbandProvider);
    final tokens = context.tokens;

    if (fitState.isLoading) {
      return Center(child: CircularProgressIndicator(color: tokens.colors.primary));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(fitbandProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LIVE STATS',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: tokens.colors.primary,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AdaptiveDeviceConnectionCard(
                    deviceName: 'Fitband Pro 2',
                    status: fitState.hasPermission ? 'HEALTH SYNC ACTIVE' : 'NO HEALTH ACCESS',
                    isActive: fitState.hasPermission,
                  ),
                  const SizedBox(height: 24),
                  // Heart Rate
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: tokens.colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: tokens.colors.onSurface.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HEART RATE',
                              style: GoogleFonts.barlowCondensed(
                                fontSize: 12,
                                letterSpacing: 1.2,
                                color: tokens.colors.onSurface.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  fitState.heartRate?.toString() ?? '--',
                                  style: GoogleFonts.barlowCondensed(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF9181F4),
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'bpm',
                                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Mini graph placeholder
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(10, (index) => Container(
                              width: 4,
                              height: (20 + (index % 3) * 10).toDouble(),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9181F4).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AdaptiveActivityStatTile(
                          label: 'Steps',
                          value: fitState.steps.toString(),
                          icon: Icons.directions_walk,
                          color: tokens.colors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AdaptiveActivityStatTile(
                          label: 'Calories',
                          value: fitState.calories.toStringAsFixed(0),
                          icon: Icons.local_fire_department,
                          color: const Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'RECENT SESSIONS',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 16,
                      letterSpacing: 1.5,
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _buildT2RecentSessions(context),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }


  Widget _buildT1ActivityChart(BuildContext context, dynamic summary) {
    final tokens = context.tokens;
    // For T1, we'll show a simple 7-day calorie burn trend
    // In a real app, this would come from a specific weeklyActivityProvider
    // Using dummy data points for now that look real, but ideally hooked to summary.weeklyData
    final spots = [
      const FlSpot(0, 1800),
      const FlSpot(1, 2100),
      const FlSpot(2, 1950),
      const FlSpot(3, 2400),
      const FlSpot(4, 2200),
      const FlSpot(5, 2550),
      const FlSpot(6, 2300),
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: tokens.colors.onSurface.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(days[value.toInt()], style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontSize: 10, fontWeight: FontWeight.w900));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: tokens.colors.primary,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: tokens.colors.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildT2RecentSessions(BuildContext context) {
    final tokens = context.tokens;
    final historyAsync = ref.watch(activityHistoryProvider);

    return AsyncValueWidget(
      value: historyAsync,
      isEmpty: (data) => data.isEmpty,
      emptyState: const SliverToBoxAdapter(child: Center(child: Text('No recent sessions found.'))),
      builder: (data) => SliverList.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => Divider(color: tokens.colors.onSurface.withValues(alpha: 0.1), height: 1),
        itemBuilder: (context, index) {
          final log = data[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(log.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(
              DateFormat('MMM dd · hh:mm a').format(log.date), 
              style: const TextStyle(color: Colors.grey, fontSize: 12)
            ),
            trailing: Text(
              '${log.caloriesBurned} kcal',
              style: GoogleFonts.barlowCondensed(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: tokens.colors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
