import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate/core/router/app_router.dart';
import 'package:dietmate/core/utils/extensions.dart';

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

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.goNamed('onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    context.colorScheme.primary,
                    context.colorScheme.secondary,
                  ],
                ),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 24),
            Text(
              'DietMaster Pro',
              style: context.textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}

