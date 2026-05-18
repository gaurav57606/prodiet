import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/progress/application/progress_providers.dart';
import 'package:prodiet_unified/features/progress/presentation/widgets/adaptive_progress_widgets.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final summaryAsync = ref.watch(progressSummaryProvider);

    return Scaffold(
      backgroundColor: tokens.colors.background,
      appBar: AppBar(
        title: Text(isT2 ? 'PERFORMANCE' : 'Progress'),
        titleTextStyle: isT2 ? tokens.typography.titleLarge.copyWith(fontWeight: FontWeight.w900) : null,
        centerTitle: isT2,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(child: Text('Error loading progress')),
        data: (summary) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isT2) ...[
                      Text(
                        'BODY STATS',
                        style: tokens.typography.displayLarge.copyWith(
                          color: tokens.colors.primary,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tracking your journey to peak health',
                        style: tokens.typography.bodyMedium.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.6)),
                      ),
                      const SizedBox(height: 32),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: AdaptiveMetricCard(
                            label: 'CURRENT WEIGHT',
                            value: summary.currentWeightKg.toString(),
                            unit: 'KG',
                            color: tokens.colors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AdaptiveMetricCard(
                            label: 'WEIGHT CHANGE',
                            value: summary.totalChange > 0 ? '+${summary.totalChange}' : summary.totalChange.toString(),
                            unit: 'KG',
                            color: summary.totalChange <= 0 ? const Color(0xFF40D8B8) : const Color(0xFFFF5252),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AdaptiveStreakBadge(days: summary.streakDays),
                    const SizedBox(height: 32),
                    Text(
                      'WEIGHT HISTORY',
                      style: tokens.typography.labelLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: tokens.colors.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: _buildHistoryListSliver(context, summary),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryListSliver(BuildContext context, dynamic summary) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return SliverList.separated(
      itemCount: summary.recentLogs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final log = summary.recentLogs[index];
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isT2 ? log.dateLabel.toUpperCase() : log.dateLabel,
                    style: (isT2 ? tokens.typography.labelLarge : tokens.typography.bodyMedium).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isT2)
                    Text(
                      'LOGGED ENTRY',
                      style: tokens.typography.labelSmall.copyWith(
                        fontSize: 10,
                        color: tokens.colors.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                ],
              ),
              Text(
                '${log.weight} ${isT2 ? 'KG' : 'kg'}',
                style: (isT2 ? tokens.typography.titleLarge : tokens.typography.titleMedium).copyWith(
                  fontWeight: FontWeight.w900,
                  color: tokens.colors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

