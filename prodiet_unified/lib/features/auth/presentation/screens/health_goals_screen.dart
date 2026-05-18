import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/presentation/widgets/adaptive_auth_widgets.dart';

class HealthGoalsScreen extends ConsumerStatefulWidget {
  const HealthGoalsScreen({super.key});

  @override
  ConsumerState<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends ConsumerState<HealthGoalsScreen> {
  int _selectedGoal = 0; // 0 = Lose weight, 1 = Build muscle, 2 = Eat healthier, 3 = More energy
  int _selectedActivity = 1; // 0 = Sedentary, 1 = Lightly active, 2 = Very active

  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  String _getGoalString() {
    switch (_selectedGoal) {
      case 0: return 'lose_weight';
      case 1: return 'gain_muscle';
      case 2: return 'eat_healthy';
      case 3: return 'maintain';
      default: return 'maintain';
    }
  }

  String _getActivityString() {
    switch (_selectedActivity) {
      case 0: return 'sedentary';
      case 1: return 'light';
      case 2: return 'moderate';
      case 3: return 'very_active';
      default: return 'light';
    }
  }

  Future<void> _completeOnboarding() async {
    final age = int.tryParse(_ageController.text);
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (age == null || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all health details')),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final dailyCalorieTarget = (weight * 28).toInt();

    await ref.read(authProvider.notifier).completeOnboarding(
      user.id,
      {
        'age': age,
        'weight_kg': weight,
        'height_cm': height,
        'fitness_goal': _getGoalString(),
        'activity_level': _getActivityString(),
        'dietary_preferences': [],
        'allergies': [],
        'variety_preference': 'balanced',
        'daily_calorie_goal': dailyCalorieTarget,
        'daily_water_goal_ml': 2500,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: tokens.colors.error,
        ));
      }
    });

    return AdaptiveAuthScaffold(
      header: AdaptiveAuthHeader(
        title: isT2 ? "Your health goals" : "Health Goals",
        subtitle: "Step 2 of 2 — Personalise your plan",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Primary Goal", "Helps us personalise your meal plan", tokens),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: [
                  _buildGoalCard(0, Icons.scale_rounded, 'LOSE WEIGHT', 'Calorie deficit', tokens, isT2),
                  _buildGoalCard(1, Icons.fitness_center_rounded, 'BUILD MUSCLE', 'High protein', tokens, isT2),
                  _buildGoalCard(2, Icons.restaurant_rounded, 'EAT HEALTHY', 'Balanced macros', tokens, isT2),
                  _buildGoalCard(3, Icons.bolt_rounded, 'MORE ENERGY', 'Optimised meals', tokens, isT2),
                ],
              ),
              const SizedBox(height: 32),

              _buildSectionHeader("Activity Level", "Helps calculate your daily needs", tokens),
              const SizedBox(height: 16),
              ...List.generate(4, (i) {
                final titles = ['SEDENTARY', 'LIGHTLY ACTIVE', 'MODERATELY ACTIVE', 'VERY ACTIVE'];
                final subs = ['Desk job, little exercise', '1–3 days exercise/week', '3–5 days exercise/week', 'Hard exercise 6–7 days'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildActivityOption(i, titles[i], subs[i], tokens, isT2),
                );
              }),
              const SizedBox(height: 32),

              _buildSectionHeader("Your Measurements", "Enter your stats", tokens),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _ageController,
                      hint: 'Age',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: _weightController,
                      hint: 'Weight (kg)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: _heightController,
                      hint: 'Height (cm)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              AppButton(
                label: 'Complete Onboarding ✓',
                isLoading: isLoading,
                onPressed: isLoading ? null : _completeOnboarding,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Back to details',
                    style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.5), fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, AppThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            color: tokens.colors.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: tokens.colors.onSurface.withValues(alpha: 0.4)),
        ),
      ],
    );
  }

  Widget _buildGoalCard(int index, IconData icon, String title, String subtitle, AppThemeTokens tokens, bool isT2) {
    final sel = _selectedGoal == index;
    final primaryColor = isT2 ? const Color(0xFFB06EFF) : tokens.colors.primary;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sel ? primaryColor.withValues(alpha: 0.08) : tokens.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: sel ? primaryColor : tokens.colors.outline.withValues(alpha: 0.1),
            width: sel ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: sel ? primaryColor : tokens.colors.onSurface.withValues(alpha: 0.4)),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: sel ? primaryColor : tokens.colors.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: tokens.colors.onSurface.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityOption(int index, String title, String subtitle, AppThemeTokens tokens, bool isT2) {
    final sel = _selectedActivity == index;
    final primaryColor = isT2 ? const Color(0xFFB06EFF) : tokens.colors.primary;

    return GestureDetector(
      onTap: () => setState(() => _selectedActivity = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: sel ? primaryColor.withValues(alpha: 0.06) : tokens.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: sel ? primaryColor : tokens.colors.outline.withValues(alpha: 0.1),
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
                  color: sel ? primaryColor : tokens.colors.outline.withValues(alpha: 0.2),
                  width: 2,
                ),
                color: sel ? primaryColor : Colors.transparent,
              ),
              child: sel ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: sel ? primaryColor : tokens.colors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: tokens.colors.onSurface.withValues(alpha: 0.4)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
