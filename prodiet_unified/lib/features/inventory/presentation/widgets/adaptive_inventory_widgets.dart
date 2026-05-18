import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/inventory/domain/inventory_item.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class AdaptiveInventoryTile extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdaptiveInventoryTile({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return _buildT2Tile(context);
    }

    return _buildT1Tile(context);
  }

  Widget _buildT1Tile(BuildContext context) {
    final tokens = context.tokens;
    return _SlidableInventoryCard(
      item: item,
      onEdit: onEdit,
      onDelete: onDelete,
      actionWidth: 80,
      editColor: Colors.blueAccent,
      deleteColor: tokens.colors.error,
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(item.ingredientName, style: tokens.typography.labelLarge.copyWith(fontWeight: FontWeight.w900)),
                      if (item.isLowStock) ...[
                        const SizedBox(width: 8),
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: tokens.colors.error, shape: BoxShape.circle)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: tokens.colors.onSurface.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4)),
                    child: Text(item.category.toUpperCase(), style: tokens.typography.bodySmall.copyWith(fontSize: 8, fontWeight: FontWeight.w900, color: tokens.colors.onSurface.withValues(alpha: 0.4))),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text('${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity}', style: tokens.typography.headlineSmall.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(width: 4),
                    Text(item.unit, style: tokens.typography.labelSmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.w900)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildT2Tile(BuildContext context) {
    final tokens = context.tokens;
    final isLow = item.isLowStock;
    final accent = _getCategoryColor(context, item.category);
    final icon = _getCategoryIcon(item.category);

    return _SlidableInventoryCard(
      item: item,
      onEdit: onEdit,
      onDelete: onDelete,
      actionWidth: 60,
      editColor: tokens.colors.secondary,
      deleteColor: tokens.colors.error,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tokens.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLow ? tokens.colors.error.withValues(alpha: 0.4) : tokens.colors.outline.withValues(alpha: 0.1),
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
                if (isLow) Container(width: 8, height: 8, decoration: BoxDecoration(color: tokens.colors.error, shape: BoxShape.circle)),
              ],
            ),
            const Spacer(),
            Text(
              item.ingredientName.toUpperCase(),
              style: tokens.typography.labelSmall.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.colors.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity}${item.unit}',
              style: tokens.typography.displaySmall.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isLow ? tokens.colors.error : tokens.colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isLow ? 'LOW STOCK' : 'IN STOCK',
              style: tokens.typography.labelSmall.copyWith(
                fontSize: 8,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
                color: isLow ? tokens.colors.error : tokens.colors.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(BuildContext context, String category) {
    final tokens = context.tokens;
    switch (category) {
      case 'Protein': return tokens.colors.error;
      case 'Dairy': return tokens.colors.secondary;
      case 'Vegetables': return tokens.colors.primary;
      case 'Fruits': return tokens.colors.primary;
      case 'Grains': return tokens.colors.carbs;
      default: return tokens.colors.onSurface.withValues(alpha: 0.4);
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
}

class _SlidableInventoryCard extends StatefulWidget {
  final Widget child;
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double actionWidth;
  final Color editColor;
  final Color deleteColor;

  const _SlidableInventoryCard({
    required this.child,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.actionWidth,
    required this.editColor,
    required this.deleteColor,
  });

  @override
  State<_SlidableInventoryCard> createState() => _SlidableInventoryCardState();
}

class _SlidableInventoryCardState extends State<_SlidableInventoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragOffset = 0;
  double get _totalActionWidth => widget.actionWidth * 2;

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
                  width: widget.actionWidth,
                  color: widget.editColor,
                  child: const Center(child: Icon(Icons.edit_rounded, color: Colors.white)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onDelete();
                  setState(() => _dragOffset = 0);
                },
                child: Container(
                  width: widget.actionWidth,
                  decoration: BoxDecoration(
                    color: widget.deleteColor,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                  ),
                  child: const Center(child: Icon(Icons.delete_outline_rounded, color: Colors.white)),
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
