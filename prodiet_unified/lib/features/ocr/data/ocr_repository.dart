import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/core/utils/image_preprocessor.dart';
import 'package:prodiet_unified/features/inventory/data/inventory_repository.dart';
import 'package:prodiet_unified/features/inventory/domain/models/inventory_item.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/ocr_result.dart';

class OcrRepository {
  final SupabaseClient _client;
  final InventoryRepository _inventoryRepo;
  final AnalyticsService _analytics;

  OcrRepository(this._client, this._inventoryRepo, this._analytics);

  Future<Either<AppError, OcrResult>> scanBill(File imageFile, String userId) async {
    try {
      _analytics.logEvent(userId, AnalyticsService.kOcrScanStarted, screen: 'ocr_screen');
      // 1. Preprocess image for OCR
      final bytes = await ImagePreprocessor.prepareForOcr(imageFile);
      
      // 2. Upload to temporary storage
      final imageUrl = await ImagePreprocessor.uploadToStorage(bytes, userId);
      
      // 3. Invoke OCR pipeline Edge Function
      final response = await _client.functions.invoke(
        'ocr-pipeline',
        body: {
          'image_url': imageUrl,
          'user_id': userId,
          'type': 'bill',
        },
      );

      if (response.status != 200) {
        return Left(ServerError(message: 'OCR Pipeline failed with status: ${response.status}'));
      }

      final result = OcrResult.fromJson(response.data);

      // 4. If confidence >= 0.85, sync to inventory automatically
      if (result.confidence >= 0.85) {
        final inventoryItems = result.items.map((item) => InventoryItem(
          id: const Uuid().v4(),
          userId: userId,
          ingredientName: item.name,
          quantity: item.quantity,
          unit: item.unit,
          reorderThreshold: 1.0, 
          shelfLifeDays: 7,
          category: 'Uncategorized',
          lastRestocked: DateTime.now().toIso8601String(),
        )).toList();

        await _inventoryRepo.bulkUpsert(userId, inventoryItems);
      }

      _analytics.logEvent(
        userId, 
        AnalyticsService.kOcrScanSuccess,
        data: {'confidence': result.confidence, 'item_count': result.items.length},
        screen: 'ocr_screen',
      );

      return Right(result);
    } catch (e) {
      _analytics.logError(userId, 'ocr_screen', e.toString());
      return Left(UnknownError(message: e.toString()));
    }
  }

  Future<Either<AppError, Map<String, dynamic>>> scanDietChart(File imageFile, String userId) async {
    try {
      _analytics.logEvent(userId, AnalyticsService.kOcrScanStarted, screen: 'diet_chart_scan');
      final bytes = await ImagePreprocessor.prepareForOcr(imageFile);
      final imageUrl = await ImagePreprocessor.uploadToStorage(bytes, userId);
      
      final response = await _client.functions.invoke(
        'ocr-pipeline',
        body: {
          'image_url': imageUrl,
          'user_id': userId,
          'type': 'diet_chart',
        },
      );

      if (response.status != 200) {
        return Left(ServerError(message: 'OCR Pipeline failed with status: ${response.status}'));
      }

      _analytics.logEvent(
        userId, 
        AnalyticsService.kOcrScanSuccess,
        data: {'type': 'diet_chart'},
        screen: 'diet_chart_scan',
      );

      return Right(response.data as Map<String, dynamic>);
    } catch (e) {
      _analytics.logError(userId, 'diet_chart_scan', e.toString());
      return Left(UnknownError(message: e.toString()));
    }
  }
}
