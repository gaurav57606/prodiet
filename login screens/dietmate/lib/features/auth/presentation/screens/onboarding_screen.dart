import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate/core/router/app_router.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: Icon(Icons.auto_graph_rounded, size: 80)),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Achieve Your Health Goals',
              style: context.textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Track your meals, monitor your macros, and get personalized diet plans all in one place.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            DmButton(
              label: 'Get Started',
              onPressed: () => context.goNamed('login'),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

