import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/inventory/domain/inventory_item.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_chip.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/meal_list_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final inventoryAsync = ref.watch(inventoryStreamProvider);
    final lowStockItems = ref.watch(lowStockProvider);
    final selectedCategory = ref.watch(inventoryCategoryFilterProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pantry'),
        actions: [
          IconButton(
            onPressed: () => _showAddItemSheet(context, ref, userId),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lowStockItems.isNotEmpty)
            _buildLowStockBanner(context, theme, lowStockItems.length),
          
          _buildCategoryFilter(ref, selectedCategory),
          
          Expanded(
            child: AsyncValueWidget<List<InventoryItem>>(
              value: inventoryAsync,
              skeleton: const MealListSkeleton(),
              isEmpty: (items) => items.isEmpty,
              emptyState: ProDietEmptyState(
                icon: EmptyStateConfigs.inventory.icon,
                headline: EmptyStateConfigs.inventory.headline,
                subtext: EmptyStateConfigs.inventory.subtext,
                buttonLabel: EmptyStateConfigs.inventory.buttonLabel,
                onButtonTap: () => context.push('/t1/ocr'),
              ),
              builder: (items) {
                final filtered = selectedCategory == null || selectedCategory == 'All'
                    ? items
                    : items.where((i) => i.category == selectedCategory).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildInventoryItemCard(context, ref, theme, filtered[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockBanner(BuildContext context, ThemeData theme, int count) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(T1Spacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 20),
          const SizedBox(width: 12),
          Text(
            '$count items running low',
            style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w900, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(WidgetRef ref, String? selected) {
    final categories = ['All', 'Grains', 'Protein', 'Dairy', 'Vegetables', 'Fruits', 'Oils', 'Spices', 'Other'];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
        itemCount: categories.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: DmChip(
            label: categories[index],
            isSelected: selected == categories[index],
            onSelected: (val) => ref.read(inventoryCategoryFilterProvider.notifier).state = categories[index],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryItemCard(BuildContext context, WidgetRef ref, ThemeData theme, InventoryItem item) {
    return _SlidableInventoryCard(
      item: item,
      onEdit: () => _showEditQuantitySheet(context, ref, item),
      onDelete: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Item?'),
            content: Text('Remove ${item.ingredientName} from your pantry?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('DELETE', style: TextStyle(color: Colors.red))),
            ],
          ),
        );
        if (result == true) {
          await ref.read(inventoryRepositoryProvider).deleteItem(item.id);
        }
      },
      child: DmCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(item.ingredientName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                      if (item.isLowStock) ...[
                        const SizedBox(width: 8),
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4)),
                    child: Text(item.category.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text('${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(width: 4),
                    Text(item.unit, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.w900)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditQuantitySheet(BuildContext context, WidgetRef ref, InventoryItem item) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: item.quantity.toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EDIT QUANTITY', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(item.ingredientName.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              decoration: InputDecoration(
                suffixText: item.unit,
                filled: true,
                fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
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
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('UPDATE', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showAddItemSheet(BuildContext context, WidgetRef ref, String userId) {
    final theme = Theme.of(context);
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    String selectedUnit = 'g';
    String selectedCategory = 'Other';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ADD TO PANTRY', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
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
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('ADD TO PANTRY', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetInput(BuildContext context, TextEditingController controller, String label, {bool isNumber = false}) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontSize: 12),
        filled: true,
        fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _sheetDropdown<T>({required BuildContext context, required T value, required List<T> items, required ValueChanged<T?> onChanged}) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: theme.colorScheme.surface,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
      onChanged: onChanged,
    );
  }
}

class _SlidableInventoryCard extends StatefulWidget {
  final Widget child;
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SlidableInventoryCard({
    required this.child,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_SlidableInventoryCard> createState() => _SlidableInventoryCardState();
}

class _SlidableInventoryCardState extends State<_SlidableInventoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragOffset = 0;
  static const double _actionWidth = 80;
  static const double _totalActionWidth = _actionWidth * 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta!;
      _dragOffset = _dragOffset.clamp(-_totalActionWidth, 0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset < -_totalActionWidth / 2) {
      _controller.animateTo(1.0);
      setState(() => _dragOffset = -_totalActionWidth);
    } else {
      _controller.animateTo(0.0);
      setState(() => _dragOffset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  widget.onEdit();
                  setState(() => _dragOffset = 0);
                },
                child: Container(
                  width: _actionWidth,
                  color: Colors.blueAccent,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_rounded, color: Colors.white),
                      Text('Edit', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onDelete();
                  setState(() => _dragOffset = 0);
                },
                child: Container(
                  width: _actionWidth,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.white),
                      Text('Delete', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
