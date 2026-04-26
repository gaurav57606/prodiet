import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate/core/router/app_router.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_button.dart';
import 'package:dietmate/shared/widgets/dm_divider.dart';
import 'package:dietmate/shared/widgets/dm_text_field.dart';
import 'package:dietmate/features/auth/presentation/widgets/auth_hero.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHero(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabs(context),
                  const SizedBox(height: AppSpacing.lg),
                  const DmTextField(
                    label: 'Email Address',
                    hint: 'you@example.com',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PASSWORD',
                            style: context.textTheme.labelLarge?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot?'),
                          ),
                        ],
                      ),
                      const DmTextField(
                        label: '',
                        hint: 'Enter your password',
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildRememberMe(context),
                  const SizedBox(height: AppSpacing.lg),
                  DmButton(
                    label: 'Sign In',
                    onPressed: () => context.goNamed('dashboard'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const DmDivider(label: 'or continue with'),
                  const SizedBox(height: AppSpacing.md),
                  _buildSocialButtons(context),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSignUpLink(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colorScheme.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Sign in',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => context.goNamed('signup'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 9),
                child: Text(
                  'Create account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberMe(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: true,
          onChanged: (v) {},
          activeColor: context.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        Text(
          'Keep me signed in',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.apple_rounded, size: 22),
            label: const Text('Apple'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.goNamed('signup'),
        child: RichText(
          text: TextSpan(
            style: context.textTheme.bodySmall,
            children: [
              TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: context.colorScheme.onSurfaceVariant.withOpacity(0.7)),
              ),
              TextSpan(
                text: 'Create one',
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

