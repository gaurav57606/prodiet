import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/app_error.dart';
import '../../../core/error/error_handler.dart';
import '../domain/models/shopping_item.dart';

class ShoppingRepository {
  final SupabaseClient _supabase;
  static const String _tag = 'ShoppingRepository';

  ShoppingRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  Future<Either<AppError, List<ShoppingItem>>> getList() async {
    try {
      final userId = _currentUserId;
      if (userId == null)
        return const Left(AuthError(message: 'User not authenticated'));

      final response =
          await _supabase.from('shopping_list').select().eq('user_id', userId);

      final items =
          (response as List).map((i) => ShoppingItem.fromJson(i)).toList();
      return Right(items);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getList'));
    }
  }

  Future<Either<AppError, List<ShoppingItem>>> getUnpurchased() async {
    try {
      final userId = _currentUserId;
      if (userId == null)
        return const Left(AuthError(message: 'User not authenticated'));

      final response = await _supabase
          .from('shopping_list')
          .select()
          .eq('user_id', userId)
          .eq('is_purchased', false);

      final items =
          (response as List).map((i) => ShoppingItem.fromJson(i)).toList();
      return Right(items);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.getUnpurchased'));
    }
  }

  Future<Either<AppError, ShoppingItem>> addItem(ShoppingItem item) async {
    try {
      final userId = _currentUserId;
      if (userId == null)
        return const Left(AuthError(message: 'User not authenticated'));

      final itemData = item.toJson();
      itemData['user_id'] =
          userId; // Override with actual authenticated user ID

      final response = await _supabase
          .from('shopping_list')
          .insert(itemData)
          .select()
          .single();

      return Right(ShoppingItem.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.addItem'));
    }
  }

  Future<Either<AppError, ShoppingItem>> markPurchased(
      String itemId, bool isPurchased) async {
    try {
      // For updates, RLS should ensure the user owns the item.
      // We don't strictly need to add .eq('user_id', userId) if RLS is on,
      // but we could for extra safety.
      final response = await _supabase
          .from('shopping_list')
          .update({'is_purchased': isPurchased})
          .eq('id', itemId)
          .select()
          .single();

      return Right(ShoppingItem.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.markPurchased'));
    }
  }

  Future<Either<AppError, void>> deleteItem(String itemId) async {
    try {
      await _supabase.from('shopping_list').delete().eq('id', itemId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.deleteItem'));
    }
  }

  Future<Either<AppError, void>> clearPurchased() async {
    try {
      final userId = _currentUserId;
      if (userId == null)
        return const Left(AuthError(message: 'User not authenticated'));

      await _supabase
          .from('shopping_list')
          .delete()
          .eq('user_id', userId)
          .eq('is_purchased', true);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: '$_tag.clearPurchased'));
    }
  }

  Future<Either<AppError, List<ShoppingItem>>> generateFromLowStock() async {
    try {
      final userId = _currentUserId;
      if (userId == null)
        return const Left(AuthError(message: 'User not authenticated'));

      // 1. Get low stock items from inventory
      final inventoryResponse =
          await _supabase.from('inventory').select().eq('user_id', userId);

      final lowStockItems = (inventoryResponse as List)
          .where(
              (i) => (i['quantity'] as num) <= (i['reorder_threshold'] as num))
          .toList();

      if (lowStockItems.isEmpty) return const Right([]);

      // 2. Map to shopping items
      final newShoppingItems = lowStockItems
          .map((i) => {
                'user_id': userId,
                'ingredient_name': i['ingredient_name'],
                'quantity': (i['reorder_threshold'] as num) *
                    2, // Arbitrary refill amount
                'unit': i['unit'],
                'is_purchased': false,
                'source': 'auto',
              })
          .toList();

      // 3. Insert into shopping_list
      final response = await _supabase
          .from('shopping_list')
          .insert(newShoppingItems)
          .select();

      final items =
          (response as List).map((i) => ShoppingItem.fromJson(i)).toList();
      return Right(items);
    } catch (e) {
      return Left(
          ErrorHandler.handle(e, context: '$_tag.generateFromLowStock'));
    }
  }
}
