import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/features/inventory/presentation/widgets/inventory_grid.dart';
import 'package:dietmate_pro/features/inventory/presentation/widgets/reorder_banner.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import 'package:dietmate_pro/shared/widgets/dm_chip.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kitchen Stock",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Manage your pantry and grocery stock auto-synced from bills.",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 10),
                  DmChip(
                    label: "Scan Bill", 
                    isSelected: true,
                    onTap: () => context.pushNamed('ocr'),
                  ),
                ],
              ),
            ),
            
            const ReorderBanner(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text("In Stock (12 items)", style: theme.textTheme.titleMedium),
            ),
            
            const InventoryGrid(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
