import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/diet_plan/data/diet_plan_repository.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';

final dietPlanRepositoryProvider = Provider<DietPlanRepository>((ref) {
  return DietPlanRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(mealRepositoryProvider),
  );
});

final dietPlanProvider = AsyncNotifierProvider.autoDispose<DietPlanNotifier, DietPlan?>(() {
  return DietPlanNotifier();
});

class DietPlanNotifier extends AutoDisposeAsyncNotifier<DietPlan?> {
  @override
  Future<DietPlan?> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId.isEmpty) return null;
    
    return ref.read(dietPlanRepositoryProvider).getCachedPlan(userId);
  }

  Future<void> generate() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => 
      ref.read(dietPlanRepositoryProvider).generatePlan(userId)
    );
  }
}

final isGeneratingDietPlanProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(dietPlanProvider).isLoading;
});
