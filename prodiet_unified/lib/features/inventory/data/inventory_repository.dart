import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../domain/models/inventory_item.dart';

class InventoryRepository {
  final SupabaseClient _supabase;
  static const String _tag = 'InventoryRepository';

  InventoryRepository(this._supabase);

  Future<Either<AppError, List<InventoryItem>>> getAll(String userId) async {
    try {
      final response = await _supabase
          .from('inventory')
          .select()
          .eq('user_id', userId);
      
      final items = (response as List).map((i) => InventoryItem.fromJson(i)).toList();
      return Right(items);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getAll'));
    }
  }

  Future<Either<AppError, List<InventoryItem>>> getLowStockItems(String userId) async {
    try {
      // In a real app, we might use a RPC or a complex filter if reorder_threshold varies
      // For now we'll fetch all and filter in app, or use postgrest filter if threshold is constant
      final response = await _supabase
          .from('inventory')
          .select()
          .eq('user_id', userId);
      
      final items = (response as List)
          .map((i) => InventoryItem.fromJson(i))
          .where((i) => i.isLowStock)
          .toList();
      return Right(items);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getLowStockItems'));
    }
  }

  Future<Either<AppError, List<InventoryItem>>> getExpiringItems(String userId, int withinDays) async {
    try {
      final response = await _supabase
          .from('inventory')
          .select()
          .eq('user_id', userId);
      
      final items = (response as List)
          .map((i) => InventoryItem.fromJson(i))
          .where((i) => i.daysUntilExpiry <= withinDays)
          .toList();
      return Right(items);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getExpiringItems'));
    }
  }

  Future<Either<AppError, InventoryItem>> addItem(InventoryItem item) async {
    try {
      final response = await _supabase
          .from('inventory')
          .insert(item.toJson())
          .select()
          .single();
      
      return Right(InventoryItem.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.addItem'));
    }
  }

  Future<Either<AppError, InventoryItem>> updateItem(InventoryItem item) async {
    try {
      final response = await _supabase
          .from('inventory')
          .update(item.toJson())
          .eq('id', item.id)
          .select()
          .single();
      
      return Right(InventoryItem.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.updateItem'));
    }
  }

  Future<Either<AppError, void>> deleteItem(String itemId) async {
    try {
      await _supabase.from('inventory').delete().eq('id', itemId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.deleteItem'));
    }
  }

  Future<Either<AppError, void>> bulkUpsert(String userId, List<InventoryItem> items) async {
    try {
      final data = items.map((i) => i.toJson()).toList();
      await _supabase.from('inventory').upsert(data);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.bulkUpsert'));
    }
  }
}
