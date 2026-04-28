import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/cache/cache_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import '../data/nutrition_repository.dart';
import '../domain/models/nutrition_item.dart';

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return NutritionRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(semanticCacheProvider),
  );
});

final nutritionSearchProvider =
    FutureProvider.family.autoDispose<List<NutritionItem>, String>((ref, query) async {
  if (query.trim().length < 2) return [];
  
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];

  final result = await ref.watch(nutritionRepositoryProvider).searchByName(userId, query);
  return result.fold((e) => [], (items) => items);
});

final barcodeLookupProvider =
    FutureProvider.family.autoDispose<NutritionItem?, String>((ref, barcode) async {
  final result = await ref.watch(nutritionRepositoryProvider).lookupByBarcode(barcode);
  return result.fold((e) => null, (item) => item);
});
