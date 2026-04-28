import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import '../domain/models/inventory_item.dart';
import '../data/inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(Supabase.instance.client);
});

final inventoryProvider = FutureProvider.autoDispose<List<InventoryItem>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) return [];
  
  final repository = ref.watch(inventoryRepositoryProvider);
  final result = await repository.getAll(authState.user.id);
  
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

final lowStockProvider = FutureProvider.autoDispose<List<InventoryItem>>((ref) async {
  final items = await ref.watch(inventoryProvider.future);
  return items.where((i) => i.isLowStock).toList();
});

final expiringItemsProvider = FutureProvider.autoDispose.family<List<InventoryItem>, int>((ref, days) async {
  final items = await ref.watch(inventoryProvider.future);
  return items.where((i) => i.daysUntilExpiry <= days).toList();
});

final inventoryActionsProvider = StateNotifierProvider<InventoryActionsNotifier, AsyncValue<void>>((ref) {
  return InventoryActionsNotifier(ref.watch(inventoryRepositoryProvider), ref);
});

class InventoryActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final InventoryRepository _repository;
  final Ref _ref;

  InventoryActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> addItem(InventoryItem item) async {
    state = const AsyncValue.loading();
    final result = await _repository.addItem(item);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(inventoryProvider);
      },
    );
  }

  Future<void> updateItem(InventoryItem item) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateItem(item);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(inventoryProvider);
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
        _ref.invalidate(inventoryProvider);
      },
    );
  }

  Future<void> bulkUpsert(List<InventoryItem> items) async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) return;

    state = const AsyncValue.loading();
    final result = await _repository.bulkUpsert(authState.user.id, items);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        state = const AsyncValue.data(null);
        _ref.invalidate(inventoryProvider);
      },
    );
  }
}
