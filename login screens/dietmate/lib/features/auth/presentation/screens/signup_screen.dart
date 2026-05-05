import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_button.dart';
import 'package:dietmate/shared/widgets/dm_text_field.dart';
import 'package:dietmate/features/auth/presentation/widgets/auth_hero.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;

  void _nextStep() => setState(() => _currentStep++);
  void _prevStep() => setState(() => _currentStep--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthHero(
              title: _currentStep == 0 ? 'Create account' : 'Health goals',
              subtitle: _currentStep == 0 ? 'Step 1 of 2 — Personal details' : 'Step 2 of 2 — Personalise your plan',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                children: [
                  _buildStepIndicator(),
                  const SizedBox(height: AppSpacing.lg),
                  if (_currentStep == 0) _buildStep1() else _buildStep2(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = index == _currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? context.colorScheme.primary : context.colorScheme.outline,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: DmTextField(
                label: 'First Name',
                hint: 'Rohan',
                prefixIcon: Icons.person_outline_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: DmTextField(
                label: 'Last Name',
                hint: 'Sharma',
                prefixIcon: Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const DmTextField(
          label: 'Email Address',
          hint: 'you@example.com',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: AppSpacing.md),
        const DmTextField(
          label: 'Phone (Optional)',
          hint: '+91 98765 43210',
          prefixIcon: Icons.phone_outlined,
        ),
        const SizedBox(height: AppSpacing.md),
        const DmTextField(
          label: 'Password',
          hint: 'Min. 8 characters',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        DmButton(
          label: 'Continue →',
          onPressed: _nextStep,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildLoginLink(),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What\'s your primary goal?', style: context.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.2,
          children: [
            _buildGoalCard('Lose weight', 'Calorie deficit', '⚖️', true),
            _buildGoalCard('Build muscle', 'High protein', '💪', false),
            _buildGoalCard('Eat healthier', 'Balanced macros', '🥗', false),
            _buildGoalCard('More energy', 'Optimised meals', '⚡', false),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Activity level', style: context.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _buildActivityItem('Sedentary', 'Desk job, little exercise', false),
        const SizedBox(height: AppSpacing.sm),
        _buildActivityItem('Lightly active', '1–3 days exercise / week', true),
        const SizedBox(height: AppSpacing.sm),
        _buildActivityItem('Very active', 'Hard exercise 6–7 days', false),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            const Expanded(
              child: DmTextField(
                label: 'Age',
                hint: '25',
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: DmTextField(
                label: 'Weight (KG)',
                hint: '70',
                prefixIcon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        DmButton(
          label: 'Create My Account ✓',
          onPressed: () => context.goNamed('dashboard'),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton(
            onPressed: _prevStep,
            child: const Text('Back to details'),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(String title, String sub, String emoji, bool selected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? context.colorScheme.primary.withValues(alpha: 0.08) : context.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? context.colorScheme.primary : context.colorScheme.outline,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(title, style: context.textTheme.titleSmall),
            Text(
              sub,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String sub, bool selected) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? context.colorScheme.primary.withValues(alpha: 0.08) : context.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? context.colorScheme.primary : context.colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? context.colorScheme.primary : context.colorScheme.outline,
            ),
            child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textTheme.titleSmall),
              Text(
                sub,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => context.goNamed('login'),
        child: RichText(
          text: TextSpan(
            style: context.textTheme.bodySmall,
            children: [
              TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
              ),
              TextSpan(
                text: 'Sign in',
                style: TextStyle(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

