import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_chip.dart';
import '../../../../shared/widgets/dm_text_field.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../mock/inventory_mock.dart';
import '../widgets/inventory_item_tile.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pantry'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_rounded)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickMetrics(theme),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: DmTextField(
              hintText: 'Search ingredients...',
              prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [
                _categoryChip('All', true),
                _categoryChip('Proteins', false),
                _categoryChip('Vegetables', false),
                _categoryChip('Dairy', false),
                _categoryChip('Grains', false),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: InventoryMockData.items.length,
              itemBuilder: (context, index) {
                final item = InventoryMockData.items[index];
                return InventoryItemTile(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMetrics(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(child: _metricCard(theme, 'TOTAL ITEMS', '42', const Color(0xFF8B5CF6))),
          const SizedBox(width: 12),
          Expanded(child: _metricCard(theme, 'LOW STOCK', '5', const Color(0xFFFFB040))),
          const SizedBox(width: 12),
          Expanded(child: _metricCard(theme, 'EXPIRED', '2', const Color(0xFFFF6080))),
        ],
      ),
    );
  }

  Widget _metricCard(ThemeData theme, String label, String value, Color color) {
    return DmCard(
      color: color.withOpacity(0.08),
      borderSide: BorderSide(color: color.withOpacity(0.15)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: color.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DmChip(
        label: label,
        isSelected: isSelected,
        onSelected: (val) {},
      ),
    );
  }
}
