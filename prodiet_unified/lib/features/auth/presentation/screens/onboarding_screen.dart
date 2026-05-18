import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Precision Nutrition',
      description: 'Track your macros with clinical accuracy and AI-powered suggestions.',
      icon: Icons.track_changes_rounded,
    ),
    OnboardingData(
      title: 'Smart Meal Planning',
      description: 'Personalized meal plans that adapt to your taste and inventory.',
      icon: Icons.auto_awesome_rounded,
    ),
    OnboardingData(
      title: 'Real-time Sync',
      description: 'Sync your activity data from fitbands and get instant adjustments.',
      icon: Icons.sync_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: isT2 
                              ? const Color(0xFFB06EFF).withValues(alpha: 0.1)
                              : tokens.colors.primary.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            data.icon,
                            size: 80,
                            color: isT2 ? const Color(0xFFB06EFF) : tokens.colors.primary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          data.title,
                          style: tokens.typography.headlineLarge.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: tokens.colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.description,
                          style: tokens.typography.bodyLarge.copyWith(
                            color: tokens.colors.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _currentPage == index ? 24 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? (isT2 ? const Color(0xFFB06EFF) : tokens.colors.primary)
                              : (isT2 ? const Color(0xFFB06EFF).withValues(alpha: 0.2) : tokens.colors.primary.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/auth/login');
                      }
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    label: 'Skip',
                    variant: AppButtonVariant.ghost,
                    onPressed: () => context.go('/auth/login'),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
