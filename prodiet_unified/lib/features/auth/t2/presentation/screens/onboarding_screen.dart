import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
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
  final _ageCtrl    = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  static const _goals = [
    ('⚖️', 'LOSE WEIGHT',  'Calorie deficit'),
    ('💪', 'BUILD MUSCLE', 'High protein'),
    ('🥗', 'EAT HEALTHY',  'Balanced macros'),
    ('⚡', 'MORE ENERGY',  'Optimised meals'),
  ];
  static const _activities = [
    ('SEDENTARY',      'Desk job, little exercise'),
    ('LIGHTLY ACTIVE', '1–3 days exercise/week'),
    ('VERY ACTIVE',    'Hard exercise 6–7 days'),
  ];
  static const _goalKeys     = ['lose_weight', 'gain_muscle', 'eat_healthy', 'maintain'];
  static const _activityKeys = ['sedentary', 'light', 'moderate'];

  @override
  void dispose() {
    _ageCtrl.dispose(); _weightCtrl.dispose(); _heightCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final age    = int.tryParse(_ageCtrl.text.trim());
    final weight = double.tryParse(_weightCtrl.text.trim());
    final height = double.tryParse(_heightCtrl.text.trim());
    if (age == null || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all three fields')),
      );
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(authProvider.notifier).completeOnboarding(user.id, {
      'age': age,
      'weight_kg': weight,
      'height_cm': height,
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
          SnackBar(content: Text(next.error.displayMessage),
            backgroundColor: T2Colors.coral),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ALMOST\nTHERE.',
                  style: GoogleFonts.barlowCondensed(fontSize: 52,
                    fontWeight: FontWeight.w900, color: Colors.white, height: 1.0)),
                const SizedBox(height: 4),
                const Text('Set your goals to personalise your plan',
                  style: TextStyle(color: T2Colors.textSecondary, fontSize: 13)),
                const SizedBox(height: 28),
  
                const Text('PRIMARY GOAL', style: TextStyle(fontSize: 10,
                  letterSpacing: 1.5, color: T2Colors.textMuted, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: List.generate(_goals.length, (i) {
                    final sel = _goal == i;
                    final g = _goals[i];
                    return GestureDetector(
                      onTap: () => setState(() => _goal = i),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: sel ? T2Colors.lime.withValues(alpha: 0.1) : T2Colors.bgElevated,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: sel ? T2Colors.lime : T2Colors.border, width: sel ? 1.5 : 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.$1, style: const TextStyle(fontSize: 20)),
                            const Spacer(),
                            Text(g.$2, style: GoogleFonts.barlowCondensed(fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: sel ? T2Colors.lime : Colors.white)),
                            Text(g.$3, style: const TextStyle(fontSize: 10,
                              color: T2Colors.textMuted)),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
  
                const Text('ACTIVITY LEVEL', style: TextStyle(fontSize: 10,
                  letterSpacing: 1.5, color: T2Colors.textMuted, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
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
                          color: sel ? T2Colors.lime.withValues(alpha: 0.08) : T2Colors.bgElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? T2Colors.lime : T2Colors.border, width: sel ? 1.5 : 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 18, height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: sel ? T2Colors.lime : T2Colors.border, width: 2),
                                color: sel ? T2Colors.lime : Colors.transparent,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.$1, style: GoogleFonts.barlowCondensed(fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: sel ? T2Colors.lime : Colors.white)),
                                Text(a.$2, style: const TextStyle(fontSize: 11,
                                  color: T2Colors.textMuted)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
  
                const Text('YOUR MEASUREMENTS', style: TextStyle(fontSize: 10,
                  letterSpacing: 1.5, color: T2Colors.textMuted, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: DmTextField(controller: _ageCtrl,
                      label: 'Age', hint: '25', keyboardType: TextInputType.number)),
                    const SizedBox(width: 10),
                    Expanded(child: DmTextField(controller: _weightCtrl,
                      label: 'Weight (kg)', hint: '70', keyboardType: TextInputType.number)),
                    const SizedBox(width: 10),
                    Expanded(child: DmTextField(controller: _heightCtrl,
                      label: 'Height (cm)', hint: '175', keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 32),
                DmButton(
                  label: 'START MY JOURNEY ✓',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

