import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/inventory/domain/inventory_item.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryStreamProvider);
    final lowStockItems = ref.watch(lowStockProvider);
    final selectedCategory = ref.watch(inventoryCategoryFilterProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddItemSheet(context, ref),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/t2/ocr'),
        backgroundColor: T2Colors.lime,
        label: const Text(
          'SCAN BILL',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2),
        ),
        icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STOCK',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: T2Colors.amber,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (lowStockItems.isNotEmpty)
                    _buildLowStockBanner(lowStockItems.length),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildCategoryFilter(ref, selectedCategory),
                ],
              ),
            ),
          ),
          AsyncValueWidget<List<InventoryItem>>(
            value: inventoryAsync,
            skeleton: const SliverToBoxAdapter(
                child: Center(
                    child: CircularProgressIndicator(color: T2Colors.amber))),
            isEmpty: (items) => items.isEmpty,
            emptyState: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        color: T2Colors.textMuted, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'PANTRY EMPTY',
                      style: GoogleFonts.barlowCondensed(
                        color: T2Colors.textMuted,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Scan a bill or add items manually to get started.',
                      style: TextStyle(
                          color: T2Colors.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/t2/ocr'),
                      icon: const Icon(Icons.qr_code_scanner,
                          color: Colors.black),
                      label: const Text(
                        'SCAN A BILL',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: T2Colors.lime,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _showAddItemSheet(context, ref),
                      child: Text(
                        'ADD MANUALLY',
                        style: GoogleFonts.barlowCondensed(
                          color: T2Colors.amber,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            builder: (items) {
              var filtered = items
                  .where((i) =>
                      i.ingredientName.toLowerCase().contains(_searchQuery))
                  .toList();
              if (selectedCategory != null && selectedCategory != 'All') {
                filtered = filtered
                    .where((i) => i.category == selectedCategory)
                    .toList();
              }

              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildStockTile(context, ref, filtered[index]),
                    childCount: filtered.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildLowStockBanner(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: T2Colors.coral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: T2Colors.coral.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: T2Colors.coral, size: 20),
          const SizedBox(width: 12),
          Text(
            '$count ITEMS RUNNING LOW',
            style: GoogleFonts.barlowCondensed(
                color: T2Colors.coral,
                fontWeight: FontWeight.w900,
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: T2Colors.bgDeep, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: T2Colors.textMuted, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search pantry...',
                hintStyle:
                    const TextStyle(color: T2Colors.textMuted, fontSize: 14),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(WidgetRef ref, String? selected) {
    final categories = [
      'All',
      'Grains',
      'Protein',
      'Dairy',
      'Vegetables',
      'Fruits',
      'Oils',
      'Spices',
      'Other'
    ];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(categories[index].toUpperCase(),
                style: GoogleFonts.barlowCondensed(
                    fontWeight: FontWeight.w800, fontSize: 12)),
            selected: selected == categories[index],
            onSelected: (val) => ref
                .read(inventoryCategoryFilterProvider.notifier)
                .state = categories[index],
            selectedColor: T2Colors.lime,
            backgroundColor: T2Colors.bgElevated,
            labelStyle: TextStyle(
                color: selected == categories[index]
                    ? Colors.black
                    : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildStockTile(
      BuildContext context, WidgetRef ref, InventoryItem item) {
    final isLow = item.isLowStock;
    final accent = _getCategoryColor(item.category);
    final icon = _getCategoryIcon(item.category);

    return _SlidableInventoryCard(
      item: item,
      onEdit: () => _showEditDialog(context, ref, item),
      onDelete: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: T2Colors.bgDeep,
            title: Text('DELETE ${item.ingredientName.toUpperCase()}?',
                style: GoogleFonts.barlowCondensed(
                    color: Colors.white, fontWeight: FontWeight.w900)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('CANCEL',
                      style: TextStyle(color: T2Colors.textMuted))),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('DELETE',
                      style: TextStyle(
                          color: T2Colors.coral, fontWeight: FontWeight.w900))),
            ],
          ),
        );
        if (result == true) {
          await ref.read(inventoryRepositoryProvider).deleteItem(item.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: T2Colors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isLow ? T2Colors.coral.withValues(alpha: 0.4) : T2Colors.border,
            width: isLow ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: accent, size: 20),
                ),
                if (isLow)
                  Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: T2Colors.coral, shape: BoxShape.circle)),
              ],
            ),
            const Spacer(),
            Text(
              item.ingredientName.toUpperCase(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity}${item.unit}',
              style: GoogleFonts.barlowCondensed(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isLow ? T2Colors.coral : T2Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isLow ? 'LOW STOCK' : 'IN STOCK',
              style: TextStyle(
                fontSize: 8,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
                color: isLow ? T2Colors.coral : T2Colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Protein':
        return T2Colors.coral;
      case 'Dairy':
        return T2Colors.sky;
      case 'Vegetables':
        return T2Colors.lime;
      case 'Fruits':
        return T2Colors.lime;
      case 'Grains':
        return T2Colors.amber;
      default:
        return T2Colors.textMuted;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Protein':
        return Icons.kebab_dining;
      case 'Dairy':
        return Icons.icecream;
      case 'Vegetables':
        return Icons.eco;
      case 'Fruits':
        return Icons.apple;
      case 'Grains':
        return Icons.grain;
      default:
        return Icons.inventory_2;
    }
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, InventoryItem item) {
    final controller = TextEditingController(text: item.quantity.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: T2Colors.bgDeep,
        title: Text('EDIT ${item.ingredientName.toUpperCase()}',
            style: GoogleFonts.barlowCondensed(
                color: Colors.white, fontWeight: FontWeight.w900)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              labelText: 'New Quantity',
              labelStyle: TextStyle(color: T2Colors.textMuted)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL',
                  style: TextStyle(color: T2Colors.textMuted))),
          TextButton(
            onPressed: () {
              ref
                  .read(inventoryRepositoryProvider)
                  .updateQuantity(item.id, double.parse(controller.text));
              Navigator.pop(context);
            },
            child: const Text('UPDATE',
                style: TextStyle(
                    color: T2Colors.lime, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _showAddItemSheet(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    String selectedUnit = 'g';
    String selectedCategory = 'Other';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: T2Colors.bgDeep,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ADD TO PANTRY',
                  style: GoogleFonts.barlowCondensed(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              const SizedBox(height: 20),
              _sheetInput(nameController, 'Ingredient Name'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: _sheetInput(qtyController, 'Quantity',
                          isNumber: true)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _sheetDropdown<String>(
                      value: selectedUnit,
                      items: ['g', 'kg', 'ml', 'L', 'pcs', 'cups'],
                      onChanged: (v) => setState(() => selectedUnit = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _sheetDropdown<String>(
                value: selectedCategory,
                items: [
                  'Grains',
                  'Protein',
                  'Dairy',
                  'Vegetables',
                  'Fruits',
                  'Oils',
                  'Spices',
                  'Other'
                ],
                onChanged: (v) => setState(() => selectedCategory = v!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        qtyController.text.isEmpty) return;
                    await ref.read(inventoryRepositoryProvider).addItem(
                          name: nameController.text,
                          quantity: double.parse(qtyController.text),
                          unit: selectedUnit,
                          category: selectedCategory,
                        );
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: T2Colors.lime,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('ADD TO PANTRY',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetInput(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: T2Colors.textMuted, fontSize: 12),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _sheetDropdown<T>(
      {required T value,
      required List<T> items,
      required ValueChanged<T?> onChanged}) {
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: T2Colors.bgDeep,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      items: items
          .map((i) => DropdownMenuItem(
              value: i,
              child: Text(i.toString(),
                  style: const TextStyle(color: Colors.white))))
          .toList(),
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

class _SlidableInventoryCardState extends State<_SlidableInventoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragOffset = 0;
  static const double _actionWidth = 60;
  static const double _totalActionWidth = _actionWidth * 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
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
                  color: T2Colors.sky,
                  child: const Center(
                      child: Icon(Icons.edit_rounded, color: Colors.white)),
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
                    color: T2Colors.coral,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                  ),
                  child: const Center(
                      child: Icon(Icons.delete_outline_rounded,
                          color: Colors.white)),
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
