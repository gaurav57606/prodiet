import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/shopping_list/application/shopping_providers.dart';
import 'package:prodiet_unified/features/shopping_list/domain/models/shopping_item.dart';
import 'package:prodiet_unified/features/shopping_list/presentation/widgets/adaptive_shopping_widgets.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final shoppingListAsync = ref.watch(shoppingListProvider);

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'MARKET LIST' : 'Shopping List'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(shoppingActionsProvider.notifier).clearPurchased(), 
            icon: const Icon(Icons.delete_sweep_rounded)
          ),
        ],
      ),
      body: shoppingListAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: tokens.colors.primary)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 64, color: tokens.colors.onSurface.withValues(alpha: 0.1)),
                  const SizedBox(height: 16),
                  Text(
                    'Your list is empty', 
                    style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            );
          }

          final Map<String, List<ShoppingItem>> grouped = {};
          for (var item in items) {
            (grouped[item.source] ??= []).add(item);
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: grouped.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildCategory(context, ref, entry.key.toUpperCase(), entry.value),
                    );
                  }).toList(),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  label: isT2 ? 'SYNC FROM INVENTORY' : 'Generate from Low Stock',
                  onPressed: () async {
                    await ref.read(shoppingActionsProvider.notifier).generateFromLowStock();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('List generated from low stock!')));
                    }
                  },
                  isFullWidth: true,
                  backgroundColor: tokens.colors.primary,
                ),
              ),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategory(BuildContext context, WidgetRef ref, String title, List<ShoppingItem> items) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelLarge).copyWith(
            color: tokens.colors.onSurface.withValues(alpha: 0.25),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => AdaptiveShoppingItemTile(
          item: item,
          onToggle: (val) {
            if (val != null) {
              ref.read(shoppingActionsProvider.notifier).markPurchased(item.id, val);
            }
          },
        )),
      ],
    );
  }
}
