import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            _buildHeader('ProDiet Privacy Policy'),
            _buildSubHeader('Effective Date: April 30, 2026'),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Data We Collect'),
            _buildBulletPoint('Email address and name (for account creation)'),
            _buildBulletPoint('Health and fitness data: weight, height, age, fitness goals, dietary preferences'),
            _buildBulletPoint('Food and nutrition logs you enter'),
            _buildBulletPoint('Water intake logs'),
            _buildBulletPoint('Device information and app usage analytics (anonymized)'),
            _buildBulletPoint('Crash reports via Firebase Crashlytics'),
            const SizedBox(height: 24),
            
            _buildSectionTitle('How We Use Your Data'),
            _buildBulletPoint('To provide personalized meal plans and nutrition tracking'),
            _buildBulletPoint('To improve app performance and fix bugs'),
            _buildBulletPoint('We do NOT sell your data to third parties'),
            _buildBulletPoint('We do NOT use your data for advertising'),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Data Storage'),
            _buildBulletPoint('Your data is stored securely on Supabase (PostgreSQL) servers'),
            _buildBulletPoint('Crash data is processed by Google Firebase Crashlytics'),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Data Deletion'),
            _buildBulletPoint('You can delete your account and all associated data from the app Settings screen'),
            _buildBulletPoint('To request manual deletion, email: support@prodiet.com'),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Contact'),
            const Text(
              'support@prodiet.com',
              style: TextStyle(color: T2Colors.lime, fontWeight: FontWeight.bold),
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: T2Colors.lime, fontSize: 18)),
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
