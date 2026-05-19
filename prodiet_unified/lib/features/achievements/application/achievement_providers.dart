import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import '../domain/models/achievement.dart';
import '../data/achievement_repository.dart';

final streakAchievementProvider = FutureProvider.autoDispose<void>((ref) async {
  final dashboardAsync = ref.watch(dashboardProvider);
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return;

  final dashboardData = dashboardAsync.asData?.value;
  if (dashboardData == null) return;

  final streak = dashboardData.streakDays;
  final milestones = [3, 7, 14, 30];

  if (streak > 0 && milestones.contains(streak)) {
    final supabase = ref.watch(supabaseClientProvider);
    await supabase.from('achievements').upsert({
      'user_id': userId,
      'title': '$streak Day Streak 🔥',
      'description': 'Logged meals for $streak days in a row!',
      'type': 'streak',
      'milestone': streak,
      'earned_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id,type,milestone');
    
    // Invalidate achievements so they refresh
    ref.invalidate(achievementsProvider);
    ref.invalidate(recentAchievementsProvider(5)); // Assuming default limit is 5 in UI
  }
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository(ref.watch(supabaseClientProvider));
});


final achievementsProvider = FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(achievementRepositoryProvider);
  final result = await repository.getAll(authState.user.id);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final recentAchievementsProvider = FutureProvider.autoDispose.family<List<Achievement>, int>((ref, limit) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(achievementRepositoryProvider);
  final result = await repository.getRecent(authState.user.id, limit);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final achievementActionsProvider = StateNotifierProvider<AchievementActionsNotifier, AsyncValue<void>>((ref) {
  return AchievementActionsNotifier(ref.watch(achievementRepositoryProvider), ref);
});

class AchievementActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final AchievementRepository _repository;
  final Ref _ref;

  AchievementActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

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
    final existsResult = await _repository.hasAchievement(authState.user.id, type);
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
