import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/domain/ocr_result.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/core/widgets/loaders/ai_thinking_loader.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class OcrScannerScreen extends ConsumerWidget {
  const OcrScannerScreen({super.key});

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      await ref.read(ocrStateProvider.notifier).scan(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ocrAsync = ref.watch(ocrStateProvider);
    final isScanning = ref.watch(isScanningProvider);

    if (isScanning) {
      return const AiThinkingLoader(mode: 'ocr');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SCAN GROCERY BILL'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: ocrAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (result) {
          if (result == null) {
            return _buildEmptyState(context, ref);
          }
          return _buildResultsView(context, ref, theme, result);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProDietEmptyState(
          emoji: EmptyStateConfigs.ocr.emoji,
          headline: EmptyStateConfigs.ocr.headline,
          subtext: EmptyStateConfigs.ocr.subtext,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: T1Spacing.xl),
          child: Row(
            children: [
              Expanded(
                child: DmButton(
                  label: 'CAMERA',
                  icon: Icons.camera_alt_rounded,
                  onPressed: () => _pickImage(ref, ImageSource.camera),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DmButton(
                  label: 'GALLERY',
                  icon: Icons.photo_library_rounded,
                  variant: DmButtonVariant.outline,
                  onPressed: () => _pickImage(ref, ImageSource.gallery),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsView(BuildContext context, WidgetRef ref, ThemeData theme, OcrResult result) {
    final userId = ref.watch(currentUserIdProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(T1Spacing.lg),
          child: Text(
            'Found ${result.itemCount} items 🎉',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
            itemCount: result.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = result.items[index];
              return DmCard(
                onTap: () => ref.read(ocrStateProvider.notifier).toggleItemSelection(index),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Checkbox(
                      value: item.isSelected,
                      onChanged: (_) => ref.read(ocrStateProvider.notifier).toggleItemSelection(index),
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text('${item.quantity} ${item.unit}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                    _categoryChip(theme, item.category),
                  ],
                ),
              );
            },
          ),
        ),
        _buildBottomBar(context, ref, theme, result, userId),
      ],
    );
  }

  Widget _categoryChip(ThemeData theme, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, ThemeData theme, OcrResult result, String userId) {
    final selectedCount = result.selectedCount;

    return Container(
      padding: const EdgeInsets.all(T1Spacing.lg),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selectedCount > 0 ? () async {
                final itemsToAdd = result.selectedItems.map((i) => {
                  'name': i.name,
                  'quantity': i.quantity,
                  'unit': i.unit,
                  'category': i.category,
                }).toList();
                
                await ref.read(inventoryRepositoryProvider).addItemsFromOcr(userId, itemsToAdd);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$selectedCount items added ✅', style: const TextStyle(fontWeight: FontWeight.w900)),
                      backgroundColor: const Color(0xFF40D8B8),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'ADD $selectedCount TO PANTRY',
                style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.read(ocrStateProvider.notifier).reset(),
            child: Text(
              'SCAN AGAIN',
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
