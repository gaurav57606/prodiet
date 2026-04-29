import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/data/ocr_repository.dart';
import 'package:prodiet_unified/features/ocr_scanner/domain/ocr_result.dart';

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return OcrRepository(ref.watch(supabaseClientProvider));
});

final ocrStateProvider = AsyncNotifierProvider.autoDispose<OcrNotifier, OcrResult?>(() {
  return OcrNotifier();
});

class OcrNotifier extends AutoDisposeAsyncNotifier<OcrResult?> {
  @override
  Future<OcrResult?> build() async {
    return null;
  }

  Future<void> scan(File imageFile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => 
      ref.read(ocrRepositoryProvider).scanBill(imageFile)
    );
  }

  void toggleItemSelection(int index) {
    final currentData = state.value;
    if (currentData == null) return;

    final updatedItems = [...currentData.items];
    final item = updatedItems[index];
    updatedItems[index] = item.copyWith(isSelected: !item.isSelected);

    state = AsyncData(currentData.copyWith(items: updatedItems));
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final isScanningProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(ocrStateProvider).isLoading;
});
