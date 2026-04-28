import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/domain/models/ocr_result.dart';
import '../widgets/scan_preview_box.dart';

class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key});

  @override
  ConsumerState<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends ConsumerState<OcrScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndProcess(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      await ref.read(ocrProvider.notifier).processBill(File(photo.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ocrState = ref.watch(ocrProvider);
    final isLoading = ocrState is AsyncLoading;

    // Listen for success/error
    ref.listen<AsyncValue<OcrResult?>>(ocrProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
        );
      }
    });
    
    final result = ocrState.asData?.value;
    final detectedItems = result?.detectedItems ?? [];

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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      Expanded(child: _buildSmallBtn(context, "Gallery", onTap: () => _pickAndProcess(ImageSource.gallery))),
                      const SizedBox(width: 8),
                      Expanded(child: _buildSmallBtn(context, "Capture", isPrimary: true, onTap: () => _pickAndProcess(ImageSource.camera))),
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
                      if (detectedItems.isNotEmpty)
                        Text(
                          "Edit all",
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                        ),
                    ],
                  ),
                ),

                if (detectedItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: DmCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          ...detectedItems.map((item) => _buildDetectedItem(context, {
                            'nm': item.name,
                            'qty': 'x${item.quantity.toInt()}',
                            'price': '₹${item.confidence > 0.8 ? "" : "?"}', // Simplified mock
                          })),
                        ],
                      ),
                    ),
                  )
                else if (!isLoading)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Opacity(
                        opacity: 0.5,
                        child: Text("No items scanned yet"),
                      ),
                    ),
                  ),

                if (detectedItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: DmButton(
                      label: "Update Inventory (${detectedItems.length} items)",
                      onPressed: () {
                        // Logic to commit to inventory
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Inventory updated!')),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSmallBtn(BuildContext context, String label, {bool isPrimary = false, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
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
