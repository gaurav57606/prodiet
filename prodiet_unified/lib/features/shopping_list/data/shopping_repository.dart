import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:prodiet_unified/core/data/local/app_database.dart';
import 'package:prodiet_unified/core/sync/sync_queue.dart';
import 'package:prodiet_unified/core/sync/sync_task.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../domain/models/shopping_item.dart';

class ShoppingRepository {
  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  static const String _tag = 'ShoppingRepository';

  ShoppingRepository(this._db, this._syncQueue);

  Stream<List<ShoppingItem>> watchList(String userId) {
    return _db.shoppingDao.watchList(userId).map((localData) {
      return localData.map((l) => ShoppingItem(
        id: l.id,
        userId: l.userId,
        ingredientName: l.ingredientName,
        quantity: l.quantity,
        unit: l.unit,
        isPurchased: l.isPurchased,
        source: l.source,
      )).toList();
    });
  }

  Future<Either<AppError, void>> addItem(ShoppingItem item) async {
    try {
      final now = DateTime.now();
      final id = item.id.isEmpty ? const Uuid().v4() : item.id;
      
      // 1. Local Write
      await _db.shoppingDao.upsertItem(LocalShoppingListCompanion.insert(
        id: id,
        userId: item.userId,
        ingredientName: item.ingredientName,
        quantity: item.quantity,
        unit: item.unit,
        isPurchased: Value(item.isPurchased),
        source: Value(item.source),
        isDirty: const Value(true),
        clientUpdatedAt: Value(now),
      ));

      // 2. Sync
      await _syncQueue.enqueue(SyncTask(
        id: 0,
        createdAt: now,
        operation: SyncOperation.insert,
        target: SyncTarget.shopping_list,
        recordId: id,
        payload: {
          ...item.toJson(),
          'id': id,
          'client_updated_at': now.toIso8601String(),
        },
      ));
      
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.addItem'));
    }
  }

  Future<Either<AppError, void>> markPurchased(String itemId, bool isPurchased) async {
    try {
      final now = DateTime.now();
      
      // Optimistic
      await (_db.update(_db.localShoppingList)..where((t) => t.id.equals(itemId))).write(
        LocalShoppingListCompanion(
          isPurchased: Value(isPurchased),
          isDirty: const Value(true),
          clientUpdatedAt: Value(now),
        ),
      );
      
      await _syncQueue.enqueue(SyncTask(
        id: 0,
        createdAt: now,
        operation: SyncOperation.update,
        target: SyncTarget.shopping_list,
        recordId: itemId,
        payload: {
          'is_purchased': isPurchased,
          'client_updated_at': now.toIso8601String(),
        },
      ));
      
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.markPurchased'));
    }
  }

  Future<Either<AppError, void>> deleteItem(String itemId) async {
    try {
      await _db.shoppingDao.deleteItem(itemId);
      
      await _syncQueue.enqueue(SyncTask(
        id: 0,
        createdAt: DateTime.now(),
        operation: SyncOperation.delete,
        target: SyncTarget.shopping_list,
        recordId: itemId,
        payload: {},
      ));
      
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.deleteItem'));
    }
  }

  Future<Either<AppError, List<ShoppingItem>>> getList(String userId) async {
    try {
      final localData = await (_db.select(_db.localShoppingList)
        ..where((s) => s.userId.equals(userId))
        ..orderBy([(s) => OrderingTerm.asc(s.ingredientName)]))
        .get();
      final items = localData.map((l) => ShoppingItem(
        id: l.id,
        userId: l.userId,
        ingredientName: l.ingredientName,
        quantity: l.quantity,
        unit: l.unit,
        isPurchased: l.isPurchased,
        source: l.source,
      )).toList();
      return Right(items);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getList'));
    }
  }

  Future<Either<AppError, void>> clearPurchased(String userId) async {
    try {
      final purchased = await (_db.select(_db.localShoppingList)
        ..where((s) => s.userId.equals(userId) & s.isPurchased.equals(true)))
        .get();

      for (var item in purchased) {
        await _db.shoppingDao.deleteItem(item.id);
        await _syncQueue.enqueue(SyncTask(
          id: 0,
          createdAt: DateTime.now(),
          operation: SyncOperation.delete,
          target: SyncTarget.shopping_list,
          recordId: item.id,
          payload: {},
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.clearPurchased'));
    }
  }

  Future<Either<AppError, void>> generateFromLowStock(String userId) async {
    try {
      // Logic for generation would still involve checking inventory
      // In a true offline app, we check local inventory.
      final lowStock = await _db.inventoryDao.getAll(userId);
      final itemsToRefill = lowStock.where((i) => i.quantity <= (i.reorderThreshold ?? 0));

      for (var i in itemsToRefill) {
        await addItem(ShoppingItem(
          id: '',
          userId: userId,
          ingredientName: i.ingredientName,
          quantity: (i.reorderThreshold ?? 50) * 2,
          unit: i.unit,
          isPurchased: false,
          source: 'auto',
        ));
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.generateFromLowStock'));
    }
  }
}
