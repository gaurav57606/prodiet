class InventoryItem {
  final String id;
  final String userId;
  final String ingredientName;
  final double quantity;
  final String unit;
  final double reorderThreshold;
  final int shelfLifeDays;
  final String category;
  final String lastRestocked;

  const InventoryItem({
    required this.id,
    required this.userId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.reorderThreshold,
    required this.shelfLifeDays,
    required this.category,
    required this.lastRestocked,
  });

  bool get isLowStock => quantity <= reorderThreshold;

  int daysUntilExpiry([DateTime? now]) {
    final restockedDate = DateTime.parse(lastRestocked);
    final expiryDate = restockedDate.add(Duration(days: shelfLifeDays));
    return expiryDate.difference(now ?? DateTime.now()).inDays;
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      userId: json['user_id'],
      ingredientName: json['ingredient_name'],
      quantity: (json['quantity'] as num? ?? 0).toDouble(),
      unit: json['unit'],
      reorderThreshold: (json['reorder_threshold'] as num? ?? 0).toDouble(),
      shelfLifeDays: (json['shelf_life_days'] as num? ?? 0).toInt(),
      category: json['category'],
      lastRestocked: json['last_restocked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ingredient_name': ingredientName,
      'quantity': quantity,
      'unit': unit,
      'reorder_threshold': reorderThreshold,
      'shelf_life_days': shelfLifeDays,
      'category': category,
      'last_restocked': lastRestocked,
    };
  }
}
