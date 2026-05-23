import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/preferences/application/preferences_providers.dart';
import 'package:prodiet_unified/features/preferences/application/preferences_state.dart';
import 'package:prodiet_unified/features/preferences/domain/user_preferences.dart';
import 'package:prodiet_unified/features/preferences/presentation/widgets/adaptive_preference_widgets.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/config/feature_flags.dart';
import 'package:prodiet_unified/core/intelligence/intelligence_providers.dart';

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
  
  // Privacy & Telemetry local states
  bool _personalization = true;
  bool _ocrLearning = true;
  bool _habitAnalytics = true;
  bool _ocrEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref.read(preferencesNotifierProvider.notifier).loadPreferences(user.id);
      }
      final privacyManager = ref.read(privacyEthicsManagerProvider);
      setState(() {
        _personalization = privacyManager.isPersonalizationEnabled;
        _ocrLearning = privacyManager.isOcrLearningEnabled;
        _habitAnalytics = privacyManager.isHabitAnalyticsEnabled;
        _ocrEnabled = FeatureFlags.ocrEnabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
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
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'PREFERENCES' : 'Preferences'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator(color: tokens.colors.primary))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptivePreferenceSection(title: "Allergies & Intolerances", children: [
              _buildAllergyChip('Dairy'),
              _buildAllergyChip('Tree Nuts'),
              _buildAllergyChip('Gluten'),
              _buildAllergyChip('Eggs'),
              _buildAllergyChip('Soy'),
              _buildAllergyChip('Shellfish'),
              _buildAllergyChip('Peanuts'),
              _buildAllergyChip('Fish'),
            ]),
            
            AdaptivePreferenceSection(title: "Diet Type", children: [
              _buildChoiceChip("Non-Vegetarian", _dietType, (v) => setState(() => _dietType = v), color: const Color(0xFFB8FF00)),
              _buildChoiceChip("Vegetarian", _dietType, (v) => setState(() => _dietType = v)),
              _buildChoiceChip("Vegan", _dietType, (v) => setState(() => _dietType = v)),
              _buildChoiceChip("Keto", _dietType, (v) => setState(() => _dietType = v)),
              _buildChoiceChip("Intermittent Fast", _dietType, (v) => setState(() => _dietType = v)),
            ]),

            const SizedBox(height: 16),
            _buildContainer(
              context,
              Column(
                children: [
                  AdaptivePreferenceRow(
                    label: "Spice level", 
                    subLabel: _getSpiceLabel(),
                    trailing: _buildSpiceLevel(context),
                  ),
                  AdaptivePreferenceRow(
                    label: "Meal variety", 
                    hasToggle: true, 
                    toggleValue: _mealVariety, 
                    onToggle: (v) => setState(() => _mealVariety = v),
                  ),
                  AdaptivePreferenceRow(
                    label: "Online ordering", 
                    hasToggle: true, 
                    toggleValue: _onlineOrder, 
                    onToggle: (v) => setState(() => _onlineOrder = v),
                  ),
                  AdaptivePreferenceRow(
                    label: "Local vendors", 
                    hasToggle: true, 
                    toggleValue: _localVendors, 
                    onToggle: (v) => setState(() => _localVendors = v),
                  ),
                  AdaptivePreferenceRow(
                    label: "Fitband sync", 
                    hasToggle: true, 
                    toggleValue: _fitbandSync, 
                    onToggle: (v) => setState(() => _fitbandSync = v),
                  ),
                  AdaptivePreferenceRow(
                    label: "Notifications", 
                    hasToggle: true, 
                    toggleValue: _notifications, 
                    onToggle: (v) => setState(() => _notifications = v), 
                    showBorder: false,
                  ),
                ],
              ),
            ),

            AdaptivePreferenceSection(title: "Cuisine Preferences", children: [
              _buildMultiChip("North Indian", _cuisines, color: const Color(0xFFB06EFF)),
              _buildMultiChip("Mediterranean", _cuisines, color: const Color(0xFFB06EFF)),
              _buildMultiChip("South Indian", _cuisines),
              _buildMultiChip("Continental", _cuisines),
              _buildMultiChip("Asian", _cuisines, color: const Color(0xFFB06EFF)),
              _buildMultiChip("Mexican", _cuisines),
              _buildMultiChip("Middle Eastern", _cuisines),
            ]),

            AdaptivePreferenceSection(title: "Meal Frequency", children: [
              _buildChoiceChip("3 meals", "$_mealsCount meals", (v) => setState(() => _mealsCount = 3)),
              _buildChoiceChip("5 meals", "$_mealsCount meals", (v) => setState(() => _mealsCount = 5), color: const Color(0xFFB8FF00)),
              _buildChoiceChip("6 meals", "$_mealsCount meals", (v) => setState(() => _mealsCount = 6)),
              _buildChoiceChip("Intermittent", "$_mealsCount meals", (v) => setState(() => _mealsCount = 0)),
            ]),

            const AdaptivePreferenceSection(title: "AI Intelligence & Privacy", children: []),
            const SizedBox(height: 16),
            _buildContainer(
              context,
              Column(
                children: [
                  AdaptivePreferenceRow(
                    label: "Personalization Engine",
                    subLabel: "Adapts recommendations to your timing and goals",
                    hasToggle: true,
                    toggleValue: _personalization,
                    onToggle: (v) {
                      setState(() => _personalization = v);
                      ref.read(privacyEthicsManagerProvider).setPersonalizationPreference(v);
                    },
                  ),
                  AdaptivePreferenceRow(
                    label: "OCR Spelling Learner",
                    subLabel: "Autocorrects typos inside scanned item lists",
                    hasToggle: true,
                    toggleValue: _ocrLearning,
                    onToggle: (v) {
                      setState(() => _ocrLearning = v);
                      ref.read(privacyEthicsManagerProvider).setOcrLearningPreference(v);
                    },
                  ),
                  AdaptivePreferenceRow(
                    label: "Habit Telemetry Logs",
                    subLabel: "Classifies weekend spikers & meal delays",
                    hasToggle: true,
                    toggleValue: _habitAnalytics,
                    onToggle: (v) {
                      setState(() => _habitAnalytics = v);
                      ref.read(privacyEthicsManagerProvider).setHabitAnalyticsPreference(v);
                    },
                  ),
                  AdaptivePreferenceRow(
                    label: "OCR Meal Scanner",
                    subLabel: "Enable photo-based meal recognition scanner",
                    hasToggle: true,
                    toggleValue: _ocrEnabled,
                    onToggle: (v) {
                      setState(() => _ocrEnabled = v);
                      FeatureFlags.updateFlags({'ocr_enabled': v});
                    },
                    showBorder: false,
                  ),
                  const Divider(height: 1, thickness: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(
                      "Execute CCPA / GDPR Erasure",
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.redAccent,
                      ),
                    ),
                    subtitle: Text(
                      "Wipes learned food typo maps & local recommendation cache",
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.colors.outline,
                      ),
                    ),
                    trailing: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                    onTap: () {
                      ref.read(privacyEthicsManagerProvider).executeFullErasure();
                      setState(() {
                        _personalization = false;
                        _ocrLearning = false;
                        _habitAnalytics = false;
                        _ocrEnabled = false;
                      });
                      FeatureFlags.updateFlags({'ocr_enabled': false});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('CCPA & GDPR compliance erasure complete ✓ All local intelligence maps purged.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                final manifest = ref.read(privacyEthicsManagerProvider).generatePrivacyManifest();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: tokens.colors.surfaceContainerHigh,
                    title: Text(
                      "PRIVACY TELEMETRY AUDIT",
                      style: GoogleFonts.barlowCondensed(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: manifest.entries.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.key.toUpperCase().replaceAll('_', ' '),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              e.value.toString().toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: tokens.colors.primary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            color: tokens.colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tokens.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: tokens.colors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: tokens.colors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CCPA & GDPR COMPLIANT",
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: tokens.colors.primary,
                            ),
                          ),
                          Text(
                            "Local sandboxed execution only. Tap to audit telemetry.",
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: tokens.colors.primary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            AppButton(
              label: isT2 ? "SAVE PREFERENCES" : "Save Preferences",
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
              backgroundColor: tokens.colors.primary,
              isFullWidth: true,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, Widget child) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: isT2 ? BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.05)),
      ) : BoxDecoration(
        color: tokens.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildAllergyChip(String label) {
    return _buildMultiChip(label, _allergies, color: const Color(0xFFFF5C3A));
  }

  Widget _buildMultiChip(String label, Set<String> selection, {Color? color}) {
    final sel = selection.contains(label);
    return AdaptiveChoiceChip(
      label: label,
      isSelected: sel,
      color: color,
      onTap: () => setState(() => sel ? selection.remove(label) : selection.add(label)),
    );
  }

  Widget _buildChoiceChip(String label, String current, ValueChanged<String> onSelected, {Color? color}) {
    final sel = label == current;
    return AdaptiveChoiceChip(
      label: label,
      isSelected: sel,
      color: color,
      onTap: () => onSelected(label),
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

  Widget _buildSpiceLevel(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: List.generate(5, (i) => GestureDetector(
        onTap: () => setState(() => _spiceLevel = i + 1),
        child: Container(
          width: 14, height: 14,
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: i < _spiceLevel ? tokens.colors.primary : tokens.colors.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      )),
    );
  }
}
