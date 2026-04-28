import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shopping_item.dart';

class ShoppingRepository {
  final SupabaseClient _client;

  ShoppingRepository(this._client);

  Future<List<ShoppingItem>> getShoppingList(String userId) async {
    final response = await _client
        .from('shopping_list')
        .select()
        .eq('user_id', userId)
        .order('category', ascending: true);
    
    return (response as List).map((json) => ShoppingItem.fromJson(json)).toList();
  }

  Future<void> addItem({
    required String userId,
    required String ingredientName,
    required double quantity,
    required String unit,
    required String category,
  }) async {
    await _client.from('shopping_list').insert({
      'user_id': userId,
      'ingredient_name': ingredientName,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'is_bought': false,
    });
  }

  Future<void> toggleBought(String itemId, bool isBought) async {
    await _client.from('shopping_list').update({
      'is_bought': isBought,
    }).eq('id', itemId);
  }

  Future<void> clearBought(String userId) async {
    await _client.from('shopping_list').delete().eq('user_id', userId).eq('is_bought', true);
  }

  Future<void> syncToInventory(String userId) async {
    // 1. Get all bought items
    final response = await _client
        .from('shopping_list')
        .select()
        .eq('user_id', userId)
        .eq('is_bought', true);
    
    final boughtItems = (response as List).map((json) => ShoppingItem.fromJson(json)).toList();
    
    if (boughtItems.isEmpty) return;

    // 2. Add each to inventory
    for (final item in boughtItems) {
      await _client.from('inventory').insert({
        'user_id': userId,
        'ingredient_name': item.ingredientName,
        'quantity': item.quantity,
        'unit': item.unit,
        'category': item.category,
        'last_restocked': DateTime.now().toIso8601String(),
        'reorder_threshold': 1.0, // Default
        'shelf_life_days': 7,      // Default
      });
    }

    // 3. Delete from shopping list
    await clearBought(userId);
  }
}
