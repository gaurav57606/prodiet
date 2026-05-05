import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_button.dart';
import 'package:dietmate/shared/widgets/dm_card.dart';
import 'package:dietmate/shared/widgets/dm_text_field.dart';
import 'package:dietmate/features/auth/presentation/widgets/auth_hero.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isSent = false;

  void _sendResetLink() {
    setState(() => _isSent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthHero(
              title: 'Reset',
              subtitle: _isSent 
                ? 'Reset link sent — check your inbox'
                : 'Enter your email and we\'ll send a reset link',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                    label: const Text('Back to sign in'),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const DmTextField(
                    label: 'Email Address',
                    hint: 'you@example.com',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DmButton(
                    label: 'Send Reset Link',
                    onPressed: _sendResetLink,
                  ),
                  if (_isSent) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildSuccessStrip(),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  _buildHelpCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessStrip() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(
            'Reset link sent — check your inbox',
            style: context.textTheme.bodySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return DmCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DIDN\'T RECEIVE IT?', style: context.textTheme.labelLarge),
          const SizedBox(height: 6),
          Text(
            'Check spam folder · Wait 2 minutes · ',
            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Resend email',
              style: TextStyle(color: context.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

