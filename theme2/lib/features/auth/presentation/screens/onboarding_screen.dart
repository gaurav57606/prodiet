import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/shared/widgets/dm_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                "Precision\nNutrition AI",
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Your biology, your goals, your kitchen.\nSynchronized in real-time.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              DmButton(
                label: "Get Started",
                onPressed: () => context.goNamed('login'),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: () => context.goNamed('login'),
                  child: Text(
                    "Already have an account? Log in",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
