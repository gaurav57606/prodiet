import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_button.dart';
import '../../../../shared/widgets/dm_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Create Account',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Join DietMate Pro and reach your goals.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const DmTextField(
                label: 'Full Name',
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person_outline),
              ),
              const SizedBox(height: AppSpacing.lg),
              const DmTextField(
                label: 'Email Address',
                hintText: 'hello@dietmate.pro',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              const SizedBox(height: AppSpacing.lg),
              const DmTextField(
                label: 'Password',
                hintText: '••••••••',
                obscureText: true,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              const SizedBox(height: AppSpacing.xl),
              DmButton(
                label: 'Create Account',
                onPressed: () => context.goNamed(AppRoutes.dashboardName),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.goNamed(AppRoutes.loginName),
                    child: Text(
                      'Sign In',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
