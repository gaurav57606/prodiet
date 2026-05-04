import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import '../domain/models/shopping_item.dart';
import '../data/shopping_repository.dart';

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepository(Supabase.instance.client);
});

final shoppingListProvider =
    FutureProvider.autoDispose<List<ShoppingItem>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];

  final repository = ref.watch(shoppingRepositoryProvider);
  final result = await repository.getList(authState.user.id);

  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final unpurchasedItemsProvider =
    FutureProvider.autoDispose<List<ShoppingItem>>((ref) async {
  final items = await ref.watch(shoppingListProvider.future);
  return items.where((i) => !i.isPurchased).toList();
});

final shoppingActionsProvider =
    StateNotifierProvider<ShoppingActionsNotifier, AsyncValue<void>>((ref) {
  return ShoppingActionsNotifier(ref.watch(shoppingRepositoryProvider), ref);
});

class ShoppingActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ShoppingRepository _repository;
  final Ref _ref;

  ShoppingActionsNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> addItem(ShoppingItem item) async {
    state = const AsyncValue.loading();
    final result = await _repository.addItem(item);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(shoppingListProvider);
      },
    );
  }

  Future<void> markPurchased(String itemId, bool isPurchased) async {
    state = const AsyncValue.loading();
    final result = await _repository.markPurchased(itemId, isPurchased);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(shoppingListProvider);
      },
    );
  }

  Future<void> deleteItem(String itemId) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteItem(itemId);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(shoppingListProvider);
      },
    );
  }

  Future<void> clearPurchased() async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;

    state = const AsyncValue.loading();
    final result = await _repository.clearPurchased(authState.user.id);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(shoppingListProvider);
      },
    );
  }

  Future<void> generateFromLowStock() async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;

    state = const AsyncValue.loading();
    final result = await _repository.generateFromLowStock(authState.user.id);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(shoppingListProvider);
      },
    );
  }
}
