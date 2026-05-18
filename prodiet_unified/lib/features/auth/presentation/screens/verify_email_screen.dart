import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/presentation/widgets/adaptive_auth_widgets.dart';

class VerifyEmailScreen extends ConsumerWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;

    return AdaptiveAuthScaffold(
      header: const AdaptiveAuthHeader(
        title: "Check Email",
        subtitle: "Verification link sent",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: tokens.colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '✉️',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Verify Your Email',
                style: tokens.typography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  color: tokens.colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We sent a verification link to\n$email\n\nTap the link in the email to activate your account.',
                style: tokens.typography.bodyMedium.copyWith(
                  color: tokens.colors.onSurface.withValues(alpha: 0.5),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppButton(
                label: 'RESEND EMAIL',
                onPressed: () async {
                  try {
                    await ref.read(authRepositoryProvider).sendPasswordReset(email);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email sent! Check your inbox.')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Back to Login',
                  style: TextStyle(
                    color: tokens.colors.primary,
                    fontWeight: FontWeight.w700,
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
