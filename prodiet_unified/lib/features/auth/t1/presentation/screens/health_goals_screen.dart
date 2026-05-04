import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';

class HealthGoalsScreen extends ConsumerStatefulWidget {
  const HealthGoalsScreen({super.key});

  @override
  ConsumerState<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends ConsumerState<HealthGoalsScreen> {
  int _selectedGoal =
      0; // 0 = Lose weight, 1 = Build muscle, 2 = Eat healthier, 3 = More energy
  int _selectedActivity =
      1; // 0 = Sedentary, 1 = Lightly active, 2 = Very active

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
      case 0:
        return 'lose_weight';
      case 1:
        return 'gain_muscle';
      case 2:
        return 'eat_healthy';
      case 3:
        return 'maintain';
      default:
        return 'maintain';
    }
  }

  String _getActivityString() {
    switch (_selectedActivity) {
      case 0:
        return 'sedentary';
      case 1:
        return 'light';
      case 2:
        return 'moderate';
      case 3:
        return 'very_active';
      default:
        return 'light';
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

    // Simple calorie estimation: Weight (kg) * 28 (moderate activity multiplier)
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
        'daily_calorie_target': dailyCalorieTarget,
        'daily_water_target_ml': 2500,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: scheme.error,
        ));
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // TOP HERO SECTION
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.surface,
                  scheme.surfaceContainerHighest,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ALMOST THERE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withValues(alpha: 0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(
                            text: 'Your health ',
                            style: TextStyle(color: scheme.onSurface)),
                        TextSpan(
                            text: 'goals',
                            style: TextStyle(color: scheme.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step 2 of 2 — Personalise your plan',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.45),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // STEP INDICATOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: scheme.outline.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 5,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM SCROLL AREA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      "What's your primary goal?",
                      "This helps us personalise your meal plan",
                      theme,
                    ),
                    const SizedBox(height: 16),
                    // GOAL GRID
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        _buildGoalCard(0, Icons.scale_rounded, 'Lose weight',
                            'Calorie deficit', theme),
                        _buildGoalCard(1, Icons.fitness_center_rounded,
                            'Build muscle', 'High protein', theme),
                        _buildGoalCard(2, Icons.restaurant_rounded,
                            'Eat healthier', 'Balanced macros', theme),
                        _buildGoalCard(3, Icons.bolt_rounded, 'More energy',
                            'Optimised meals', theme),
                      ],
                    ),
                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      "Activity level",
                      "Helps calculate your daily needs",
                      theme,
                    ),
                    const SizedBox(height: 16),
                    // ACTIVITY OPTIONS
                    _buildActivityOption(
                        0, 'Sedentary', 'Desk job, little exercise', theme),
                    const SizedBox(height: 12),
                    _buildActivityOption(
                        1, 'Lightly active', '1–3 days exercise / week', theme),
                    const SizedBox(height: 12),
                    _buildActivityOption(2, 'Moderately active',
                        '3–5 days exercise / week', theme),
                    const SizedBox(height: 12),
                    _buildActivityOption(
                        3, 'Very active', 'Hard exercise 6–7 days', theme),
                    const SizedBox(height: 32),

                    // BOTTOM INPUTS
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('AGE', theme),
                              const SizedBox(height: 8),
                              DmTextField(
                                controller: _ageController,
                                hintText: '25',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('WEIGHT (KG)', theme),
                              const SizedBox(height: 8),
                              DmTextField(
                                controller: _weightController,
                                hintText: '70',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('HEIGHT (CM)', theme),
                              const SizedBox(height: 8),
                              DmTextField(
                                controller: _heightController,
                                hintText: '175',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Button
                    DmButton(
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
                          '< Back to details',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, ThemeData theme) {
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
              fontSize: 13, color: scheme.onSurface.withValues(alpha: 0.45)),
        ),
      ],
    );
  }

  Widget _buildGoalCard(int index, IconData icon, String title, String subtitle,
      ThemeData theme) {
    final scheme = theme.colorScheme;
    final isSelected = _selectedGoal == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? scheme.primary
                : scheme.outline.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: isSelected
                        ? scheme.primary
                        : scheme.onSurface.withValues(alpha: 0.5),
                    size: 24),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.45),
                      fontSize: 11),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: scheme.onSurface, size: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityOption(
      int index, String title, String subtitle, ThemeData theme) {
    final scheme = theme.colorScheme;
    final isSelected = _selectedActivity == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedActivity = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? scheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? scheme.primary
                      : scheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 6 : 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child:
                          Icon(Icons.check, color: scheme.onSurface, size: 10))
                  : null,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.45),
                      fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    final scheme = theme.colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}
