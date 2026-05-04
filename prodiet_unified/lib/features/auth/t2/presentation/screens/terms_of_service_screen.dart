import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('ProDiet Terms & Conditions'),
            _buildSubHeader('Last Updated: May 4, 2026'),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Acceptance of Terms'),
            _buildText(
                'By accessing or using ProDiet, you agree to be bound by these Terms of Service. If you do not agree, please do not use the application.'),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Not Medical Advice'),
            _buildText(
                'ProDiet provides nutritional information and meal planning for informational purposes only. We are NOT medical professionals. Always consult with a doctor or nutritionist before starting a new diet or exercise program.'),
            const SizedBox(height: 24),
            _buildSectionTitle('3. User Accounts'),
            _buildBulletPoint(
                'You are responsible for maintaining the confidentiality of your account.'),
            _buildBulletPoint(
                'You must provide accurate and complete information.'),
            _buildBulletPoint(
                'We reserve the right to terminate accounts that violate our community guidelines.'),
            const SizedBox(height: 24),
            _buildSectionTitle('4. Prohibited Conduct'),
            _buildText('You agree not to:'),
            _buildBulletPoint('Use the app for any illegal purposes.'),
            _buildBulletPoint(
                'Attempt to reverse engineer or scrape the application.'),
            _buildBulletPoint(
                'Post harmful or offensive content in community sections.'),
            const SizedBox(height: 24),
            _buildSectionTitle('5. Limitation of Liability'),
            _buildText(
                'ProDiet and its creators are not liable for any health issues, data loss, or damages resulting from the use of the app.'),
            const SizedBox(height: 40),
            _buildSectionTitle('Contact Us'),
            const Text(
              'legal@prodiet.com',
              style:
                  TextStyle(color: T2Colors.lime, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: T2Colors.textSecondary,
        fontSize: 14,
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: T2Colors.lime,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(color: T2Colors.lime, fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
