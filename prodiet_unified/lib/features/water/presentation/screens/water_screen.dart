import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/water/application/water_providers.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import 'package:prodiet_unified/features/water/presentation/widgets/adaptive_water_widgets.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/loading_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/core/theme/font_config.dart';

class WaterScreen extends ConsumerStatefulWidget {
  const WaterScreen({super.key});

  @override
  ConsumerState<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends ConsumerState<WaterScreen> {
  final TextEditingController _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final summaryAsync = ref.watch(waterSummaryProvider);
    final logsAsync = ref.watch(todayWaterLogsProvider);
    final userId = ref.watch(currentUserIdProvider);
    
    final accentColor = isT2 ? const Color(0xFF00E5FF) : const Color(0xFF00CED1);

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'HYDRATION' : 'Hydration Details'),
        titleTextStyle: isT2 ? AppFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            onPressed: () => ref.read(waterRepositoryProvider).deleteLastLog(userId),
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
          onButtonTap: () => ref.read(waterRepositoryProvider).logGlass(userId),
        ),
        builder: (summary) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  AdaptiveWaterHero(
                    consumed: summary.totalMl,
                    target: summary.targetMl,
                    progress: summary.percentFilled,
                  ),
                  const SizedBox(height: 32),
                  
                  if (isT2) ...[
                    _buildGlassRow(context, summary),
                    const SizedBox(height: 32),
                  ],

                  _buildSectionLabel(context, 'QUICK ADD'),
                  const SizedBox(height: 16),
                  AdaptiveWaterQuickAdd(
                    onAdd: (val) => ref.read(waterRepositoryProvider).logCustomAmount(userId, val),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionLabel(context, 'CUSTOM ENTRY'),
                  const SizedBox(height: 16),
                  _buildCustomEntry(context, userId),
                  const SizedBox(height: 32),

                  _buildSectionLabel(context, 'TODAY\'S HISTORY'),
                  const SizedBox(height: 16),
                ]),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: logsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Text('Error loading history: $err'),
                ),
                data: (logs) {
                  if (logs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No history for today',
                            style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.3)),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final timeStr = DateFormat('hh:mm a').format(log.loggedAt);
                      return Padding(
                        padding: EdgeInsets.only(bottom: index == logs.length - 1 ? 0 : 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: isT2 ? BoxDecoration(
                            color: tokens.colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: tokens.colors.onSurface.withValues(alpha: 0.05)),
                          ) : BoxDecoration(
                            color: tokens.colors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.history_rounded, size: 16, color: tokens.colors.onSurface.withValues(alpha: 0.2)),
                                  const SizedBox(width: 12),
                                  Text(
                                    isT2 ? timeStr.toUpperCase() : timeStr,
                                    style: (isT2 ? AppFonts.barlowCondensed(fontSize: 14) : tokens.typography.bodyMedium).copyWith(
                                      color: tokens.colors.onSurface.withValues(alpha: 0.5),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${log.amountMl} ml',
                                style: (isT2 ? AppFonts.barlowCondensed(fontSize: 18) : tokens.typography.bodyMedium).copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String title) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Text(
      title,
      style: (isT2 ? AppFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelSmall).copyWith(
        color: tokens.colors.onSurface.withValues(alpha: 0.3),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildGlassRow(BuildContext context, WaterSummary summary) {
    final tokens = context.tokens;
    const color = Color(0xFF00E5FF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${(summary.targetGlasses - summary.glasses).clamp(0, 99)} glasses left today'.toUpperCase(),
          style: AppFonts.barlowCondensed(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: summary.targetGlasses.clamp(1, 20),
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isFilled = index < summary.glasses;
              return Container(
                width: 40,
                decoration: BoxDecoration(
                  color: isFilled ? color.withValues(alpha: 0.2) : tokens.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isFilled ? color : tokens.colors.onSurface.withValues(alpha: 0.1),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_drink_rounded,
                    color: isFilled ? color : tokens.colors.onSurface.withValues(alpha: 0.2),
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomEntry(BuildContext context, String userId) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: isT2 ? BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.onSurface.withValues(alpha: 0.05)),
      ) : BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _customController,
              style: isT2 ? AppFonts.barlowCondensed() : null,
              decoration: InputDecoration(
                hintText: 'Enter amount (ml)',
                hintStyle: isT2 ? AppFonts.barlowCondensed(color: tokens.colors.onSurface.withValues(alpha: 0.3)) : null,
                filled: true,
                fillColor: tokens.colors.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              final amount = int.tryParse(_customController.text);
              if (amount != null && amount > 0) {
                ref.read(waterRepositoryProvider).logCustomAmount(userId, amount);
                _customController.clear();
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: tokens.colors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'ADD',
                style: AppFonts.barlowCondensed(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
