import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import '../data/shopping_repository.dart';
import '../models/shopping_item.dart';

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepository(ref.watch(supabaseClientProvider));
});

final shoppingListProvider = FutureProvider<List<ShoppingItem>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(shoppingRepositoryProvider).getShoppingList(user.id);
});

final shoppingActionsProvider = Provider<ShoppingActions>((ref) {
  return ShoppingActions(ref);
});

class ShoppingActions {
  final Ref _ref;
  ShoppingActions(this._ref);

  Future<void> toggleBought(String itemId, bool isBought) async {
    await _ref.read(shoppingRepositoryProvider).toggleBought(itemId, isBought);
    _ref.invalidate(shoppingListProvider);
  }

  Future<void> clearBought() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;
    await _ref.read(shoppingRepositoryProvider).clearBought(user.id);
    _ref.invalidate(shoppingListProvider);
  }

  Future<void> syncToInventory() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;
    await _ref.read(shoppingRepositoryProvider).syncToInventory(user.id);
    _ref.invalidate(shoppingListProvider);
    // Also invalidate inventory since it changed
    // ref.invalidate(inventoryProvider); // Need to import or use a global way if possible
  }

  Future<void> addItem({
    required String name,
    required double quantity,
    required String unit,
    required String category,
  }) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;
    await _ref.read(shoppingRepositoryProvider).addItem(
      userId: user.id,
      ingredientName: name,
      quantity: quantity,
      unit: unit,
      category: category,
    );
    _ref.invalidate(shoppingListProvider);
  }
}
