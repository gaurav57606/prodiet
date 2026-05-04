import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import '../data/diet_plan_repository.dart';
import '../domain/diet_plan_state.dart';

final dietPlanRepositoryProvider = Provider<DietPlanRepository>((ref) {
  return DietPlanRepository(ref.watch(supabaseClientProvider));
});

final dietPlanProvider = StateNotifierProvider<DietPlanNotifier, DietPlanState>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return DietPlanNotifier(ref.watch(dietPlanRepositoryProvider), userId);
});

class DietPlanNotifier extends StateNotifier<DietPlanState> {
  final DietPlanRepository _repo;
  final String _userId;

  DietPlanNotifier(this._repo, this._userId) : super(const DietPlanInitial()) {
    _loadActivePlan();
  }

  Future<void> _loadActivePlan() async {
    if (_userId.isEmpty) return;
    state = const DietPlanLoading();
    try {
      final plan = await _repo.getActivePlan(_userId);
      state = plan != null ? DietPlanLoaded(plan) : const DietPlanInitial();
    } catch (e) {
      state = DietPlanError(e.toString());
    }
  }

  Future<void> generate() async {
    if (_userId.isEmpty) return;
    state = const DietPlanLoading();
    try {
      final plan = await _repo.generatePlan(_userId);
      state = DietPlanLoaded(plan);
    } catch (e) {
      state = DietPlanError(e.toString());
    }
  }

  Future<void> saveTodayMeals() async {
    final s = state;
    if (s is! DietPlanLoaded) return;
    await _repo.savePlanMealsToToday(_userId, s.plan);
  }
}

final isGeneratingDietPlanProvider = Provider<bool>((ref) {
  return ref.watch(dietPlanProvider) is DietPlanLoading;
});
