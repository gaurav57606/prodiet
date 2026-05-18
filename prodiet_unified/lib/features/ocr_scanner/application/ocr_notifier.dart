import 'dart:io';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodiet_unified/features/inventory/data/inventory_repository.dart';
import 'package:prodiet_unified/features/ocr_scanner/data/ocr_repository.dart';
import 'package:prodiet_unified/features/ocr_scanner/domain/scanned_item.dart';

sealed class OcrState {
  const OcrState();
}

class OcrIdle extends OcrState {
  const OcrIdle();
}

class OcrScanning extends OcrState {
  const OcrScanning();
}

class OcrResults extends OcrState {
  final List<ScannedItem> items;
  const OcrResults(this.items);
  
  int get selectedCount => items.where((i) => i.isSelected).length;
  List<ScannedItem> get selectedItems => items.where((i) => i.isSelected).toList();
}

class OcrSaving extends OcrState {
  const OcrSaving();
}

class OcrSaved extends OcrState {
  const OcrSaved();
}

class OcrError extends OcrState {
  final String message;
  const OcrError(this.message);
}

class OcrNotifier extends StateNotifier<OcrState> {
  final OcrRepository _ocrRepo;
  final InventoryRepository _inventoryRepo;
  final String _userId;

  OcrNotifier({
    required OcrRepository ocrRepo,
    required InventoryRepository inventoryRepo,
    required String userId,
  })  : _ocrRepo = ocrRepo,
        _inventoryRepo = inventoryRepo,
        _userId = userId,
        super(const OcrIdle());

  Future<void> pickImage(ImageSource source) async {
    File? tempFile;
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70,
      );
      
      if (picked == null) return;
      
      tempFile = File(picked.path);
      state = const OcrScanning();
      
      final result = await _ocrRepo.scanImage(tempFile);
      state = OcrResults(result.items);
    } catch (e) {
      state = OcrError(e.toString());
    } finally {
      if (tempFile != null) {
        try {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } catch (_) {
          // Silent catch to prevent UI interruption
        }
      }
    }
  }

  void toggleItemSelection(int index) {
    final current = state;
    if (current is! OcrResults) return;
    
    final updatedItems = current.items.toList();
    updatedItems[index] = updatedItems[index].copyWith(
      isSelected: !updatedItems[index].isSelected
    );
    
    state = OcrResults(updatedItems);
  }

  Future<void> saveItems() async {
    final current = state;
    if (current is! OcrResults) return;
    
    final selectedItems = current.selectedItems;
    if (selectedItems.isEmpty) return;

    state = const OcrSaving();
    
    try {
      final itemsData = selectedItems.map((item) => {
        'name': item.name,
        'quantity': item.quantity,
        'unit': item.unit,
        'category': item.category,
      }).toList();

      await _inventoryRepo.addItemsFromOcr(_userId, itemsData);
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      state = const OcrSaved();
    } catch (e) {
      state = OcrError(e.toString());
    }
  }

  void clearResults() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    state = const OcrIdle();
  }
}
