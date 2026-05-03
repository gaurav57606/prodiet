import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_notifier.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_providers.dart';

class OcrScannerScreen extends ConsumerWidget {
  const OcrScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrState = ref.watch(ocrNotifierProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    ref.listen<OcrState>(ocrNotifierProvider, (previous, next) {
      if (next is OcrSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Items added to pantry ✅')),
        );
        context.pop();
      } else if (next is OcrError && previous is OcrResults) {
        // If error happens while saving, show a snackbar instead of an error screen
        // so the user doesn't lose their scanned items list.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: scheme.error),
        );
      }
    });

    switch (ocrState) {
      case OcrIdle():
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
                      onPressed: () => ref.read(ocrNotifierProvider.notifier).pickImage(ImageSource.camera),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library_rounded),
                      label: const Text('Gallery'),
                      onPressed: () => ref.read(ocrNotifierProvider.notifier).pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case OcrScanning():
      case OcrSaving():
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: scheme.primary),
                const SizedBox(height: 24),
                Text(
                  ocrState is OcrSaving ? 'Saving to pantry...' : 'Reading your groceries...',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  ocrState is OcrSaving ? 'Almost done' : 'AI is identifying ingredients',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        );

      case OcrResults(items: final items):
        final selectedCount = ocrState.selectedCount;
        return Scaffold(
          appBar: AppBar(
            title: Text('Found ${items.length} items'),
            actions: [
              TextButton(
                onPressed: () => ref.read(ocrNotifierProvider.notifier).clearResults(),
                child: const Text('Scan Again'),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CheckboxListTile(
                      value: item.isSelected,
                      onChanged: (_) => ref.read(ocrNotifierProvider.notifier).toggleItemSelection(index),
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
                          '$selectedCount selected',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: selectedCount == 0
                            ? null
                            : () => ref.read(ocrNotifierProvider.notifier).saveItems(),
                        child: const Text('Add to Pantry'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case OcrError(message: final msg):
        return Scaffold(
          appBar: AppBar(title: const Text('Scan Failed')),
          body: ProDietEmptyState(
            emoji: '⚠️',
            headline: 'Scan Failed',
            subtext: msg,
            buttonLabel: 'Try Again',
            onButtonTap: () => ref.read(ocrNotifierProvider.notifier).clearResults(),
          ),
        );
      
      case OcrSaved():
        // Handled by ref.listen
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
