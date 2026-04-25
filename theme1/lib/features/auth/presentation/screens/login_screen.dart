import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_button.dart';
import '../../../../shared/widgets/dm_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                'Welcome Back',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Sign in to continue your progress.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
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
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              DmButton(
                label: 'Sign In',
                onPressed: () => context.goNamed(AppRoutes.dashboardName),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(child: Divider(color: theme.colorScheme.outline.withOpacity(0.1))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'OR',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: theme.colorScheme.outline.withOpacity(0.1))),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: DmButton(
                      label: 'Google',
                      variant: DmButtonVariant.outline,
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DmButton(
                      label: 'Apple',
                      variant: DmButtonVariant.outline,
                      icon: Icons.apple_rounded,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.goNamed(AppRoutes.signupName),
                    child: Text(
                      'Sign Up',
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
