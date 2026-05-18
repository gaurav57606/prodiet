import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/navigation/app_navigator.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/inventory/domain/inventory_item.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/meal_list_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/inventory/presentation/widgets/adaptive_inventory_widgets.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final inventoryAsync = ref.watch(inventoryStreamProvider);
    final lowStockItems = ref.watch(lowStockProvider);
    final selectedCategory = ref.watch(inventoryCategoryFilterProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isT2 ? 'STOCK' : 'My Pantry'),
        centerTitle: isT2,
        actions: [
          IconButton(
            onPressed: () => _showAddItemSheet(context, ref, userId),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: isT2 
        ? FloatingActionButton.extended(
            onPressed: () => AppNavigator.toOcr(context),
            backgroundColor: tokens.colors.primary,
            label: Text(
              'SCAN BILL',
              style: tokens.typography.labelLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
          )
        : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lowStockItems.isNotEmpty)
            _buildLowStockBanner(context, lowStockItems.length),
          
          if (isT2) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildSearchBar(context),
            ),

          _buildCategoryFilter(context, ref, selectedCategory),
          
          Expanded(
            child: AsyncValueWidget<List<InventoryItem>>(
              value: inventoryAsync,
              skeleton: const MealListSkeleton(),
              isEmpty: (items) => items.isEmpty,
              emptyState: ProDietEmptyState(
                icon: EmptyStateConfigs.inventory.icon,
                headline: isT2 ? 'PANTRY EMPTY' : EmptyStateConfigs.inventory.headline,
                subtext: EmptyStateConfigs.inventory.subtext,
                buttonLabel: isT2 ? 'SCAN A BILL' : EmptyStateConfigs.inventory.buttonLabel,
                onButtonTap: () => AppNavigator.toOcr(context),
              ),
              builder: (items) {
                var filtered = items.where((i) => i.ingredientName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                if (selectedCategory != null && selectedCategory != 'All') {
                  filtered = filtered.where((i) => i.category == selectedCategory).toList();
                }

                if (isT2) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => AdaptiveInventoryTile(
                      item: filtered[index],
                      onEdit: () => _showEditQuantitySheet(context, ref, filtered[index]),
                      onDelete: () => _deleteItem(context, ref, filtered[index]),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AdaptiveInventoryTile(
                      item: filtered[index],
                      onEdit: () => _showEditQuantitySheet(context, ref, filtered[index]),
                      onDelete: () => _deleteItem(context, ref, filtered[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockBanner(BuildContext context, int count) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.colors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: tokens.colors.error, size: 20),
          const SizedBox(width: 12),
          Text(
            '$count ${tokens.dashboardLayout == AppDashboardLayout.t2 ? 'ITEMS RUNNING LOW' : 'items running low'}',
            style: tokens.typography.labelSmall.copyWith(color: tokens.colors.error, fontWeight: FontWeight.w900, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: 50,
      decoration: BoxDecoration(color: tokens.colors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.search, color: tokens.colors.onSurface.withValues(alpha: 0.4), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search pantry...',
                hintStyle: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.4), fontSize: 14),
                border: InputBorder.none,
              ),
              style: TextStyle(color: tokens.colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, WidgetRef ref, String? selected) {
    final tokens = context.tokens;
    final categories = ['All', 'Grains', 'Protein', 'Dairy', 'Vegetables', 'Fruits', 'Oils', 'Spices', 'Other'];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(
              tokens.dashboardLayout == AppDashboardLayout.t2 ? categories[index].toUpperCase() : categories[index],
              style: tokens.typography.labelSmall.copyWith(fontWeight: FontWeight.w800, fontSize: 12),
            ),
            selected: selected == categories[index],
            onSelected: (val) => ref.read(inventoryCategoryFilterProvider.notifier).state = categories[index],
            selectedColor: tokens.colors.primary,
            backgroundColor: tokens.colors.surfaceContainerLow,
            labelStyle: TextStyle(color: selected == categories[index] ? Colors.black : tokens.colors.onSurface),
          ),
        ),
      ),
    );
  }

  void _showEditQuantitySheet(BuildContext context, WidgetRef ref, InventoryItem item) {
    final tokens = context.tokens;
    final controller = TextEditingController(text: item.quantity.toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tokens.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EDIT QUANTITY', style: tokens.typography.titleLarge.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(item.ingredientName.toUpperCase(), style: tokens.typography.labelSmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.3))),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: tokens.typography.headlineMedium.copyWith(fontWeight: FontWeight.w900),
              decoration: InputDecoration(
                suffixText: item.unit,
                filled: true,
                fillColor: tokens.colors.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  final qty = double.tryParse(controller.text);
                  if (qty != null) {
                    await ref.read(inventoryRepositoryProvider).updateQuantity(item.id, qty);
                    if (context.mounted) context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: tokens.colors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('UPDATE', style: tokens.typography.labelLarge.copyWith(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showAddItemSheet(BuildContext context, WidgetRef ref, String userId) {
    final tokens = context.tokens;
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    String selectedUnit = 'g';
    String selectedCategory = 'Other';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tokens.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ADD TO PANTRY', style: tokens.typography.titleLarge.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              _sheetInput(context, nameController, 'Ingredient Name'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(flex: 2, child: _sheetInput(context, qtyController, 'Quantity', isNumber: true)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _sheetDropdown<String>(
                      context: context,
                      value: selectedUnit,
                      items: ['g', 'kg', 'ml', 'L', 'pcs', 'cups'],
                      onChanged: (v) => setState(() => selectedUnit = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _sheetDropdown<String>(
                context: context,
                value: selectedCategory,
                items: ['Grains', 'Protein', 'Dairy', 'Vegetables', 'Fruits', 'Oils', 'Spices', 'Other'],
                onChanged: (v) => setState(() => selectedCategory = v!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || qtyController.text.isEmpty) return;
                    await ref.read(inventoryRepositoryProvider).addItem(
                      userId,
                      name: nameController.text,
                      quantity: double.parse(qtyController.text),
                      unit: selectedUnit,
                      category: selectedCategory,
                    );
                    if (context.mounted) context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.colors.primary,
                    foregroundColor: tokens.colors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('ADD TO PANTRY', style: tokens.typography.labelLarge.copyWith(fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteItem(BuildContext context, WidgetRef ref, InventoryItem item) async {
    final tokens = context.tokens;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tokens.dashboardLayout == AppDashboardLayout.t2 ? 'DELETE ${item.ingredientName.toUpperCase()}?' : 'Delete Item?'),
        content: Text('Remove ${item.ingredientName} from your pantry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('DELETE', style: TextStyle(color: tokens.colors.error))),
        ],
      ),
    );
    if (result == true) {
      await ref.read(inventoryRepositoryProvider).deleteItem(item.id);
    }
  }

  Widget _sheetInput(BuildContext context, TextEditingController controller, String label, {bool isNumber = false}) {
    final tokens = context.tokens;
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontSize: 12),
        filled: true,
        fillColor: tokens.colors.onSurface.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _sheetDropdown<T>({required BuildContext context, required T value, required List<T> items, required ValueChanged<T?> onChanged}) {
    final tokens = context.tokens;
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: tokens.colors.surface,
      decoration: InputDecoration(
        filled: true,
        fillColor: tokens.colors.onSurface.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
      onChanged: onChanged,
    );
  }
}
