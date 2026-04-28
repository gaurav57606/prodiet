import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.goNamed('t2Onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 40),
                children: [
                  const TextSpan(text: 'DIET'),
                  TextSpan(
                    text: 'MASTER',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  const TextSpan(text: ' PRO'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "EAT RIGHT. LIVE BETTER.",
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 2.0,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
