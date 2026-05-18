import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_notifier.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/presentation/widgets/adaptive_ocr_widgets.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/core/widgets/loaders/ai_thinking_loader.dart';
import 'package:go_router/go_router.dart';

class OcrScannerScreen extends ConsumerStatefulWidget {
  const OcrScannerScreen({super.key});

  @override
  ConsumerState<OcrScannerScreen> createState() => _OcrScannerScreenState();
}

class _OcrScannerScreenState extends ConsumerState<OcrScannerScreen> {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final ocrState = ref.watch(ocrNotifierProvider);

    ref.listen<OcrState>(ocrNotifierProvider, (previous, next) {
      if (next is OcrSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isT2 ? 'ITEMS ADDED TO PANTRY ✅' : 'Items added to pantry ✅',
              style: isT2 ? GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900, color: Colors.black) : null),
            backgroundColor: isT2 ? tokens.colors.primary : null,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      } else if (next is OcrError && previous is OcrResults) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: tokens.colors.error,
          ),
        );
      }
    });

    if (ocrState is OcrScanning) {
      return const AiThinkingLoader(mode: 'ocr');
    }

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'BILL SCANNER' : 'Scan Groceries'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface,
          letterSpacing: 1.2,
        ) : null,
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(context, ocrState),
    );
  }

  Widget _buildBody(BuildContext context, OcrState state) {
    if (state is OcrIdle) {
      return _buildIdleView(context);
    } else if (state is OcrResults) {
      return _buildResultsView(context, state);
    } else if (state is OcrError) {
      return _buildErrorView(context, state.message);
    } else if (state is OcrSaving) {
      return Center(child: CircularProgressIndicator(color: context.tokens.colors.primary));
    }
    return _buildIdleView(context);
  }

  Widget _buildIdleView(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProDietEmptyState(
            icon: EmptyStateConfigs.ocr.icon,
            headline: isT2 ? EmptyStateConfigs.ocr.headline.toUpperCase() : EmptyStateConfigs.ocr.headline,
            subtext: EmptyStateConfigs.ocr.subtext,
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: AdaptiveOcrActionBtn(
                    label: 'Camera',
                    icon: Icons.camera_alt_rounded,
                    onTap: () => ref.read(ocrNotifierProvider.notifier).pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdaptiveOcrActionBtn(
                    label: 'Gallery',
                    icon: Icons.photo_library_rounded,
                    onTap: () => ref.read(ocrNotifierProvider.notifier).pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context, OcrResults result) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            isT2 ? 'FOUND ${result.items.length} ITEMS 🎉' : 'Found ${result.items.length} items',
            style: isT2 ? GoogleFonts.barlowCondensed(
              fontSize: 40, 
              fontWeight: FontWeight.w900, 
              color: tokens.colors.primary
            ) : tokens.typography.headlineSmall.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: result.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = result.items[index];
              return AdaptiveOcrResultTile(
                name: item.name,
                quantity: item.quantity.toString(),
                unit: item.unit,
                category: item.category,
                isSelected: item.isSelected,
                onTap: () => ref.read(ocrNotifierProvider.notifier).toggleItemSelection(index),
              );
            },
          ),
        ),
        _buildBottomActions(context, result),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, OcrResults result) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final selectedCount = result.selectedCount;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.1))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: selectedCount > 0 ? () => ref.read(ocrNotifierProvider.notifier).saveItems() : null,
              style: isT2 ? FilledButton.styleFrom(
                backgroundColor: tokens.colors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ) : null,
              child: Text(
                isT2 ? 'ADD $selectedCount TO PANTRY' : 'Add $selectedCount items',
                style: isT2 ? GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900, fontSize: 18) : null,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => ref.read(ocrNotifierProvider.notifier).clearResults(),
            child: Text(
              isT2 ? 'SCAN AGAIN' : 'Scan Again',
              style: isT2 ? GoogleFonts.barlowCondensed(
                color: tokens.colors.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return ProDietEmptyState(
      icon: Icons.error_outline_rounded,
      headline: 'Scan Failed',
      subtext: message,
      buttonLabel: 'Try Again',
      onButtonTap: () => ref.read(ocrNotifierProvider.notifier).clearResults(),
    );
  }
}
