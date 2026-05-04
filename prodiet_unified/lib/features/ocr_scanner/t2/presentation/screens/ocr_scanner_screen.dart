import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
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

    return ocrState.when(
      data: (result) {
        if (result == null) {
          return Scaffold(
            backgroundColor: T2Colors.bgDefault,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('SCAN GROCERIES',
                  style:
                      GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProDietEmptyState(
                    emoji: '📷',
                    headline: 'SCAN YOUR GROCERIES',
                    subtext:
                        'Take a photo or upload from gallery to auto-detect ingredients.',
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: Text('CAMERA',
                                style: GoogleFonts.barlowCondensed(
                                    fontWeight: FontWeight.w900, fontSize: 18)),
                            onPressed: () async {
                              final picked = await ImagePicker().pickImage(
                                  source: ImageSource.camera, imageQuality: 80);
                              if (picked != null)
                                ref
                                    .read(ocrStateProvider.notifier)
                                    .scan(File(picked.path));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: T2Colors.lime,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.photo_library_rounded),
                            label: Text('GALLERY',
                                style: GoogleFonts.barlowCondensed(
                                    fontWeight: FontWeight.w900, fontSize: 18)),
                            onPressed: () async {
                              final picked = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 80);
                              if (picked != null)
                                ref
                                    .read(ocrStateProvider.notifier)
                                    .scan(File(picked.path));
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: T2Colors.border),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: T2Colors.bgDefault,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('FOUND ${result.itemCount} ITEMS',
                style:
                    GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900)),
            actions: [
              TextButton(
                onPressed: () => ref.read(ocrStateProvider.notifier).reset(),
                child: Text('SCAN AGAIN',
                    style: GoogleFonts.barlowCondensed(
                        color: T2Colors.lime, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: result.items.length,
                  itemBuilder: (context, index) {
                    final item = result.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: T2Colors.bgElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: item.isSelected
                                ? T2Colors.lime
                                : T2Colors.border),
                      ),
                      child: CheckboxListTile(
                        value: item.isSelected,
                        activeColor: T2Colors.lime,
                        checkColor: Colors.black,
                        onChanged: (_) => ref
                            .read(ocrStateProvider.notifier)
                            .toggleItemSelection(index),
                        title: Text(item.name.toUpperCase(),
                            style: GoogleFonts.barlowCondensed(
                                fontWeight: FontWeight.w900,
                                color: Colors.white)),
                        subtitle: Text('${item.quantity} ${item.unit}',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5))),
                        secondary: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(item.category.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: T2Colors.lime,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: T2Colors.bgElevated,
                    border: Border(top: BorderSide(color: T2Colors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${result.selectedCount} SELECTED',
                          style: GoogleFonts.barlowCondensed(
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: result.selectedCount == 0
                              ? null
                              : () async {
                                  final userId =
                                      ref.read(currentUserIdProvider);
                                  final repo =
                                      ref.read(inventoryRepositoryProvider);
                                  await repo.addItemsFromOcr(
                                    userId,
                                    result.selectedItems
                                        .map((item) => {
                                              "name": item.name,
                                              "quantity": item.quantity,
                                              "unit": item.unit,
                                              "category": item.category,
                                            })
                                        .toList(),
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${result.selectedCount} ITEMS ADDED ✅')),
                                    );
                                    context.pop();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: T2Colors.lime,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                          ),
                          child: Text('ADD TO PANTRY',
                              style: GoogleFonts.barlowCondensed(
                                  fontWeight: FontWeight.w900, fontSize: 16)),
                        ),
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
        backgroundColor: T2Colors.bgDefault,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: T2Colors.lime),
              const SizedBox(height: 24),
              Text(
                'READING YOUR GROCERIES...',
                style: GoogleFonts.barlowCondensed(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'AI IS IDENTIFYING INGREDIENTS',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: T2Colors.bgDefault,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('SCAN FAILED',
              style: GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900)),
        ),
        body: ProDietEmptyState(
          emoji: '⚠️',
          headline: 'SCAN FAILED',
          subtext: e.toString(),
          buttonLabel: 'TRY AGAIN',
          onButtonTap: () => ref.read(ocrStateProvider.notifier).reset(),
        ),
      ),
    );
  }
}
