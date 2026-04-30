import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  bool _isListening = false;
  String _detectedText = '"150g chicken breast"';
  final TextEditingController _typeController = TextEditingController();

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
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
                        onTap: () => setState(() => _isListening = !_isListening),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: primary.withOpacity(0.3), width: 2),
                          ),
                          child: Icon(
                            _isListening ? Icons.stop : Icons.mic,
                            color: primary, size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(12, (index) {
                          return Container(
                            width: 3,
                            height: 4 + (index % 4 * 4).toDouble(),
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
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
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Detected: Chicken Breast 150g", style: theme.textTheme.labelLarge?.copyWith(color: primary, fontWeight: FontWeight.w700)),
                      Text("246 kcal · 46g protein · 0g carbs · 5g fat", style: theme.textTheme.bodySmall),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Item added to pantry')),
                        ),
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
                      onTap: () {
                        if (_typeController.text.isNotEmpty) {
                          setState(() {
                            _detectedText = '"${_typeController.text}"';
                            _typeController.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to inventory')),
                          );
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
                  child: Column(
                    children: [
                      _buildRecentItem(context, '🥩', 'Chicken Breast', '200g', '328'),
                      _buildRecentItem(context, '🌾', 'Oats', '80g', '298'),
                      _buildRecentItem(context, '🥦', 'Broccoli', '100g', '34'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentItem(BuildContext context, String ico, String nm, String qty, String cal) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(ico, style: const TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(nm, style: theme.textTheme.titleMedium)),
          Text(qty, style: theme.textTheme.bodySmall),
          const SizedBox(width: 12),
          Text(cal, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 14, color: theme.colorScheme.primary)),
        ],
      ),
    );
  }
}
