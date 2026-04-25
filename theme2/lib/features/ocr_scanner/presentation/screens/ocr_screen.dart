import 'package:flutter/material.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import 'package:dietmate_pro/shared/widgets/dm_button.dart';
import '../widgets/scan_preview_box.dart';

class OcrScreen extends StatelessWidget {
  const OcrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final detectedItems = [
      {'nm': 'Skimmed Milk 1L', 'qty': '×2', 'price': '₹96'},
      {'nm': 'Paneer 200g', 'qty': '×1', 'price': '₹58'},
      {'nm': 'Almonds 100g', 'qty': '×1', 'price': '₹180'},
      {'nm': 'Oats 500g', 'qty': '×1', 'price': '₹95'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan Bill",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 22),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(
                "Point camera at your grocery bill · Items auto-detected",
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            const ScanPreviewBox(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  Expanded(child: _buildSmallBtn(context, "Gallery")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSmallBtn(context, "Capture", isPrimary: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSmallBtn(context, "Torch")),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Detected Items", style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                  Text(
                    "Edit all",
                    style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DmCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ...detectedItems.map((item) => _buildDetectedItem(context, item)),
                    // Unrecognized item
                    _buildDetectedItem(context, {
                      'nm': 'Unrecognised item', 
                      'qty': '—', 
                      'price': '₹45'
                    }, isUnrecognized: true),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: DmButton(
                label: "Update Inventory (4 items)",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallBtn(BuildContext context, String label, {bool isPrimary = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: isPrimary ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: isPrimary ? null : Border.all(color: theme.colorScheme.outline),
      ),
      child: Center(
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isPrimary ? Colors.black : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildDetectedItem(BuildContext context, Map<String, String> item, {bool isUnrecognized = false}) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: isUnrecognized ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isUnrecognized ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                isUnrecognized ? Icons.close : Icons.check, 
                size: 10, 
                color: isUnrecognized ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.primary
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(item['nm']!, style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
            ),
            Text(
              item['qty']!,
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: 12),
            Text(
              item['price']!,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 14,
                color: isUnrecognized ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
