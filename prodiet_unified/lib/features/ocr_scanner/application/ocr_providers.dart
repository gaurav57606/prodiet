import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:prodiet_unified/core/services/ocr_service.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_notifier.dart';
import 'package:prodiet_unified/features/ocr_scanner/data/ocr_repository.dart';

final ocrServiceProvider = Provider<OcrService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return OcrService(supabaseService);
});

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return OcrRepository(ref.watch(ocrServiceProvider));
});

final ocrNotifierProvider = StateNotifierProvider<OcrNotifier, OcrState>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return OcrNotifier(
    ocrRepo: ref.watch(ocrRepositoryProvider),
    inventoryRepo: ref.watch(inventoryRepositoryProvider),
    userId: userId,
  );
});
