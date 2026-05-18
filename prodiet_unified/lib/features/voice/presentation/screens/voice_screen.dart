import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/voice/presentation/widgets/adaptive_voice_widgets.dart';
import 'package:prodiet_unified/features/voice/application/voice_input_parser.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';

class VoiceScreen extends ConsumerStatefulWidget {
  const VoiceScreen({super.key});

  @override
  ConsumerState<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends ConsumerState<VoiceScreen> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _detectedText = '"Tap mic or select a preset below"';
  List<ParsedVoiceItem> _parsedItems = [];
  Timer? _dictationTimer;

  final List<String> _presets = [
    "3 eggs and 2 slices of whole wheat bread",
    "150g chicken breast",
    "2 avocados and 1 carton of organic eggs",
    "1 scoop of protein powder and 250ml milk",
    "250g greek yogurt and blueberries"
  ];

  final TextEditingController _typeController = TextEditingController();
  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 700)
    );
  }

  @override
  void dispose() {
    _dictationTimer?.cancel();
    _waveCtrl.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _startSimulatedDictation(String phrase) {
    _dictationTimer?.cancel();
    setState(() {
      _isListening = true;
      _parsedItems = [];
      _detectedText = '""';
    });
    _waveCtrl.repeat(reverse: true);

    int index = 0;
    const duration = Duration(milliseconds: 30);
    _dictationTimer = Timer.periodic(duration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      index++;
      if (index <= phrase.length) {
        setState(() {
          _detectedText = '"${phrase.substring(0, index)}"';
        });
      } else {
        timer.cancel();
        _waveCtrl.stop();
        setState(() {
          _isListening = false;
          _parsedItems = VoiceInputParser.parsePhrase(phrase);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    
    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'VOICE ASSISTANT' : 'Add Ingredients'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isT2) ...[
                Text(
                  'Add via Voice',
                  style: tokens.typography.headlineMedium.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Speak ingredients and quantities naturally',
                  style: tokens.typography.bodyMedium.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 32),
              ],

              _buildVoicePanel(context),
              const SizedBox(height: 16),
              _buildPresetChips(context),
              const SizedBox(height: 32),

              _buildDetectionCard(context),
              const SizedBox(height: 48),

              _buildTypeDivider(context),
              const SizedBox(height: 24),

              _buildTypeInput(context),
              const SizedBox(height: 48),

              _buildSectionLabel(context, 'RECENTLY ADDED'),
              const SizedBox(height: 16),
              _buildRecentItemsGroup(context),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoicePanel(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          AdaptiveMicButton(
            isListening: _isListening,
            onTap: () {
              if (_isListening) {
                _dictationTimer?.cancel();
                _waveCtrl.stop();
                setState(() {
                  _isListening = false;
                  _detectedText = '"150g chicken breast"';
                  _parsedItems = VoiceInputParser.parsePhrase("150g chicken breast");
                });
              } else {
                final randomPreset = _presets[(DateTime.now().millisecond) % _presets.length];
                _startSimulatedDictation(randomPreset);
              }
            },
          ),
          const SizedBox(height: 32),
          AdaptiveVoiceWaveform(
            isListening: _isListening,
            animation: _waveCtrl,
          ),
          const SizedBox(height: 24),
          Text(
            _detectedText,
            textAlign: TextAlign.center,
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 28) : tokens.typography.headlineSmall).copyWith(
              fontWeight: FontWeight.w900,
              color: tokens.colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isT2 ? 'TAP MIC TO START · SPEAK NATURALLY' : 'Tap mic to start · Speak naturally',
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChips(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            isT2 ? 'TRY SAYING / PRESETS:' : 'Try saying / Presets:',
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _presets.length,
            itemBuilder: (context, idx) {
              final preset = _presets[idx];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  onPressed: _isListening ? null : () => _startSimulatedDictation(preset),
                  backgroundColor: tokens.colors.surfaceContainerLowest,
                  disabledColor: tokens.colors.surfaceContainerLowest.withValues(alpha: 0.5),
                  side: BorderSide(
                    color: tokens.colors.outline.withValues(alpha: 0.1),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    isT2 ? preset.toUpperCase() : preset,
                    style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
                      color: tokens.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetectionCard(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (_parsedItems.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: tokens.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Icon(Icons.insights_rounded, size: 32, color: tokens.colors.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              isT2 ? 'NO ACTIVE DICTATION' : 'No active dictation',
              style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.titleMedium).copyWith(
                fontWeight: FontWeight.bold,
                color: tokens.colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isT2 ? 'SELECT A PRESET ABOVE OR TAP THE MIC TO TEST VOICE INPUT' : 'Select a preset above or tap the mic to test voice input',
              textAlign: TextAlign.center,
              style: tokens.typography.labelSmall.copyWith(
                color: tokens.colors.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: tokens.colors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 20, color: tokens.colors.primary),
              const SizedBox(width: 8),
              Text(
                isT2 ? 'PARSED INGREDIENTS' : 'Parsed Ingredients',
                style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 18) : tokens.typography.titleMedium).copyWith(
                  color: tokens.colors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._parsedItems.map((item) {
            Color categoryColor;
            switch (item.category) {
              case 'Protein':
                categoryColor = Colors.orange;
                break;
              case 'Carbs':
                categoryColor = Colors.green;
                break;
              case 'Fats':
                categoryColor = Colors.blue;
                break;
              case 'Dairy':
                categoryColor = Colors.purple;
                break;
              case 'Produce':
                categoryColor = Colors.teal;
                break;
              default:
                categoryColor = Colors.grey;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 32,
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isT2 ? item.name.toUpperCase() : item.name,
                          style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 15) : tokens.typography.titleSmall).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity} ${item.unit}',
                          style: tokens.typography.labelSmall.copyWith(
                            color: tokens.colors.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: categoryColor.withValues(alpha: 0.3), width: 1),
                    ),
                    child: Text(
                      isT2 ? item.category.toUpperCase() : item.category,
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: categoryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.white12),
          const SizedBox(height: 16),
          InkWell(
            onTap: _handleAddItem,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              width: double.infinity,
              decoration: BoxDecoration(
                color: tokens.colors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  isT2 ? 'CONFIRM & ADD TO PANTRY ›' : 'Confirm & Add to Pantry ›',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAddItem() async {
    if (_parsedItems.isEmpty) return;
    final userId = ref.read(currentUserIdProvider);
    final repo = ref.read(inventoryRepositoryProvider);

    for (var item in _parsedItems) {
      await repo.addItem(
        userId, 
        name: item.name, 
        quantity: item.quantity, 
        unit: item.unit, 
        category: item.category,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tokens.colors.primary == Colors.orange 
              ? 'ADDED ${_parsedItems.length} ITEMS TO PANTRY ✓'
              : 'Added ${_parsedItems.length} items to pantry ✓'),
          backgroundColor: context.tokens.colors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _parsedItems = [];
        _detectedText = '"Tap mic or select a preset below"';
      });
    }
  }

  Widget _buildTypeDivider(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Row(
      children: [
        Expanded(child: Divider(color: tokens.colors.outline.withValues(alpha: 0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            isT2 ? 'OR TYPE INSTEAD' : 'Or type instead',
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.3),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: tokens.colors.outline.withValues(alpha: 0.1))),
      ],
    );
  }

  Widget _buildTypeInput(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: _typeController,
            hint: isT2 ? 'TYPE INGREDIENT...' : 'Type ingredient...',
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleManualAdd(),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: _handleManualAdd,
            style: isT2 ? FilledButton.styleFrom(
              backgroundColor: tokens.colors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ) : null,
            child: Text(
              isT2 ? 'ADD' : 'Add',
              style: isT2 ? GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900) : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleManualAdd() async {
    final text = _typeController.text.trim();
    if (text.isEmpty) return;
    
    final parsed = VoiceInputParser.parsePhrase(text);
    if (parsed.isEmpty) return;

    setState(() {
      _detectedText = '"$text"';
      _parsedItems = parsed;
    });

    _typeController.clear();
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tokens.colors.primary == Colors.orange 
            ? 'INGREDIENTS PARSED - REVIEW PREVIEW'
            : 'Ingredients parsed - review preview'),
        backgroundColor: context.tokens.colors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String title) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Text(
      title,
      style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelSmall).copyWith(
        color: tokens.colors.onSurface.withValues(alpha: 0.3),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildRecentItemsGroup(BuildContext context) {
    final tokens = context.tokens;
    final invAsync = ref.watch(inventoryStreamProvider);

    return Container(
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
      ),
      child: invAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, s) => const SizedBox.shrink(),
        data: (items) {
          final recent = items.take(5).toList();
          if (recent.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No items yet')),
            );
          }
          return Column(
            children: recent.asMap().entries.map((entry) {
              final item = entry.value;
              final isLast = entry.key == recent.length - 1;
              return _buildRecentItemTile(context, item.ingredientName, '${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity} ${item.unit}', isLast);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildRecentItemTile(BuildContext context, String name, String qty, bool isLast) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: tokens.colors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isT2 ? name.toUpperCase() : name,
              style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.titleSmall).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            qty,
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
              color: tokens.colors.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
