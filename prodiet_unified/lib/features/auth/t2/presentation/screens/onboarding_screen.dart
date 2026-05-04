import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _goal = 0;
  int _activity = 1;
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  static const _goals = [
    (Icons.scale_rounded, 'LOSE WEIGHT', 'Calorie deficit'),
    (Icons.fitness_center_rounded, 'BUILD MUSCLE', 'High protein'),
    (Icons.restaurant_rounded, 'EAT HEALTHY', 'Balanced macros'),
    (Icons.bolt_rounded, 'MORE ENERGY', 'Optimised meals'),
  ];
  static const _activities = [
    ('SEDENTARY', 'Desk job, little exercise'),
    ('LIGHTLY ACTIVE', '1–3 days exercise/week'),
    ('VERY ACTIVE', 'Hard exercise 6–7 days'),
  ];
  static const _goalKeys = ['lose_weight', 'gain_muscle', 'eat_healthy', 'maintain'];
  static const _activityKeys = ['sedentary', 'light', 'moderate'];

  @override
  void dispose() {
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final age = int.tryParse(_ageCtrl.text.trim());
    final weight = double.tryParse(_weightCtrl.text.trim());
    if (age == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in age and weight')),
      );
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(authProvider.notifier).completeOnboarding(user.id, {
      'age': age,
      'weight_kg': weight,
      'height_cm': 170, // Default value as requested
      'fitness_goal': _goalKeys[_goal],
      'activity_level': _activityKeys[_activity],
      'dietary_preferences': [],
      'allergies': [],
      'variety_preference': 'balanced',
      'daily_calorie_goal': (weight * 28).toInt(),
      'daily_water_goal_ml': 2500,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider) is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.displayMessage),
            backgroundColor: T2Colors.coral,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centered header
              children: [
                // FIX 1: Header Redesign
                const Text(
                  "ALMOST THERE",
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: Color(0xFF888888),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFB06EFF), Color(0xFF7B2FFF)],
                  ).createShader(bounds),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      children: const [
                        TextSpan(text: "Your health "),
                        TextSpan(
                          text: "goals",
                          style: TextStyle(color: Colors.white), // Color handled by ShaderMask
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Step 2 of 2 — Personalise your plan",
                  style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepPill(false),
                    const SizedBox(width: 6),
                    _buildStepPill(true),
                  ],
                ),
                const SizedBox(height: 32),

                // FIX 6: Section Label Styling
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PRIMARY GOAL',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      color: Color(0xFFAAAAAA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // FIX 2: Goal Cards
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: List.generate(_goals.length, (i) {
                    final sel = _goal == i;
                    final g = _goals[i];
                    return GestureDetector(
                      onTap: () => setState(() => _goal = i),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: sel ? const Color(0xFFB06EFF).withValues(alpha: 0.08) : T2Colors.bgElevated,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: sel ? const Color(0xFFB06EFF) : T2Colors.border,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  g.$1, 
                                  size: 24, 
                                  color: sel ? const Color(0xFFB06EFF) : const Color(0xFF666666)
                                ),
                                const Spacer(),
                                Text(
                                  g.$2,
                                  style: GoogleFonts.barlowCondensed(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: sel ? const Color(0xFFB06EFF) : Colors.white,
                                  ),
                                ),
                                Text(
                                  g.$3,
                                  style: const TextStyle(fontSize: 10, color: T2Colors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          if (sel)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB06EFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 12, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // FIX 6: Section Label Styling
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ACTIVITY LEVEL',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      color: Color(0xFFAAAAAA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // FIX 3: Activity Rows
                ...List.generate(_activities.length, (i) {
                  final sel = _activity == i;
                  final a = _activities[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _activity = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFB06EFF).withValues(alpha: 0.06) : T2Colors.bgElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? const Color(0xFFB06EFF) : T2Colors.border,
                            width: sel ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: sel ? const Color(0xFFB06EFF) : T2Colors.border,
                                  width: 2,
                                ),
                                color: sel ? const Color(0xFFB06EFF) : Colors.transparent,
                              ),
                              child: sel
                                  ? const Center(
                                      child: Icon(Icons.check, size: 10, color: Colors.white),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.$1,
                                  style: GoogleFonts.barlowCondensed(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: sel ? const Color(0xFFB06EFF) : Colors.white,
                                  ),
                                ),
                                Text(
                                  a.$2,
                                  style: const TextStyle(fontSize: 11, color: T2Colors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // FIX 6: Section Label Styling
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'YOUR MEASUREMENTS',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      color: Color(0xFFAAAAAA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // FIX 4: Measurements Row (Age + Weight)
                Row(
                  children: [
                    Expanded(
                      child: DmTextField(
                        controller: _ageCtrl,
                        label: 'Age',
                        hint: '25',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DmTextField(
                        controller: _weightCtrl,
                        label: 'Weight (kg)',
                        hint: '70',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // FIX 5: Primary Button & Back Link
                DmButton(
                  label: 'Create My Account ✓',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.chevron_left, size: 16, color: Color(0xFFB06EFF)),
                    label: const Text(
                      'Back to details',
                      style: TextStyle(color: Color(0xFFB06EFF), fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepPill(bool active) {
    return Container(
      width: 28,
      height: 5,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFB06EFF) : const Color(0xFF333338),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
