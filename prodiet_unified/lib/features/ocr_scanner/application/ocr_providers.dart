import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import '../data/ocr_repository.dart';
import '../domain/ocr_result.dart';

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return OcrRepository(ref.watch(supabaseClientProvider));
});

class OcrNotifier extends StateNotifier<AsyncValue<OcrResult?>> {
  final OcrRepository _repo;

  OcrNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> scan(File imageFile) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.scanImage(imageFile);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void toggleItemSelection(int index) {
    final current = state.value;
    if (current == null) return;

    final updatedItems = current.items.toList();
    updatedItems[index] = updatedItems[index]
        .copyWith(isSelected: !updatedItems[index].isSelected);

    state = AsyncValue.data(
        OcrResult(items: updatedItems, rawText: current.rawText));
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final ocrStateProvider =
    StateNotifierProvider<OcrNotifier, AsyncValue<OcrResult?>>((ref) {
  return OcrNotifier(ref.watch(ocrRepositoryProvider));
});

final isScanningProvider = Provider<bool>((ref) {
  return ref.watch(ocrStateProvider).isLoading;
});
