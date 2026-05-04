import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_notifier.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/core/widgets/loaders/ai_thinking_loader.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key});

  @override
  ConsumerState<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends ConsumerState<OcrScreen> {
  bool _isSaving = false;

  Future<void> _pickImage(ImageSource source) async {
    await ref.read(ocrNotifierProvider.notifier).pickImage(source);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ocrState = ref.watch(ocrNotifierProvider);

    if (ocrState is OcrScanning) {
      return const AiThinkingLoader(mode: 'ocr');
    }

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "BILL SCANNER",
          style: GoogleFonts.barlowCondensed(
              fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(context, theme, ocrState),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, OcrState state) {
    if (state is OcrIdle) {
      return _buildEmptyState(context);
    } else if (state is OcrResults) {
      return _buildResultsView(context, theme, state);
    } else if (state is OcrError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.message}',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            DmButton(
              label: "TRY AGAIN",
              onPressed: () =>
                  ref.read(ocrNotifierProvider.notifier).clearResults(),
            ),
          ],
        ),
      );
    } else if (state is OcrSaving) {
      return const Center(
          child: CircularProgressIndicator(color: T2Colors.lime));
    } else if (state is OcrSaved) {
      // In reality, it pops on success in the save logic, but as fallback:
      return const Center(
          child: Text("SAVED ✅", style: TextStyle(color: T2Colors.lime)));
    }
    return _buildEmptyState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProDietEmptyState(
            icon: EmptyStateConfigs.ocr.icon,
            headline: EmptyStateConfigs.ocr.headline.toUpperCase(),
            subtext: EmptyStateConfigs.ocr.subtext,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionBtn(
                      context, "CAMERA", Icons.camera_alt_rounded,
                      onTap: () => _pickImage(ImageSource.camera)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionBtn(
                      context, "GALLERY", Icons.photo_library_rounded,
                      onTap: () => _pickImage(ImageSource.gallery)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, String label, IconData icon,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: T2Colors.bgDeep,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: T2Colors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: T2Colors.lime, size: 32),
            const SizedBox(height: 12),
            Text(label,
                style: GoogleFonts.barlowCondensed(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView(
      BuildContext context, ThemeData theme, OcrResults result) {
    final userId = ref.watch(currentUserIdProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'FOUND ${result.items.length} ITEMS 🎉',
            style: GoogleFonts.barlowCondensed(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: T2Colors.lime),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: result.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = result.items[index];
              return DmCard(
                onTap: () => ref
                    .read(ocrNotifierProvider.notifier)
                    .toggleItemSelection(index),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: T2Colors.border),
                      child: Checkbox(
                        value: item.isSelected,
                        onChanged: (_) => ref
                            .read(ocrNotifierProvider.notifier)
                            .toggleItemSelection(index),
                        activeColor: T2Colors.lime,
                        checkColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name.toUpperCase(),
                              style: GoogleFonts.barlowCondensed(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          Text('${item.quantity} ${item.unit}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: T2Colors.textSecondary,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: T2Colors.lime.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(item.category.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: T2Colors.lime)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildBottomActions(context, result, userId),
      ],
    );
  }

  Widget _buildBottomActions(
      BuildContext context, OcrResults result, String userId) {
    final selectedCount = result.selectedCount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: T2Colors.bgDeep,
        border: Border(top: BorderSide(color: T2Colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DmButton(
            label: "ADD $selectedCount TO PANTRY",
            isLoading: _isSaving,
            onPressed: selectedCount > 0
                ? () async {
                    setState(() => _isSaving = true);
                    try {
                      await ref.read(ocrNotifierProvider.notifier).saveItems();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$selectedCount ITEMS ADDED ✅",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black)),
                          backgroundColor: T2Colors.lime,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("FAILED TO SAVE: $e",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                          backgroundColor: T2Colors.coral,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } finally {
                      if (mounted) setState(() => _isSaving = false);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                ref.read(ocrNotifierProvider.notifier).clearResults(),
            child: const Text(
              'SCAN AGAIN',
              style: TextStyle(
                  color: T2Colors.textMuted,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
