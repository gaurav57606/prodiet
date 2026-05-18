import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/compensation/application/compensation_providers.dart';
import 'package:prodiet_unified/features/compensation/presentation/widgets/adaptive_compensation_widgets.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';

class CompensationScreen extends ConsumerWidget {
  const CompensationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final user = ref.watch(currentUserProvider);
    
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please login")));
    }

    final historyAsync = ref.watch(compensationHistoryProvider(user.id));

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'COMPENSATION' : 'Plan Adjustments'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: ProDietEmptyState(
                icon: Icons.check_circle_outline_rounded,
                headline: 'Everything on Track',
                subtext: 'No compensation plans needed yet.',
              ),
            );
          }

          final log = logs.first;
          final adjustments = log.planAdjustments;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isT2) ...[
                  Text(
                    'ADJUST',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFF5C3A),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You missed a meal — here is the fix',
                    style: GoogleFonts.barlowCondensed(
                      color: tokens.colors.onSurface.withValues(alpha: 0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                AdaptiveMissedMealCard(
                  title: log.reason,
                  subtitle: 'Logged on ${log.createdAt.toString().split('.')[0]}',
                ),
                const SizedBox(height: 32),

                _buildSectionLabel(context, 'AI RECALCULATION'),
                const SizedBox(height: 16),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: tokens.colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tokens.colors.primary.withValues(alpha: 0.05),
                          border: Border(left: BorderSide(color: tokens.colors.primary, width: 4)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 16, color: tokens.colors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isT2 ? 'AUTO-ADJUSTMENT PLAN' : 'Smart Adjustment Active',
                                style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelSmall).copyWith(
                                  color: tokens.colors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...adjustments.entries.map((entry) => AdaptiveAdjustmentTile(
                        title: entry.key,
                        subtitle: 'Update required',
                        delta: entry.value,
                        isLast: entry.key == adjustments.keys.last,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: FilledButton(
                          onPressed: () async {
                            final scaffold = ScaffoldMessenger.of(context);
                            await ref.read(compensationRepositoryProvider).applyCompensation(log.id);
                            scaffold.showSnackBar(
                              const SnackBar(content: Text('Compensation plan applied!')),
                            );
                            if (context.mounted) Navigator.pop(context);
                          },
                          style: isT2 ? FilledButton.styleFrom(
                            backgroundColor: tokens.colors.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ) : null,
                          child: Text(
                            isT2 ? 'ACCEPT ADJUSTMENT' : 'Accept Plan',
                            style: isT2 ? GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900, fontSize: 16) : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => _showCustomiseSheet(context, ref, log.id),
                          style: isT2 ? OutlinedButton.styleFrom(
                            side: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.2)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ) : null,
                          child: Text(
                            isT2 ? 'CUSTOMISE' : 'Modify',
                            style: isT2 ? GoogleFonts.barlowCondensed(
                              fontWeight: FontWeight.w900, 
                              fontSize: 16,
                              color: tokens.colors.onSurface
                            ) : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String title) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Text(
      title,
      style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelSmall).copyWith(
        color: tokens.colors.onSurface.withValues(alpha: 0.3),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  void _showCustomiseSheet(BuildContext context, WidgetRef ref, String logId) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    showModalBottomSheet(
      context: context,
      backgroundColor: tokens.colors.surfaceContainerLowest,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(32, 32, 32, MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isT2 ? 'CUSTOMISE PLAN' : 'Modify Adjustment',
              style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 24) : tokens.typography.headlineSmall).copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Modify the AI adjustments before applying.',
              style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.5), fontSize: 13),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () async {
                  await ref.read(compensationRepositoryProvider).applyCompensation(logId);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Custom adjustments applied!')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: isT2 ? FilledButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ) : null,
                child: Text(
                  isT2 ? 'APPLY CHANGES' : 'Save Changes',
                  style: isT2 ? GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900, fontSize: 18) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
