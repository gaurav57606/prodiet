import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/inventory_item.dart';

class InventoryRepository {
  final SupabaseClient _supabase;

  InventoryRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  Stream<List<InventoryItem>> watchInventory() {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('inventory')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.map((row) => InventoryItem.fromJson(row)).toList()
          ..sort((a, b) => a.ingredientName.compareTo(b.ingredientName)));
  }

  Future<void> addItem({
    required String name,
    required double quantity,
    required String unit,
    String category = 'Other',
    double reorderThreshold = 100,
  }) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final data = {
      'user_id': userId,
      'ingredient_name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'reorder_threshold': reorderThreshold,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _supabase.from('inventory').insert(data);
  }

  Future<void> updateQuantity(String itemId, double newQuantity) async {
    await _supabase.from('inventory').update({
      'quantity': newQuantity,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', itemId);
  }

  Future<void> deleteItem(String itemId) async {
    await _supabase.from('inventory').delete().eq('id', itemId);
  }

  Future<void> addItemsFromOcr(List<Map<String, dynamic>> items) async {
    final userId = _currentUserId;
    if (userId == null) return;

    // 1. Fetch current inventory to handle increments
    final currentInventory =
        await _supabase.from('inventory').select().eq('user_id', userId);

    final existingItems = {
      for (var item in currentInventory) item['ingredient_name'] as String: item
    };

    final List<Map<String, dynamic>> upsertData = [];

    for (var newItem in items) {
      final name = newItem['name'] as String;
      final qty = (newItem['quantity'] as num).toDouble();
      final unit = newItem['unit'] as String;
      final category = newItem['category'] as String? ?? 'Other';

      if (existingItems.containsKey(name)) {
        final existing = existingItems[name]!;
        upsertData.add({
          'id': existing['id'],
          'user_id': userId,
          'ingredient_name': name,
          'quantity': (existing['quantity'] as num).toDouble() + qty,
          'unit': unit,
          'category': category,
          'reorder_threshold':
              (existing['reorder_threshold'] as num).toDouble(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      } else {
        upsertData.add({
          'user_id': userId,
          'ingredient_name': name,
          'quantity': qty,
          'unit': unit,
          'category': category,
          'reorder_threshold': 100.0,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    }

    if (upsertData.isNotEmpty) {
      await _supabase
          .from('inventory')
          .upsert(upsertData, onConflict: 'user_id,ingredient_name');
    }
  }

  List<InventoryItem> getLowStockItems(List<InventoryItem> items) {
    return items.where((i) => i.isLowStock).toList();
  }
}
