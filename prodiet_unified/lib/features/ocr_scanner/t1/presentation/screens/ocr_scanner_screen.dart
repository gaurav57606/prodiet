import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/features/ocr_scanner/application/ocr_providers.dart';
import 'package:prodiet_unified/features/ocr_scanner/domain/models/ocr_result.dart';

class OcrScannerScreen extends ConsumerStatefulWidget {
  const OcrScannerScreen({super.key});

  @override
  ConsumerState<OcrScannerScreen> createState() => _OcrScannerScreenState();
}

class _OcrScannerScreenState extends ConsumerState<OcrScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      await ref.read(ocrProvider.notifier).processBill(File(photo.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ocrState = ref.watch(ocrProvider);
    final isLoading = ocrState is AsyncLoading;

    // Listen for success
    ref.listen<AsyncValue<OcrResult?>>(ocrProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        final result = next.value!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanned: ${result.detectedItems.length} items found')),
        );
        Navigator.pop(context, result);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Mock Camera View
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF101010), Color(0xFF202020)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.camera_alt_rounded, color: Colors.white12, size: 80),
            ),
          ),
          
          // Scanner Overlay
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(T1Spacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                      ),
                      const Text(
                        'SCAN NUTRITION LABEL',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                
                // Scanning Box
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.5), width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: _controller.value * 180,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Instructions
                Container(
                  padding: const EdgeInsets.all(T1Spacing.xl),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLoading ? 'Analyzing label...' : 'Align the nutrition table within the box',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: T1Spacing.lg),
                      DmButton(
                        label: isLoading ? 'Processing...' : 'Capture & Analyze',
                        onPressed: isLoading ? null : _captureAndAnalyze,
                        width: double.infinity,
                      ),
                    ],
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
}
