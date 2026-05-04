import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import '../../../application/shopping_providers.dart';
import '../../../domain/models/shopping_item.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final shoppingListAsync = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
              onPressed: () =>
                  ref.read(shoppingActionsProvider.notifier).clearPurchased(),
              icon: const Icon(Icons.delete_sweep_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        ],
      ),
      body: shoppingListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined,
                      size: 64,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                  const SizedBox(height: 16),
                  Text('Your list is empty',
                      style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          // Group by source (since category is missing in model)
          final Map<String, List<ShoppingItem>> grouped = {};
          for (var item in items) {
            (grouped[item.source] ??= []).add(item);
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(T1Spacing.md),
                  children: grouped.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: T1Spacing.lg),
                      child: _buildCategory(
                          context, ref, entry.key.toUpperCase(), entry.value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(T1Spacing.md),
                child: DmButton(
                  label: 'Generate from Low Stock',
                  onPressed: () async {
                    await ref
                        .read(shoppingActionsProvider.notifier)
                        .generateFromLowStock();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('List generated from low stock!')));
                    }
                  },
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategory(BuildContext context, WidgetRef ref, String title,
      List<ShoppingItem> items) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: T1Spacing.sm),
        ...items.map((item) => _buildItemTile(context, ref, item)),
      ],
    );
  }

  Widget _buildItemTile(
      BuildContext context, WidgetRef ref, ShoppingItem item) {
    final theme = Theme.of(context);
    return DmCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: item.isPurchased,
            onChanged: (val) {
              if (val != null) {
                ref
                    .read(shoppingActionsProvider.notifier)
                    .markPurchased(item.id, val);
              }
            },
            activeColor: theme.colorScheme.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.ingredientName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    decoration:
                        item.isPurchased ? TextDecoration.lineThrough : null,
                    color: item.isPurchased
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                        : null,
                  ),
                ),
                Text(
                  '${item.quantity} ${item.unit}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
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
