import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_chip.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  final Set<String> _allergies = {};
  bool _mealVariety   = true;
  bool _onlineOrder   = true;
  bool _localVendors  = false;
  bool _fitbandSync   = true;
  int  _spiceLevel    = 3;
  bool _isSaving      = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user == null) return;
      setState(() {
        final stored = List<String>.from(user.allergies);
        _allergies.addAll(stored);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Preferences",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 26),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(context, "Allergies & Intolerances", [
              _buildAllergyChip('Dairy'),
              _buildAllergyChip('Tree Nuts'),
              _buildAllergyChip('Gluten'),
              _buildAllergyChip('Eggs'),
              _buildAllergyChip('Soy'),
              _buildAllergyChip('Shellfish'),
              _buildAllergyChip('Peanuts'),
              _buildAllergyChip('Fish'),
            ]),
            
            _buildSection(context, "Diet Type", [
              const DmChip(label: "Non-Vegetarian", isSelected: true, color: Color(0xFFB8FF00)),
              const DmChip(label: "Vegetarian", isSelected: false),
              const DmChip(label: "Vegan", isSelected: false),
              const DmChip(label: "Keto", isSelected: false),
              const DmChip(label: "Intermittent Fast", isSelected: false),
            ]),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text("General Settings", style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DmCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildPrefRow(context, "Spice level", trailing: _buildSpiceLevel(context)),
                    _buildPrefRow(context, "Meal variety", hasToggle: true, toggleValue: _mealVariety, 
                      onToggle: (v) => setState(() => _mealVariety = v)),
                    _buildPrefRow(context, "Online ordering", hasToggle: true, toggleValue: _onlineOrder, 
                      onToggle: (v) => setState(() => _onlineOrder = v)),
                    _buildPrefRow(context, "Local vendors", hasToggle: true, toggleValue: _localVendors, 
                      onToggle: (v) => setState(() => _localVendors = v)),
                    _buildPrefRow(context, "Fitband sync", hasToggle: true, toggleValue: _fitbandSync, 
                      onToggle: (v) => setState(() => _fitbandSync = v)),
                  ],
                ),
              ),
            ),

            _buildSection(context, "Cuisine Preferences", [
              const DmChip(label: "North Indian", isSelected: true, color: Color(0xFFB06EFF)),
              const DmChip(label: "Mediterranean", isSelected: true, color: Color(0xFFB06EFF)),
              const DmChip(label: "South Indian", isSelected: false),
              const DmChip(label: "Continental", isSelected: false),
              const DmChip(label: "Asian", isSelected: true, color: Color(0xFFB06EFF)),
              const DmChip(label: "Mexican", isSelected: false),
              const DmChip(label: "Middle Eastern", isSelected: false),
            ]),

            _buildSection(context, "Meal Frequency", [
              const DmChip(label: "3 meals", isSelected: false),
              const DmChip(label: "5 meals", isSelected: true, color: Color(0xFFB8FF00)),
              const DmChip(label: "6 meals", isSelected: false),
              const DmChip(label: "Intermittent", isSelected: false),
            ]),

            Padding(
              padding: const EdgeInsets.all(18),
              child: DmButton(
                label: "Save Preferences",
                isLoading: _isSaving,
                onPressed: _isSaving ? null : () async {
                  setState(() => _isSaving = true);
                  final user = ref.read(currentUserProvider);
                  if (user == null) { setState(() => _isSaving = false); return; }
                  await ref.read(authProvider.notifier).completeOnboarding(user.id, {
                    'allergies':       _allergies.toList(),
                    'spice_level':     _spiceLevel,
                    'meal_variety':    _mealVariety,
                    'online_ordering': _onlineOrder,
                    'local_vendors':   _localVendors,
                    'fitband_sync':    _fitbandSync,
                  });
                  setState(() => _isSaving = false);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preferences saved ✓')),
                    );
                  }
                },
                backgroundColor: const Color(0xFFB8FF00),
                textColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyChip(String label) {
    final sel = _allergies.contains(label);
    return DmChip(
      label: label,
      isSelected: sel,
      color: const Color(0xFFFF5C3A),
      onTap: () => setState(() => sel ? _allergies.remove(label) : _allergies.add(label)),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> chips) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: T2TextStyles.sectionLabel(theme.colorScheme)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: chips),
        ],
      ),
    );
  }

  Widget _buildPrefRow(BuildContext context, String lbl, {Widget? trailing, bool hasToggle = false, bool toggleValue = false, ValueChanged<bool>? onToggle}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outline))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lbl, style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
              if (!hasToggle && lbl == "Spice level") Text(_getSpiceLabel(), style: theme.textTheme.bodySmall),
            ],
          ),
          if (hasToggle) _buildToggle(context, toggleValue, onToggle) else if (trailing != null) trailing,
        ],
      ),
    );
  }

  String _getSpiceLabel() {
    switch (_spiceLevel) {
      case 1: return "Mild";
      case 2: return "Medium-Mild";
      case 3: return "Medium";
      case 4: return "Hot";
      case 5: return "Very Hot";
      default: return "Medium";
    }
  }

  Widget _buildToggle(BuildContext context, bool isOn, ValueChanged<bool>? onToggle) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onToggle?.call(!isOn),
      child: Container(
        width: 38,
        height: 20,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isOn ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }

  Widget _buildSpiceLevel(BuildContext context) {
    return Row(
      children: List.generate(5, (i) => GestureDetector(
        onTap: () => setState(() => _spiceLevel = i + 1),
        child: Container(
          width: 14, height: 14,
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: i < _spiceLevel ? T2Colors.lime : const Color(0xFF3A3A35),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      )),
    );
  }
}
