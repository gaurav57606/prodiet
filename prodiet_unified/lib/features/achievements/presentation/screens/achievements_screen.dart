import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/achievements/application/achievement_providers.dart';
import 'package:prodiet_unified/features/achievements/presentation/widgets/adaptive_achievement_widgets.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'HALL OF FAME' : 'Achievements'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: achievementsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: tokens.colors.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const ProDietEmptyState(
              headline: 'No achievements yet',
              subtext: 'Keep logging meals and hitting your goals to earn badges!',
              icon: Icons.emoji_events_rounded,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) => AdaptiveAchievementTile(achievement: list[i]),
          );
        },
      ),
    );
  }
}
