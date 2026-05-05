import 'package:flutter/material.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'What We Collect',
              'We collect information necessary to provide a personalized experience, including your email, name, health goals, meal logs, weight entries, and water intake.',
            ),
            _buildSection(
              context,
              'How We Use It',
              'Your data is used to generate personalized diet plans, track your nutritional progress over time, and send you helpful reminders to stay on track.',
            ),
            _buildSection(
              context,
              'Storage',
              'Your data is stored securely using Supabase infrastructure, which follows industry-standard security protocols and is ISO 27001 certified.',
            ),
            _buildSection(
              context,
              'Third Parties',
              'We use Google Gemini AI for plan generation. We only share anonymized profile data required for the AI to create your personalized meal suggestions.',
            ),
            _buildSection(
              context,
              'Your Rights',
              'You have full control over your data. You can delete your account and all associated data at any time from Profile → Delete Account.',
            ),
            _buildSection(
              context,
              'Contact',
              'If you have any questions about our privacy practices, please reach out to us at support@prodiet.app',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Last updated: May 2026',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ),
        DmCard(
          child: Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
