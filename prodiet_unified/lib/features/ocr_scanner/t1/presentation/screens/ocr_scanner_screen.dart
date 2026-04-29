import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/domain/ocr_result.dart';

class OcrScannerScreen extends ConsumerWidget {
  const OcrScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrState = ref.watch(ocrStateProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ocrState.when(
      data: (result) {
        if (result == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Scan Groceries')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProDietEmptyState(
                    emoji: '📷',
                    headline: 'Scan Your Groceries',
                    subtext: 'Take a photo or upload from gallery to auto-detect ingredients.',
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: const Text('Camera'),
                        onPressed: () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            imageQuality: 80,
                          );
                          if (picked != null) {
                            ref.read(ocrStateProvider.notifier).scan(File(picked.path));
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo_library_rounded),
                        label: const Text('Gallery'),
                        onPressed: () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (picked != null) {
                            ref.read(ocrStateProvider.notifier).scan(File(picked.path));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Found ${result.itemCount} items'),
            actions: [
              TextButton(
                onPressed: () => ref.read(ocrStateProvider.notifier).reset(),
                child: const Text('Scan Again'),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: result.items.length,
                  itemBuilder: (context, index) {
                    final item = result.items[index];
                    return CheckboxListTile(
                      value: item.isSelected,
                      onChanged: (_) => ref.read(ocrStateProvider.notifier).toggleItemSelection(index),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.quantity} ${item.unit}'),
                      secondary: Chip(
                        label: Text(
                          item.category,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(T1Spacing.lg),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${result.selectedCount} selected',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: result.selectedCount == 0
                            ? null
                            : () async {
                                final userId = ref.read(currentUserIdProvider);
                                final repo = ref.read(inventoryRepositoryProvider);
                                for (final item in result.selectedItems) {
                                  await repo.addItem(
                                    userId,
                                    name: item.name,
                                    quantity: item.quantity,
                                    unit: item.unit,
                                    category: item.category,
                                  );
                                }
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${result.selectedCount} items added ✅')),
                                  );
                                  context.pop();
                                }
                              },
                        child: const Text('Add to Pantry'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: scheme.primary),
              const SizedBox(height: 24),
              const Text('Reading your groceries...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'AI is identifying ingredients',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('Scan Failed')),
        body: ProDietEmptyState(
          emoji: '⚠️',
          headline: 'Scan Failed',
          subtext: e.toString(),
          buttonLabel: 'Try Again',
          onButtonTap: () => ref.read(ocrStateProvider.notifier).reset(),
        ),
      ),
    );
  }
}
