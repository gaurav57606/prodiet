import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:prodiet_unified/core/cache/semantic_cache.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';
import '../domain/models/nutrition_item.dart';
import '../domain/daily_macro_summary.dart';
import '../domain/top_food_item.dart';

class NutritionRepository {
  final SupabaseService _client;
  final SemanticCache _cache;
  final http.Client _httpClient;

  static const _offBaseUrl = 'https://world.openfoodfacts.org';

  NutritionRepository(this._client, this._cache, [http.Client? httpClient])
      : _httpClient = httpClient ?? http.Client();

  Future<Either<AppError, NutritionItem>> lookupByBarcode(
      String barcode) async {
    try {
      // 1. Check local Supabase nutrition table (exact barcode)
      final localResult = await _client.perform((client) async {
        return await client
            .from('nutrition')
            .select()
            .eq('barcode', barcode)
            .maybeSingle();
      }, context: 'nutrition.lookupByBarcodeLocal');

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
      final edgeResult = await _client.perform((client) async {
        return await client.functions.invoke(
          'nutrition-lookup',
          body: {'barcode': barcode},
        );
      }, context: 'nutrition.lookupByBarcodeEdge');

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
      final localResults = await _client.perform((client) async {
        return await client
            .from('nutrition')
            .select()
            .ilike('product_name', '%${_escapeLike(query)}%')
            .limit(10);
      }, context: 'nutrition.searchByNameLocal');

      if (localResults.isNotEmpty) {
        final items =
            (localResults as List).map((i) => NutritionItem.fromJson(i)).toList();
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
      final edgeResult = await _client.perform((client) async {
        return await client.functions.invoke(
          'nutrition-lookup',
          body: {'query': query},
        );
      }, context: 'nutrition.searchByNameEdge');

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
      await _client.perform((client) async {
        await client.from('nutrition').upsert(item.toJson());
      }, context: 'nutrition.saveToLocal');
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

  /// Returns last 7 days of daily macro totals.
  Future<List<DailyMacroSummary>> getWeeklyMacros(String userId) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7))
        .toIso8601String().split('T')[0];
    
    final data = await _client.perform((client) async {
      return await client
          .from('meals')
          .select('planned_date, calories, protein_g, carbs_g, fat_g, status')
          .eq('user_id', userId)
          .eq('status', 'eaten')
          .gte('planned_date', sevenDaysAgo)
          .order('planned_date');
    }, context: 'nutrition.getWeeklyMacros');

    // Group by date
    final Map<String, DailyMacroSummary> grouped = {};
    for (final row in data as List<dynamic>) {
      final date = row['planned_date'] as String;
      final existing = grouped[date] ?? DailyMacroSummary(date: date);
      grouped[date] = existing.copyWith(
        calories: existing.calories + (row['calories'] as num? ?? 0).toInt(),
        protein: existing.protein + (row['protein_g'] as num? ?? 0).toInt(),
        carbs: existing.carbs + (row['carbs_g'] as num? ?? 0).toInt(),
        fat: existing.fat + (row['fat_g'] as num? ?? 0).toInt(),
      );
    }
    return grouped.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }
  
  /// Returns top 5 most eaten meal names (protein ranking).
  Future<List<TopFoodItem>> getTopProteinSources(String userId) async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30))
        .toIso8601String().split('T')[0];
    
    final data = await _client.perform((client) async {
      return await client
          .from('meals')
          .select('name, protein_g')
          .eq('user_id', userId)
          .eq('status', 'eaten')
          .gte('planned_date', thirtyDaysAgo)
          .order('protein_g', ascending: false)
          .limit(5);
    }, context: 'nutrition.getTopProteinSources');
    
    return (data as List<dynamic>).map((row) => TopFoodItem(
      name: row['name'] as String? ?? '',
      proteinG: (row['protein_g'] as num? ?? 0).toInt(),
    )).toList();
  }
}
