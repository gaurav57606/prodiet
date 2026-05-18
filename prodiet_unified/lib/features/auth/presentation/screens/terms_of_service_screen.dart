import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: tokens.colors.surface,
        foregroundColor: tokens.colors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'User Agreement',
              'By using ProDiet, you agree to these terms. ProDiet is a nutritional tracking tool and does not provide medical advice.',
              tokens,
            ),
            _buildSection(
              context,
              'Not Medical Advice',
              'The information provided within this app is for educational and tracking purposes only. Consult with a doctor or registered dietitian before starting any new diet or exercise program.',
              tokens,
            ),
            _buildSection(
              context,
              'Account Responsibility',
              'You are responsible for maintaining the security of your account credentials and for any activity that occurs under your account.',
              tokens,
            ),
            _buildSection(
              context,
              'Subscription Terms',
              'ProDiet Premium subscriptions are handled through App Store or Play Store. Cancellations must be made at least 24 hours before the renewal date.',
              tokens,
            ),
            _buildSection(
              context,
              'Acceptable Use',
              'You agree not to use ProDiet for any unlawful purposes or to upload content that is harmful, offensive, or violates privacy rights.',
              tokens,
            ),
            _buildSection(
              context,
              'Limitation of Liability',
              'ProDiet and its developers are not liable for any direct or indirect damages resulting from your use of the application.',
              tokens,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Last updated: May 2026',
                style: tokens.typography.bodySmall.copyWith(
                  color: tokens.colors.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, AppThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: tokens.typography.labelLarge.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: tokens.colors.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: tokens.typography.bodyMedium.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
