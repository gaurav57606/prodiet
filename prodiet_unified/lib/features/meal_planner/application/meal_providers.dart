import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import '../domain/models/meal_models.dart';
import '../data/meal_repository.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(analyticsServiceProvider),
  );
});

final todayMealsProvider = FutureProvider.autoDispose.family<List<Meal>, String>((ref, date) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(mealRepositoryProvider);
  final result = await repository.getTodayMeals(authState.user.id, date);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final mealLogsProvider = FutureProvider.autoDispose.family<List<MealLog>, String>((ref, date) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(mealRepositoryProvider);
  final result = await repository.getMealLogs(authState.user.id, date);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final mealActionsProvider = StateNotifierProvider<MealActionsNotifier, AsyncValue<void>>((ref) {
  return MealActionsNotifier(ref.watch(mealRepositoryProvider), ref);
});

class MealActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final MealRepository _repository;
  final Ref _ref;

  MealActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> addMeal(Meal meal) async {
    state = const AsyncValue.loading();
    final result = await _repository.addMeal(meal);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(todayMealsProvider(meal.date));
      },
    );
  }

  Future<void> deleteMeal(String mealId, String date) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteMeal(mealId);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(todayMealsProvider(date));
      },
    );
  }

  Future<void> updateMealStatus(String mealId, String status, String date) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateMealStatus(mealId, status);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(todayMealsProvider(date));
      },
    );
  }

  Future<void> logMeal({
    required String mealId,
    required String userId,
    required int actualCalories,
    required String date,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.logMeal(
      mealId: mealId,
      userId: userId,
      actualCalories: actualCalories,
      notes: notes,
    );
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(todayMealsProvider(date));
        _ref.invalidate(mealLogsProvider(date));
      },
    );
  }
}
