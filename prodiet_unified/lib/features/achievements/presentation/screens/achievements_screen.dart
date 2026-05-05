import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/achievements/application/achievement_providers.dart';
import 'package:prodiet_unified/features/achievements/domain/models/achievement.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_empty_state.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: achievementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: DmEmptyState(
                title: 'No achievements yet',
                message: 'Keep logging meals and hitting your goals to earn badges!',
                icon: Icons.emoji_events_rounded,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _AchievementTile(a: list[i]),
          );
        },
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement a;
  const _AchievementTile({required this.a});

  IconData _icon(String type) {
    switch (type) {
      case 'streak_7':     return Icons.local_fire_department_rounded;
      case 'streak_30':    return Icons.bolt_rounded;
      case 'protein_goal': return Icons.fitness_center_rounded;
      case 'hydration':    return Icons.water_drop_rounded;
      case 'weight_loss':  return Icons.monitor_weight_rounded;
      default:             return Icons.emoji_events_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle),
            child: Center(child: Icon(_icon(a.type), size: 24, color: scheme.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(a.title, style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(a.description, style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.5))),
              if (a.streakCount > 0)
                Row(
                  children: [
                    Text('${a.streakCount} day streak ',
                      style: const TextStyle(fontSize: 10,
                        color: Colors.orangeAccent, fontWeight: FontWeight.w700)),
                    const Icon(Icons.local_fire_department_rounded, size: 10, color: Colors.orangeAccent),
                  ],
                ),
            ],
          )),
          Text(a.earnedAt.length >= 10 ? a.earnedAt.substring(0, 10) : a.earnedAt,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.35))),
        ]),
      ),
    );
  }
}
