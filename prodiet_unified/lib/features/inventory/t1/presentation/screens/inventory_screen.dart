import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_chip.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import '../application/inventory_providers.dart';
import '../widgets/inventory_item_tile.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inventoryAsync = ref.watch(inventoryProvider);
    final lowStockAsync = ref.watch(lowStockProvider);
    final expiringAsync = ref.watch(expiringItemsProvider(0)); // Already expired

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
          _buildQuickMetrics(theme, inventoryAsync, lowStockAsync, expiringAsync),
          Padding(
            padding: const EdgeInsets.all(T1Spacing.lg),
            child: DmTextField(
              hintText: 'Search ingredients...',
              prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
              children: [
                'All', 'Proteins', 'Vegetables', 'Dairy', 'Grains', 'Fruits', 'Spices'
              ].map((cat) => _categoryChip(cat, _selectedCategory == cat)).toList(),
            ),
          ),
          const SizedBox(height: T1Spacing.lg),
          Expanded(
            child: inventoryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (items) {
                final filtered = items.where((item) {
                  final matchesSearch = item.ingredientName.toLowerCase().contains(_searchQuery);
                  final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text('No items found', 
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.bold)
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return InventoryItemTile(item: filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMetrics(ThemeData theme, AsyncValue<List<dynamic>> total, AsyncValue<List<dynamic>> low, AsyncValue<List<dynamic>> expired) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
      child: Row(
        children: [
          Expanded(child: _metricCard(theme, 'TOTAL ITEMS', total.maybeWhen(data: (d) => '${d.length}', orElse: () => '--'), const Color(0xFF8B5CF6))),
          const SizedBox(width: 12),
          Expanded(child: _metricCard(theme, 'LOW STOCK', low.maybeWhen(data: (d) => '${d.length}', orElse: () => '--'), const Color(0xFFFFB040))),
          const SizedBox(width: 12),
          Expanded(child: _metricCard(theme, 'EXPIRED', expired.maybeWhen(data: (d) => '${d.length}', orElse: () => '--'), const Color(0xFFFF6080))),
        ],
      ),
    );
  }

  Widget _metricCard(ThemeData theme, String label, String value, Color color) {
    return DmCard(
      color: color.withValues(alpha: 0.08),
      borderSide: BorderSide(color: color.withValues(alpha: 0.15)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: color.withValues(alpha: 0.6),
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
        onSelected: (val) {
          if (val) setState(() => _selectedCategory = label);
        },
      ),
    );
  }
}
