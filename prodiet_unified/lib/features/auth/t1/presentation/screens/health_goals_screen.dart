import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';

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
        'daily_calorie_goal': dailyCalorieTarget,
        'daily_water_goal_ml': 2500,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: Colors.red.shade700,
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A0030),
                  Color(0xFF0D0020),
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
                      color: Colors.white.withValues(alpha: 0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(text: 'Your health ', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'goals', style: TextStyle(color: Color(0xFF8B5CF6))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step 2 of 2 — Personalise your plan',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
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
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 16,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    "What's your primary goal?",
                    "This helps us personalise your meal plan",
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
                      _buildGoalCard(0, '⚖️', 'Lose weight', 'Calorie deficit'),
                      _buildGoalCard(1, '💪', 'Build muscle', 'High protein'),
                      _buildGoalCard(2, '🥗', 'Eat healthier', 'Balanced macros'),
                      _buildGoalCard(3, '⚡', 'More energy', 'Optimised meals'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader(
                    "Activity level",
                    "Helps calculate your daily needs",
                  ),
                  const SizedBox(height: 16),
                  // ACTIVITY OPTIONS
                  _buildActivityOption(0, 'Sedentary', 'Desk job, little exercise'),
                  const SizedBox(height: 12),
                  _buildActivityOption(1, 'Lightly active', '1–3 days exercise / week'),
                  const SizedBox(height: 12),
                  _buildActivityOption(2, 'Very active', 'Hard exercise 6–7 days'),
                  const SizedBox(height: 32),

                  // BOTTOM INPUTS
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('AGE'),
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
                            _buildLabel('WEIGHT (KG)'),
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
                            _buildLabel('HEIGHT (CM)'),
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
                          color: Colors.white.withValues(alpha: 0.5),
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
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.45)),
        ),
      ],
    );
  }

  Widget _buildGoalCard(int index, String emoji, String title, String subtitle) {
    final isSelected = _selectedGoal == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.white.withValues(alpha: 0.07),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityOption(int index, String title, String subtitle) {
    final isSelected = _selectedActivity == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedActivity = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
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
                  color: isSelected ? const Color(0xFF8B5CF6) : Colors.white.withValues(alpha: 0.2),
                  width: isSelected ? 6 : 2,
                ),
              ),
              child: isSelected 
                ? const Center(child: Icon(Icons.check, color: Colors.white, size: 10))
                : null,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}
