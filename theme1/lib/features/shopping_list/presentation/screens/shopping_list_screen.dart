import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_button.dart';
import '../../../../shared/widgets/dm_card.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _buildCategory(context, 'PRODUCE', [
                  _ShoppingItem('Spinach', '2 bunches', true),
                  _ShoppingItem('Avocado', '3 units', false),
                  _ShoppingItem('Blueberries', '250g', false),
                ]),
                const SizedBox(height: AppSpacing.lg),
                _buildCategory(context, 'DAIRY & PROTEIN', [
                  _ShoppingItem('Greek Yogurt', '500g', true),
                  _ShoppingItem('Chicken Breast', '1kg', false),
                  _ShoppingItem('Eggs', '12 pack', false),
                ]),
                const SizedBox(height: AppSpacing.lg),
                _buildCategory(context, 'PANTRY', [
                  _ShoppingItem('Quinoa', '500g', false),
                  _ShoppingItem('Olive Oil', '1L', false),
                ]),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: DmButton(
              label: 'Sync to Inventory',
              onPressed: () {},
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, List<_ShoppingItem> items) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.25),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...items.map((item) => _buildItemTile(context, item)),
      ],
    );
  }

  Widget _buildItemTile(BuildContext context, _ShoppingItem item) {
    final theme = Theme.of(context);
    return DmCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: item.isBought,
            onChanged: (val) {},
            activeColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    decoration: item.isBought ? TextDecoration.lineThrough : null,
                    color: item.isBought ? theme.colorScheme.onSurface.withOpacity(0.3) : null,
                  ),
                ),
                Text(
                  item.quantity,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShoppingItem {
  final String name;
  final String quantity;
  final bool isBought;

  _ShoppingItem(this.name, this.quantity, this.isBought);
}
