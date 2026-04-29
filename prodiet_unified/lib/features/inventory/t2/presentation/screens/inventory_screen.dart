import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
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

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/t2/ocr'),
        backgroundColor: T2Colors.lime,
        label: const Text(
          'SCAN BILL',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.2),
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
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: T2Colors.bgDeep, borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: T2Colors.textMuted, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                            decoration: InputDecoration(
                              hintText: 'Search pantry...',
                              hintStyle: TextStyle(color: T2Colors.textMuted, fontSize: 14),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AsyncValueWidget<List<InventoryItem>>(
            value: inventoryAsync,
            skeleton: const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: T2Colors.amber))),
            isEmpty: (items) => items.isEmpty,
            emptyState: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'PANTRY EMPTY',
                    style: GoogleFonts.barlowCondensed(
                      color: T2Colors.textMuted,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            builder: (items) {
              final filtered = items.where((i) => i.ingredientName.toLowerCase().contains(_searchQuery)).toList();
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
                    (context, index) => _buildStockTile(context, ref, filtered[index]),
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

  Widget _buildStockTile(BuildContext context, WidgetRef ref, InventoryItem item) {
    final isLow = item.isLowStock;
    final accent = _getCategoryColor(item.category);
    final icon = _getCategoryIcon(item.category);

    return InkWell(
      onLongPress: () => _showEditDialog(context, ref, item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: T2Colors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLow ? T2Colors.coral.withValues(alpha: 0.4) : T2Colors.border,
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
                  decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: accent, size: 20),
                ),
                if (isLow) Container(width: 8, height: 8, decoration: const BoxDecoration(color: T2Colors.coral, shape: BoxShape.circle)),
              ],
            ),
            const Spacer(),
            Text(
              item.ingredientName.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
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
      case 'Protein': return T2Colors.coral;
      case 'Dairy': return T2Colors.sky;
      case 'Vegetables': return T2Colors.lime;
      case 'Fruits': return T2Colors.lime;
      case 'Grains': return T2Colors.amber;
      default: return T2Colors.textMuted;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Protein': return Icons.kebab_dining;
      case 'Dairy': return Icons.icecream;
      case 'Vegetables': return Icons.eco;
      case 'Fruits': return Icons.apple;
      case 'Grains': return Icons.grain;
      default: return Icons.inventory_2;
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, InventoryItem item) {
    final controller = TextEditingController(text: item.quantity.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: T2Colors.bgDeep,
        title: Text('EDIT ${item.ingredientName.toUpperCase()}', style: GoogleFonts.barlowCondensed(color: Colors.white, fontWeight: FontWeight.w900)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'New Quantity', labelStyle: TextStyle(color: T2Colors.textMuted)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: T2Colors.textMuted))),
          TextButton(
            onPressed: () {
              ref.read(inventoryRepositoryProvider).updateQuantity(item.id, double.parse(controller.text));
              Navigator.pop(context);
            },
            child: const Text('UPDATE', style: TextStyle(color: T2Colors.lime, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
