import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_notifier.dart';
import 'package:prodiet_unified/features/ocr_scanner/data/ocr_repository.dart';
import 'package:prodiet_unified/features/inventory/data/inventory_repository.dart';
import 'package:prodiet_unified/features/ocr_scanner/domain/scanned_item.dart';

class MockOcrRepository extends Mock implements OcrRepository {}
class MockInventoryRepository extends Mock implements InventoryRepository {}
class FakeFile extends Fake implements File {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockOcrRepository mockOcrRepository;
  late MockInventoryRepository mockInventoryRepository;
  late OcrNotifier ocrNotifier;
  const userId = 'user_123';

  setUpAll(() {
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockOcrRepository = MockOcrRepository();
    mockInventoryRepository = MockInventoryRepository();
    ocrNotifier = OcrNotifier(
      ocrRepo: mockOcrRepository,
      inventoryRepo: mockInventoryRepository,
      userId: userId,
    );
  });

  group('OcrNotifier State Pipeline Tests', () {
    test('initial state is OcrIdle', () {
      expect(ocrNotifier.state, isA<OcrIdle>());
    });

    test('manual state transition to results, toggle item selection, and count selections', () {
      final items = [
        const ScannedItem(name: 'Chicken Breast', quantity: 200, unit: 'g', category: 'Protein', isSelected: true),
        const ScannedItem(name: 'Brown Rice', quantity: 150, unit: 'g', category: 'Carbs', isSelected: true),
        const ScannedItem(name: 'Avocado', quantity: 1, unit: 'pcs', category: 'Fats', isSelected: false),
      ];

      ocrNotifier.state = OcrResults(items);

      // Verify selectedCount and selectedItems
      final state = ocrNotifier.state as OcrResults;
      expect(state.selectedCount, 2);
      expect(state.selectedItems.length, 2);
      expect(state.selectedItems.first.name, 'Chicken Breast');

      // Toggle first item (deselect Chicken Breast)
      ocrNotifier.toggleItemSelection(0);
      
      final updatedState1 = ocrNotifier.state as OcrResults;
      expect(updatedState1.selectedCount, 1);
      expect(updatedState1.items[0].isSelected, false);

      // Toggle third item (select Avocado)
      ocrNotifier.toggleItemSelection(2);
      final updatedState2 = ocrNotifier.state as OcrResults;
      expect(updatedState2.selectedCount, 2);
      expect(updatedState2.items[2].isSelected, true);
    });

    test('saveItems saves selected items to inventory repository and transitions to OcrSaved', () async {
      final items = [
        const ScannedItem(name: 'Chicken Breast', quantity: 200, unit: 'g', category: 'Protein', isSelected: true),
        const ScannedItem(name: 'Avocado', quantity: 1, unit: 'pcs', category: 'Fats', isSelected: false),
      ];

      ocrNotifier.state = OcrResults(items);

      when(() => mockInventoryRepository.addItemsFromOcr(userId, any()))
          .thenAnswer((_) async {});

      // Trigger saving
      final future = ocrNotifier.saveItems();

      // Check loading/saving state
      expect(ocrNotifier.state, isA<OcrSaving>());

      await future;

      // Verify saved state
      expect(ocrNotifier.state, isA<OcrSaved>());

      // Verify repository was called only for the selected item
      verify(() => mockInventoryRepository.addItemsFromOcr(userId, [
        {
          'name': 'Chicken Breast',
          'quantity': 200.0,
          'unit': 'g',
          'category': 'Protein',
        }
      ])).called(1);
    });

    test('saveItems transitions to OcrError when inventory repository throws', () async {
      final items = [
        const ScannedItem(name: 'Chicken Breast', quantity: 200, unit: 'g', category: 'Protein', isSelected: true),
      ];

      ocrNotifier.state = OcrResults(items);

      when(() => mockInventoryRepository.addItemsFromOcr(userId, any()))
          .thenThrow(Exception('Database is full'));

      await ocrNotifier.saveItems();

      expect(ocrNotifier.state, isA<OcrError>());
      final errorState = ocrNotifier.state as OcrError;
      expect(errorState.message, contains('Database is full'));
    });

    test('clearResults resets state back to OcrIdle', () {
      final items = [
        const ScannedItem(name: 'Chicken Breast', quantity: 200, unit: 'g', category: 'Protein', isSelected: true),
      ];
      ocrNotifier.state = OcrResults(items);

      ocrNotifier.clearResults();

      expect(ocrNotifier.state, isA<OcrIdle>());
    });
  });
}
