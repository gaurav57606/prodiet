import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/cache/cache_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import '../data/nutrition_repository.dart';
import '../domain/daily_macro_summary.dart';
import '../domain/top_food_item.dart';

final nutritionRepositoryProvider = Provider((ref) =>
    NutritionRepository(
      ref.watch(supabaseClientProvider),
      ref.watch(semanticCacheProvider),
    ));

final weeklyMacrosProvider = FutureProvider.autoDispose<List<DailyMacroSummary>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return [];
  return ref.read(nutritionRepositoryProvider).getWeeklyMacros(userId);
});

final topProteinSourcesProvider = FutureProvider.autoDispose<List<TopFoodItem>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return [];
  return ref.read(nutritionRepositoryProvider).getTopProteinSources(userId);
});
