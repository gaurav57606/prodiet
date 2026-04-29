import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/water/application/water_providers.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/loading_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

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
    final summaryAsync = ref.watch(waterSummaryProvider);
    final userId = ref.watch(currentUserIdProvider);
    final formatter = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo_rounded, color: Colors.white),
            onPressed: () => ref.read(waterRepositoryProvider).deleteLastLog(userId),
          ),
        ],
      ),
      body: AsyncValueWidget<WaterSummary>(
        value: summaryAsync,
        skeleton: const ProDietLoader(),
        isEmpty: (s) => s.totalMl == 0,
        emptyState: ProDietEmptyState(
          emoji: EmptyStateConfigs.water.emoji,
          headline: EmptyStateConfigs.water.headline,
          subtext: EmptyStateConfigs.water.subtext,
          buttonLabel: EmptyStateConfigs.water.buttonLabel,
          onButtonTap: () => ref.read(waterRepositoryProvider).logGlass(userId),
        ),
        builder: (summary) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WATER',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: T2Colors.sky,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: formatter.format(summary.totalMl),
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' ml / ${formatter.format(summary.targetMl)} ml',
                            style: const TextStyle(
                              fontSize: 16,
                              color: T2Colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(summary.targetGlasses - summary.glasses).clamp(0, 99)} glasses left today',
                      style: const TextStyle(
                        color: T2Colors.sky,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Glass log row
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: summary.targetGlasses.clamp(1, 20),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isFilled = index < summary.glasses;
                    return _buildGlassIcon(isFilled);
                  },
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'QUICK ADD',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    color: T2Colors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.8,
                  children: [
                    _buildAddButton(ref, userId, '250ml', 250),
                    _buildAddButton(ref, userId, '500ml', 500),
                    _buildAddButton(ref, userId, '750ml', 750),
                    _buildAddButton(ref, userId, '1L', 1000),
                    _buildAddButton(ref, userId, '1.5L', 1500),
                    _buildAddButton(ref, userId, '2L', 2000),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: T2Colors.bgElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: T2Colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CUSTOM ENTRY',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.2,
                          color: T2Colors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customController,
                              decoration: InputDecoration(
                                hintText: 'Enter amount',
                                hintStyle: const TextStyle(color: T2Colors.textMuted),
                                filled: true,
                                fillColor: T2Colors.bgDeep,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
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
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: T2Colors.sky,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassIcon(bool isFilled) {
    return Container(
      width: 45,
      decoration: BoxDecoration(
        color: isFilled ? T2Colors.sky.withOpacity(0.2) : T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFilled ? T2Colors.sky : T2Colors.border,
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_drink_rounded,
          color: isFilled ? T2Colors.sky : T2Colors.textMuted,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAddButton(WidgetRef ref, String userId, String label, int amount) {
    return GestureDetector(
      onTap: () => ref.read(waterRepositoryProvider).logCustomAmount(userId, amount),
      child: Container(
        decoration: BoxDecoration(
          color: T2Colors.bgElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: T2Colors.border),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
