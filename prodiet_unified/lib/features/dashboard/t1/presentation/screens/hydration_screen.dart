import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_colors.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/water/application/water_providers.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import 'package:prodiet_unified/features/water/domain/water_log.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/loading_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class HydrationScreen extends ConsumerWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(waterSummaryProvider);
    final logsAsync = ref.watch(todayWaterLogsProvider);
    final userId = ref.watch(currentUserIdProvider);

    const statusColor = T1ColorSchemes.accentTeal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            onPressed: () =>
                ref.read(waterRepositoryProvider).deleteLastLog(userId),
          ),
        ],
      ),
      body: AsyncValueWidget<WaterSummary>(
        value: summaryAsync,
        skeleton: const ProDietLoader(),
        isEmpty: (s) => s.totalMl == 0,
        emptyState: ProDietEmptyState(
          icon: EmptyStateConfigs.water.icon,
          headline: EmptyStateConfigs.water.headline,
          subtext: EmptyStateConfigs.water.subtext,
          buttonLabel: EmptyStateConfigs.water.buttonLabel,
          onButtonTap: () => _logGlass(ref, context),
        ),
        builder: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(T1Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(theme, statusColor, summary.totalMl, summary.targetMl,
                  summary.percentFilled),
              const SizedBox(height: T1Spacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'QUICK ADD',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    '${summary.glasses} / ${summary.targetGlasses} Glasses',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: T1Spacing.md),
              _buildQuickAddGrid(theme, statusColor, ref, userId),
              const SizedBox(height: T1Spacing.xl),
              Text(
                'TODAY\'S HISTORY',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              logsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error loading history: $err'),
                data: (logs) => _buildHistoryList(theme, statusColor, logs),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(
      ThemeData theme, Color color, int consumed, int target, double progress) {
    final formatter = NumberFormat('#,###');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatter.format(consumed),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: color,
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ml',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: color.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Text(
            'OF ${formatter.format(target)} ML TARGET',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.6),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          if (progress >= 1.0) ...[
            const SizedBox(height: 16),
            Text(
              '🎉 Goal reached!',
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickAddGrid(
      ThemeData theme, Color color, WidgetRef ref, String userId) {
    final amounts = [
      {'val': 250, 'icon': Icons.local_drink_rounded},
      {'val': 500, 'icon': Icons.water_drop_rounded},
      {'val': 750, 'icon': Icons.wine_bar_rounded},
      {'val': 1000, 'icon': Icons.coffee_rounded},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: amounts.map((a) {
        final val = a['val'] as int;
        return InkWell(
          onTap: () =>
              ref.read(waterRepositoryProvider).logCustomAmount(userId, val),
          borderRadius: BorderRadius.circular(24),
          child: DmCard(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(a['icon'] as IconData, color: color, size: 20),
                const SizedBox(width: 12),
                Text(
                  '$val ml',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryList(ThemeData theme, Color color, List<WaterLog> logs) {
    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: T1Spacing.xl),
          child: Text('No history for today',
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final log = logs[index];
        final timeStr = DateFormat('hh:mm a').format(log.loggedAt);
        return DmCard(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.02),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history_rounded,
                      size: 16,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                  const SizedBox(width: 12),
                  Text(
                    timeStr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                '${log.amountMl} ml',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _logGlass(WidgetRef ref, BuildContext context) {
    final userId = ref.read(currentUserIdProvider);
    ref.read(waterRepositoryProvider).logGlass(userId);
  }
}
