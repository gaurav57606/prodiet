import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/achievements/application/achievement_providers.dart';
import 'package:prodiet_unified/features/achievements/domain/models/achievement.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: achievementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text('No achievements yet',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Keep logging meals and hitting your goals!',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center),
                  ]),
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

  String _emoji(String type) {
    switch (type) {
      case 'streak_7':
        return '🔥';
      case 'streak_30':
        return '⚡';
      case 'protein_goal':
        return '💪';
      case 'hydration':
        return '💧';
      case 'weight_loss':
        return '⚖️';
      default:
        return '🏆';
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle),
            child: Center(
                child:
                    Text(_emoji(a.type), style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(a.title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(a.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.5))),
              if (a.streakCount > 0)
                Text('${a.streakCount} day streak 🔥',
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w700)),
            ],
          )),
          Text(
              a.earnedAt.length >= 10
                  ? a.earnedAt.substring(0, 10)
                  : a.earnedAt,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurface.withValues(alpha: 0.35))),
        ]),
      ),
    );
  }
}
