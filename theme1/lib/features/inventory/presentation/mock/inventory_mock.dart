enum StockLevel { low, medium, ok }

class InventoryMockData {
  static const List<InventoryItem> items = [
    InventoryItem(
      name: 'Skimmed Milk',
      subtext: 'Expires in 3 days',
      quantity: '500ml',
      percentage: 0.55,
      level: StockLevel.medium,
    ),
    InventoryItem(
      name: 'Paneer',
      subtext: 'Critical — running low',
      quantity: '100g',
      percentage: 0.15,
      level: StockLevel.low,
    ),
    InventoryItem(
      name: 'Spinach',
      subtext: 'Critical · 1 bunch',
      quantity: '1 bunch',
      percentage: 0.10,
      level: StockLevel.low,
    ),
    InventoryItem(
      name: 'Oats',
      subtext: 'Good stock',
      quantity: '400g',
      percentage: 0.70,
      level: StockLevel.ok,
    ),
    InventoryItem(
      name: 'Olive Oil',
      subtext: 'Well stocked',
      quantity: '450ml',
      percentage: 0.80,
      level: StockLevel.ok,
    ),
    InventoryItem(
      name: 'Almonds',
      subtext: 'Critical · 20g left',
      quantity: '20g',
      percentage: 0.08,
      level: StockLevel.low,
    ),
    InventoryItem(
      name: 'Chicken Breast',
      subtext: 'Fresh · 4 days',
      quantity: '500g',
      percentage: 0.60,
      level: StockLevel.ok,
    ),
    InventoryItem(
      name: 'Quinoa',
      subtext: 'Good stock',
      quantity: '300g',
      percentage: 0.65,
      level: StockLevel.ok,
    ),
  ];
}

class InventoryItem {
  final String name;
  final String subtext;
  final String quantity;
  final double percentage;
  final StockLevel level;

  const InventoryItem({
    required this.name,
    required this.subtext,
    required this.quantity,
    required this.percentage,
    required this.level,
  });
}
