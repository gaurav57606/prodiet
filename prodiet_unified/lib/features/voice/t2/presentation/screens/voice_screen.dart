import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

class VoiceScreen extends ConsumerStatefulWidget {
  const VoiceScreen({super.key});

  @override
  ConsumerState<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends ConsumerState<VoiceScreen> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _detectedText = '"150g chicken breast"';
  final TextEditingController _typeController = TextEditingController();
  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    
    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                child: Text(
                  "Add Ingredients",
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 26),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(18),
                child: DmCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Voice input coming soon!'),
                              backgroundColor: T2Colors.purple,
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: primary.withValues(alpha: 0.3), width: 2),
                          ),
                          child: Icon(
                            _isListening ? Icons.stop : Icons.mic,
                            color: primary, size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AnimatedBuilder(
                        animation: _waveCtrl,
                        builder: (_, __) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(12, (i) {
                            const bases = [4.0, 8.0, 6.0, 12.0, 7.0, 10.0, 5.0, 9.0, 6.0, 11.0, 4.0, 8.0];
                            final h = _isListening
                              ? bases[i] + (_waveCtrl.value * bases[i] * 0.9)
                              : 4.0;
                            return Container(
                              width: 3, height: h,
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              decoration: BoxDecoration(
                                color: T2Colors.lime.withValues(alpha: _isListening ? 1.0 : 0.3),
                                borderRadius: BorderRadius.circular(2)),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _detectedText,
                        style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20, color: primary),
                      ),
                      Text(
                        _isListening ? "Listening..." : "Tap mic to start · Speak naturally",
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primary.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Detected: Chicken Breast 150g", style: theme.textTheme.labelLarge?.copyWith(color: primary, fontWeight: FontWeight.w700)),
                      Text("246 kcal · 46g protein · 0g carbs · 5g fat", style: theme.textTheme.bodySmall),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          final userId = ref.read(currentUserIdProvider);
                          await ref.read(inventoryRepositoryProvider).addItem(
                            userId, name: "Chicken Breast", quantity: 150, unit: 'g', category: 'Protein');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item added to pantry ✓')),
                            );
                          }
                        },
                        child: Text("Add to inventory ›", style: theme.textTheme.labelLarge?.copyWith(color: primary, fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("OR TYPE INSTEAD", style: T2TextStyles.sectionLabel(theme.colorScheme)),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.outline)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: DmTextField(
                        controller: _typeController,
                        hint: "Type ingredient + quantity...",
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        final text = _typeController.text.trim();
                        if (text.isEmpty) return;
                        final userId = ref.read(currentUserIdProvider);
                        await ref.read(inventoryRepositoryProvider).addItem(
                          userId, name: text, quantity: 1, unit: 'pcs', category: 'Other');
                        setState(() => _detectedText = '"$text"');
                        _typeController.clear();
                        FocusScope.of(context).unfocus();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$text added to pantry ✓'),
                              backgroundColor: T2Colors.lime,
                              behavior: SnackBarBehavior.floating));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text("Add", style: theme.textTheme.labelLarge?.copyWith(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Text("RECENTLY ADDED", style: T2TextStyles.sectionLabel(theme.colorScheme)),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: DmCard(
                  padding: EdgeInsets.zero,
                  child: Builder(builder: (context) {
                    final invAsync = ref.watch(inventoryStreamProvider);
                    return invAsync.when(
                      loading: () => const SizedBox(height: 48,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (items) {
                        final recent = items.take(5).toList();
                        if (recent.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text('No items yet — add some above',
                              style: const TextStyle(color: T2Colors.textMuted, fontSize: 12)),
                          );
                        }
                        return Column(
                          children: recent.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(children: [
                              const Icon(Icons.circle, size: 6, color: T2Colors.lime),
                              const SizedBox(width: 10),
                              Expanded(child: Text(item.ingredientName,
                                style: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w600, fontSize: 14))),
                              Text('${item.quantity.toInt()} ${item.unit}',
                                style: const TextStyle(color: T2Colors.textMuted, fontSize: 12)),
                            ]),
                          )).toList(),
                        );
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
