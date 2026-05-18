import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/sync/sync_queue.dart';
import 'package:prodiet_unified/core/sync/sync_task.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:uuid/uuid.dart';
import '../domain/inventory_item.dart';

class InventoryRepository {
  final SupabaseService _supabase;
  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  InventoryRepository(this._supabase, this._db, this._syncQueue);

  Stream<List<InventoryItem>> watchInventory(String userId) {
    return _db.inventoryDao.watchInventory(userId).map((localData) {
      return localData.map((l) => InventoryItem(
        id: l.id,
        userId: l.userId,
        ingredientName: l.ingredientName,
        quantity: l.quantity,
        unit: l.unit,
        category: l.category ?? 'Other',
        reorderThreshold: l.reorderThreshold ?? 100,
        updatedAt: l.updatedAt ?? l.clientUpdatedAt,
      )).toList();
    });
  }

  Future<void> addItem(String userId, {
    required String name,
    required double quantity,
    required String unit,
    String category = 'Other',
    double reorderThreshold = 100,
  }) async {
    final now = DateTime.now();
    final id = const Uuid().v4();
    
    // 1. Write to local DB first
    await _db.inventoryDao.upsertItem(LocalInventoryCompanion.insert(
      id: id,
      userId: userId,
      ingredientName: name,
      quantity: quantity,
      unit: unit,
      category: Value(category),
      reorderThreshold: Value(reorderThreshold),
      isDirty: const Value(true),
      clientUpdatedAt: Value(now),
    ));

    // 2. Enqueue Sync
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      createdAt: DateTime.now(),
      operation: SyncOperation.insert,
      target: SyncTarget.inventory,
      recordId: id,
      payload: {
        'id': id,
        'user_id': userId,
        'ingredient_name': name,
        'quantity': quantity,
        'unit': unit,
        'category': category,
        'reorder_threshold': reorderThreshold,
        'client_updated_at': now.toIso8601String(),
      },
    ));
  }

  Future<void> updateQuantity(String itemId, double newQuantity) async {
    final now = DateTime.now();
    
    // Optimistic update
    await (_db.update(_db.localInventory)..where((t) => t.id.equals(itemId))).write(
      LocalInventoryCompanion(
        quantity: Value(newQuantity),
        isDirty: const Value(true),
        clientUpdatedAt: Value(now),
      ),
    );
    
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      createdAt: DateTime.now(),
      operation: SyncOperation.update,
      target: SyncTarget.inventory,
      recordId: itemId,
      payload: {
        'quantity': newQuantity,
        'client_updated_at': now.toIso8601String(),
      },
    ));
  }

  Future<void> deleteItem(String itemId) async {
    await _db.inventoryDao.deleteItem(itemId);
    
    await _syncQueue.enqueue(SyncTask(
      id: 0,
      createdAt: DateTime.now(),
      operation: SyncOperation.delete,
      target: SyncTarget.inventory,
      recordId: itemId,
      payload: {},
    ));
  }


  Future<void> addItemsFromOcr(String userId, List<Map<String, dynamic>> items) async {
    // 1. Fetch current inventory to handle increments
    final currentInventory = await _supabase.perform((client) async {
      return await client
          .from('inventory')
          .select()
          .eq('user_id', userId);
    }, context: 'inventory.addItemsFromOcrFetch');
    
    final existingItems = {
      for (var item in currentInventory as List<dynamic>)
        item['ingredient_name'] as String: item
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
          'reorder_threshold': (existing['reorder_threshold'] as num).toDouble(),
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
      await _supabase.perform((client) async {
        await client.from('inventory').upsert(upsertData, onConflict: 'user_id,ingredient_name');
      }, context: 'inventory.addItemsFromOcrUpsert');
    }
  }

  List<InventoryItem> getLowStockItems(List<InventoryItem> items) {
    return items.where((i) => i.isLowStock).toList();
  }
}
