import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:prodiet_unified/core/cache/semantic_cache.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/nutrition_item.dart';

class NutritionRepository {
  final SupabaseClient _client;
  final SemanticCache _cache;
  final http.Client _httpClient;

  static const _offBaseUrl = 'https://world.openfoodfacts.org';

  NutritionRepository(this._client, this._cache, [http.Client? httpClient])
      : _httpClient = httpClient ?? http.Client();

  Future<Either<AppError, NutritionItem>> lookupByBarcode(
      String barcode) async {
    try {
      // 1. Check local Supabase nutrition table (exact barcode)
      final localResult = await _client
          .from('nutrition')
          .select()
          .eq('barcode', barcode)
          .maybeSingle();

      if (localResult != null) {
        return Right(NutritionItem.fromJson(localResult));
      }

      // 2. Call Open Food Facts API
      final offUrl = Uri.parse('$_offBaseUrl/api/v0/product/$barcode.json');
      final response = await _httpClient.get(offUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          final product = data['product'];
          final item = _mapOFFToNutritionItem(product, barcode);

          // Store result in local nutrition table
          await _saveToLocal(item);
          return Right(item);
        }
      }

      // 3. Call Supabase Edge Function 'nutrition-lookup'
      final edgeResult = await _client.functions.invoke(
        'nutrition-lookup',
        body: {'barcode': barcode},
      );

      if (edgeResult.status == 200 && edgeResult.data != null) {
        final item = NutritionItem.fromJson(edgeResult.data);
        await _saveToLocal(item);
        return Right(item);
      }

      return const Left(UnknownError(message: 'Product not found'));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<Either<AppError, List<NutritionItem>>> searchByName(
      String userId, String query) async {
    try {
      // 1. Check SemanticCache
      final cached =
          await _cache.get(CacheNamespace.nutrition, query, userId: userId);
      if (cached != null) {
        final items = (cached['items'] as List)
            .map((i) => NutritionItem.fromJson(i))
            .toList();
        return Right(items);
      }

      // 2. Check local Supabase nutrition table
      final localResults = await _client
          .from('nutrition')
          .select()
          .ilike('product_name', '%${_escapeLike(query)}%')
          .limit(10);

      if (localResults.isNotEmpty) {
        final items =
            localResults.map((i) => NutritionItem.fromJson(i)).toList();
        return Right(items);
      }

      // 3. Search Open Food Facts
      final offUrl =
          Uri.parse('$_offBaseUrl/cgi/search.pl?search_terms=$query&json=1');
      final response = await _httpClient.get(offUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['products'] as List? ?? [];
        if (products.isNotEmpty) {
          final items = products
              .map((p) => _mapOFFToNutritionItem(p, p['code'] as String?))
              .toList();

          // Cache and save (limit to top results)
          final topItems = items.take(5).toList();
          await _cache.put(CacheNamespace.nutrition, query, {
            'items': topItems.map((i) => i.toJson()).toList(),
          });
          for (var item in topItems) {
            await _saveToLocal(item);
          }

          return Right(items);
        }
      }

      // 4. Call Supabase Edge Function 'nutrition-lookup'
      final edgeResult = await _client.functions.invoke(
        'nutrition-lookup',
        body: {'query': query},
      );

      if (edgeResult.status == 200 && edgeResult.data != null) {
        // Edge function might return a single item or a list
        final List<NutritionItem> items = [];
        if (edgeResult.data is List) {
          items.addAll(
              (edgeResult.data as List).map((i) => NutritionItem.fromJson(i)));
        } else {
          items.add(NutritionItem.fromJson(edgeResult.data));
        }

        if (items.isNotEmpty) {
          await _cache.put(CacheNamespace.nutrition, query, {
            'items': items.map((i) => i.toJson()).toList(),
          });
          for (var item in items) {
            await _saveToLocal(item);
          }
          return Right(items);
        }
      }

      return const Left(UnknownError(message: 'No items found'));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  NutritionalValues calculatePortion(NutritionItem item, double grams) {
    return item.calculatePortion(grams);
  }

  NutritionItem _mapOFFToNutritionItem(Map<String, dynamic> product,
      [String? barcode]) {
    final nutriments = product['nutriments'] ?? {};
    return NutritionItem(
      id: product['_id'] ??
          product['id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      productName: product['product_name'] ?? 'Unknown Product',
      brand: product['brands'],
      barcode: barcode ?? product['code'],
      calories100g: (nutriments['energy-kcal_100g'] as num? ?? 0).toInt(),
      protein100g: (nutriments['proteins_100g'] as num? ?? 0).toDouble(),
      carbs100g: (nutriments['carbohydrates_100g'] as num? ?? 0).toDouble(),
      fat100g: (nutriments['fat_100g'] as num? ?? 0).toDouble(),
      fiber100g: (nutriments['fiber_100g'] as num? ?? 0).toDouble(),
      sugar100g: (nutriments['sugars_100g'] as num? ?? 0).toDouble(),
      servingSize: (product['serving_quantity'] as num?)?.toDouble(),
      imageUrl: product['image_url'],
      category: product['categories']?.split(',').first.trim(),
      createdAt: DateTime.now(),
    );
  }

  Future<void> _saveToLocal(NutritionItem item) async {
    try {
      await _client.from('nutrition').upsert(item.toJson());
    } catch (e) {
      // Silent fail for background storage
    }
  }

  String _escapeLike(String input) {
    return input
        .replaceAll('\\', '\\\\')
        .replaceAll('%', '\\%')
        .replaceAll('_', '\\_');
  }
}
