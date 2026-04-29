import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/widgets/loading_widget.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch authProvider to ensure the app stays on splash until session is checked.
    // GoRouter's redirect logic will handle navigation once state is non-Loading.
    ref.watch(authProvider);

    return const Scaffold(
      body: ProDietAuthLoader(
        message: "Getting things ready...",
      ),
    );
  }
}

