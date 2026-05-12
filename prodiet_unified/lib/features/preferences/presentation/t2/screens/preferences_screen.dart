import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_chip.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/preferences/application/preferences_providers.dart';
import 'package:prodiet_unified/features/preferences/application/preferences_state.dart';
import 'package:prodiet_unified/features/preferences/domain/user_preferences.dart';
import 'package:prodiet_unified/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  final Set<String> _allergies = {};
  bool _mealVariety = true;
  bool _onlineOrder = true;
  bool _localVendors = false;
  bool _fitbandSync = true;
  bool _notifications = true;
  int _spiceLevel = 3;
  String _dietType = "Non-Vegetarian";
  final Set<String> _cuisines = {"North Indian", "Mediterranean", "Asian"};
  int _mealsCount = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref.read(preferencesNotifierProvider.notifier).loadPreferences(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(preferencesNotifierProvider);
    final isSaving = state is PreferencesSaving;
    final isLoading = state is PreferencesLoading;

    ref.listen<PreferencesState>(preferencesNotifierProvider, (previous, next) {
      if (next is PreferencesLoaded) {
        setState(() {
          _allergies.clear();
          _allergies.addAll(next.prefs.allergies);
          _dietType = next.prefs.dietType;
          _spiceLevel = next.prefs.spiceLevel;
          _mealVariety = next.prefs.mealVariety;
          _onlineOrder = next.prefs.onlineOrdering;
          _localVendors = next.prefs.localVendors;
          _fitbandSync = next.prefs.fitbandSync;
          _notifications = next.prefs.notifications;
          _cuisines.clear();
          _cuisines.addAll(next.prefs.cuisinePrefs);
          _mealsCount = next.prefs.mealsPerDay;
        });
      } else if (next is PreferencesSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved ✓')),
        );
      } else if (next is PreferencesError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

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
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              _buildChoiceChip("Non-Vegetarian", _dietType, (v) => setState(() => _dietType = v), color: const Color(0xFFB8FF00)),
              _buildChoiceChip("Vegetarian", _dietType, (v) => setState(() => _dietType = v)),
              _buildChoiceChip("Vegan", _dietType, (v) => setState(() => _dietType = v)),
              _buildChoiceChip("Keto", _dietType, (v) => setState(() => _dietType = v)),
              _buildChoiceChip("Intermittent Fast", _dietType, (v) => setState(() => _dietType = v)),
            ]),

            // FIX 3: Preferences Section Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text("PREFERENCES", style: T2TextStyles.sectionLabel(theme.colorScheme)),
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
                    // FIX 1: Notifications Toggle (Last item, no border)
                    _buildPrefRow(context, "Notifications", hasToggle: true, toggleValue: _notifications, 
                      onToggle: (v) => setState(() => _notifications = v), showBorder: false),
                  ],
                ),
              ),
            ),

            // FIX 2: South Indian as 3rd chip
            _buildSection(context, "Cuisine Preferences", [
              _buildMultiChip("North Indian", _cuisines, color: const Color(0xFFB06EFF)),
              _buildMultiChip("Mediterranean", _cuisines, color: const Color(0xFFB06EFF)),
              _buildMultiChip("South Indian", _cuisines),
              _buildMultiChip("Continental", _cuisines),
              _buildMultiChip("Asian", _cuisines, color: const Color(0xFFB06EFF)),
              _buildMultiChip("Mexican", _cuisines),
              _buildMultiChip("Middle Eastern", _cuisines),
            ]),

            _buildSection(context, "Meal Frequency", [
              _buildChoiceChip("3 meals", "$_mealsCount meals", (v) => setState(() => _mealsCount = 3)),
              _buildChoiceChip("5 meals", "$_mealsCount meals", (v) => setState(() => _mealsCount = 5), color: const Color(0xFFB8FF00)),
              _buildChoiceChip("6 meals", "$_mealsCount meals", (v) => setState(() => _mealsCount = 6)),
              _buildChoiceChip("Intermittent", "$_mealsCount meals", (v) => setState(() => _mealsCount = 0)),
            ]),

            Padding(
              padding: const EdgeInsets.all(18),
              child: DmButton(
                label: "Save Preferences",
                isLoading: isSaving,
                onPressed: isSaving ? null : () {
                  final user = ref.read(currentUserProvider);
                  if (user == null) return;
                  
                  final prefs = UserPreferences(
                    allergies: _allergies.toList(),
                    dietType: _dietType,
                    spiceLevel: _spiceLevel,
                    mealVariety: _mealVariety,
                    onlineOrdering: _onlineOrder,
                    localVendors: _localVendors,
                    fitbandSync: _fitbandSync,
                    notifications: _notifications,
                    cuisinePrefs: _cuisines.toList(),
                    mealsPerDay: _mealsCount,
                  );
                  
                  ref.read(preferencesNotifierProvider.notifier).savePreferences(user.id, prefs);
                },
                backgroundColor: const Color(0xFFB8FF00),
                textColor: Colors.black,
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => context.push(AppRoutes.t2PrivacyPolicy),
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: T2Colors.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyChip(String label) {
    return _buildMultiChip(label, _allergies, color: const Color(0xFFFF5C3A));
  }

  Widget _buildMultiChip(String label, Set<String> selection, {Color? color}) {
    final sel = selection.contains(label);
    return DmChip(
      label: label,
      isSelected: sel,
      color: color,
      onTap: () => setState(() => sel ? selection.remove(label) : selection.add(label)),
    );
  }

  Widget _buildChoiceChip(String label, String current, ValueChanged<String> onSelected, {Color? color}) {
    final sel = label == current;
    return DmChip(
      label: label,
      isSelected: sel,
      color: color,
      onTap: () => onSelected(label),
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

  Widget _buildPrefRow(BuildContext context, String lbl, {Widget? trailing, bool hasToggle = false, bool toggleValue = false, ValueChanged<bool>? onToggle, bool showBorder = true}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: showBorder 
          ? Border(bottom: BorderSide(color: theme.colorScheme.outline))
          : null,
      ),
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


