import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_text_field.dart';
import '../mock/inventory_mock.dart';
import '../widgets/inventory_item_tile.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_rounded)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: DmTextField(
              hintText: 'Search ingredients...',
              prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: InventoryMockData.items.length,
              itemBuilder: (context, index) {
                final item = InventoryMockData.items[index];
                return InventoryItemTile(item: item);
              },
            ),
          ),
          
          // Low stock banner from HTML requirement
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            color: const Color(0xFFFF6080).withOpacity(0.12),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Color(0xFFFF6080), size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    '3 items are critically low in stock.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFFF6080),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Add to List',
                    style: TextStyle(color: Color(0xFFFF6080), fontWeight: FontWeight.w800, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
