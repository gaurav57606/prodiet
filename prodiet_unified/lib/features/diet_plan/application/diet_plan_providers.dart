import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import '../domain/models/diet_plan.dart';
import '../data/diet_plan_repository.dart';

final dietPlanRepositoryProvider = Provider<DietPlanRepository>((ref) {
  return DietPlanRepository(Supabase.instance.client);
});

final activeDietPlanProvider = FutureProvider.autoDispose<DietPlan?>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return null;
  
  final repository = ref.watch(dietPlanRepositoryProvider);
  final result = await repository.getActivePlan(authState.user.id);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final allDietPlansProvider = FutureProvider.autoDispose<List<DietPlan>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(dietPlanRepositoryProvider);
  final result = await repository.getAllPlans(authState.user.id);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final dietPlanActionsProvider = StateNotifierProvider<DietPlanActionsNotifier, AsyncValue<void>>((ref) {
  return DietPlanActionsNotifier(ref.watch(dietPlanRepositoryProvider), ref);
});

class DietPlanActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final DietPlanRepository _repository;
  final Ref _ref;

  DietPlanActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> createPlan(DietPlan plan) async {
    state = const AsyncValue.loading();
    final result = await _repository.createPlan(plan);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(allDietPlansProvider);
        _ref.invalidate(activeDietPlanProvider);
      },
    );
  }

  Future<void> updatePlan(DietPlan plan) async {
    state = const AsyncValue.loading();
    final result = await _repository.updatePlan(plan);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(allDietPlansProvider);
        _ref.invalidate(activeDietPlanProvider);
      },
    );
  }

  Future<void> deletePlan(String planId) async {
    state = const AsyncValue.loading();
    final result = await _repository.deletePlan(planId);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(allDietPlansProvider);
        _ref.invalidate(activeDietPlanProvider);
      },
    );
  }
}
