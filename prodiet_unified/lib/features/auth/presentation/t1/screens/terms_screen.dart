import 'package:flutter/material.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Service',
              'ProDiet provides AI-generated dietary suggestions and tracking tools. These are for informational purposes only and do not constitute medical advice.',
            ),
            _buildSection(
              context,
              'Eligibility',
              'You must be at least 13 years old to use this service. By signing up, you represent that you meet this age requirement.',
            ),
            _buildSection(
              context,
              'Accuracy',
              'AI-generated plans are suggestions based on provided data. If you have any medical conditions or dietary requirements, please consult a professional nutritionist.',
            ),
            _buildSection(
              context,
              'Prohibited',
              'You may not use ProDiet for any illegal purposes. Reselling data, scraping our services, or reverse engineering our software is strictly prohibited.',
            ),
            _buildSection(
              context,
              'Termination',
              'We reserve the right to suspend or terminate accounts that violate these terms or engage in behavior harmful to our community or service.',
            ),
            _buildSection(
              context,
              'Governing Law',
              'These terms are governed by the laws of India. Any disputes shall be subject to the exclusive jurisdiction of the courts in Uttar Pradesh.',
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
