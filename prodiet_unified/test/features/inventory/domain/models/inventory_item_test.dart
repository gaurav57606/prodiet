import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/inventory/domain/models/inventory_item.dart';

void main() {
  group('InventoryItem Model', () {
    test('isLowStock should return true when quantity <= reorderThreshold', () {
      const item = InventoryItem(
        id: '1',
        userId: 'u1',
        ingredientName: 'Milk',
        quantity: 1.0,
        unit: 'L',
        reorderThreshold: 2.0,
        shelfLifeDays: 7,
        category: 'Dairy',
        lastRestocked: '2026-05-01T10:00:00Z',
      );

      expect(item.isLowStock, isTrue);
    });

    test('isLowStock should return false when quantity > reorderThreshold', () {
      const item = InventoryItem(
        id: '1',
        userId: 'u1',
        ingredientName: 'Milk',
        quantity: 5.0,
        unit: 'L',
        reorderThreshold: 2.0,
        shelfLifeDays: 7,
        category: 'Dairy',
        lastRestocked: '2026-05-01T10:00:00Z',
      );

      expect(item.isLowStock, isFalse);
    });

    test('daysUntilExpiry should calculate correctly', () {
      final lastRestocked = DateTime(2026, 5, 1);
      final item = InventoryItem(
        id: '1',
        userId: 'u1',
        ingredientName: 'Milk',
        quantity: 1.0,
        unit: 'L',
        reorderThreshold: 2.0,
        shelfLifeDays: 7,
        category: 'Dairy',
        lastRestocked: lastRestocked.toIso8601String(),
      );

      // Expiry is 2026-05-08
      final now = DateTime(2026, 5, 4);
      expect(item.daysUntilExpiry(now), 4);

      final now2 = DateTime(2026, 5, 8);
      expect(item.daysUntilExpiry(now2), 0);

      final now3 = DateTime(2026, 5, 10);
      expect(item.daysUntilExpiry(now3), -2);
    });

    test('fromJson and toJson should be consistent', () {
      final json = {
        'id': '1',
        'user_id': 'u1',
        'ingredient_name': 'Apple',
        'quantity': 10.0,
        'unit': 'pcs',
        'reorder_threshold': 5.0,
        'shelf_life_days': 14,
        'category': 'Fruit',
        'last_restocked': '2026-05-01T10:00:00Z',
      };

      final item = InventoryItem.fromJson(json);
      expect(item.id, '1');
      expect(item.ingredientName, 'Apple');
      expect(item.toJson(), json);
    });
  });
}
