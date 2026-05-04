import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import '../domain/models/achievement.dart';
import '../data/achievement_repository.dart';

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository(Supabase.instance.client);
});

final achievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];

  final repository = ref.watch(achievementRepositoryProvider);
  final result = await repository.getAll(authState.user.id);

  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final recentAchievementsProvider = FutureProvider.autoDispose
    .family<List<Achievement>, int>((ref, limit) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];

  final repository = ref.watch(achievementRepositoryProvider);
  final result = await repository.getRecent(authState.user.id, limit);

  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final achievementActionsProvider =
    StateNotifierProvider<AchievementActionsNotifier, AsyncValue<void>>((ref) {
  return AchievementActionsNotifier(
      ref.watch(achievementRepositoryProvider), ref);
});

class AchievementActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final AchievementRepository _repository;
  final Ref _ref;

  AchievementActionsNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> awardAchievement({
    required String type,
    required String title,
    required String description,
    required int streakCount,
    required String badgeImagePath,
  }) async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;

    // First check if already has it
    final existsResult =
        await _repository.hasAchievement(authState.user.id, type);
    final exists = existsResult.getOrElse(() => false);
    if (exists) return;

    state = const AsyncValue.loading();
    final result = await _repository.award(
      userId: authState.user.id,
      type: type,
      title: title,
      description: description,
      streakCount: streakCount,
      badgeImagePath: badgeImagePath,
    );
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(achievementsProvider);
        _ref.invalidate(recentAchievementsProvider);
      },
    );
  }
}
