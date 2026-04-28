import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ocr_repository.dart';
import '../domain/models/ocr_result.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';

import 'package:prodiet_unified/core/services/analytics_providers.dart';

final ocrRepositoryProvider = Provider<OcrRepository>((ref) => OcrRepository(
  ref.watch(supabaseClientProvider),
  ref.watch(inventoryRepositoryProvider),
  ref.watch(analyticsServiceProvider),
));

final ocrProvider = StateNotifierProvider<OcrNotifier, AsyncValue<OcrResult?>>((ref) {
  return OcrNotifier(ref.watch(ocrRepositoryProvider), ref.watch(currentUserProvider)?.id);
});

class OcrNotifier extends StateNotifier<AsyncValue<OcrResult?>> {
  final OcrRepository _repository;
  final String? _userId;

  OcrNotifier(this._repository, this._userId) : super(const AsyncValue.data(null));

  Future<void> processBill(File file) async {
    if (_userId == null) return;
    state = const AsyncValue.loading();
    final result = await _repository.scanBill(file, _userId!);
    state = result.fold(
      (e) => AsyncValue.error(e, StackTrace.current),
      (data) => AsyncValue.data(data),
    );
  }


  void reset() {
    state = const AsyncValue.data(null);
  }
}
