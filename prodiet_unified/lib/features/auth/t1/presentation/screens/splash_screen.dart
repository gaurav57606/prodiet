import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/core/widgets/loading_widget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timeoutTimer;
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    // Safety timeout — if auth never resolves in 8s, show error
    _timeoutTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) setState(() => _timedOut = true);
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, ) {
    final authState = ref.watch(authProvider);

    if (_timedOut || authState is AuthFailure) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    authState is AuthFailure ? 'Authentication Error' : 'Could not connect',
                    style: const TextStyle(color: Colors.white, fontSize: 20,
                      fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authState is AuthFailure
                      ? authState.error.displayMessage
                      : 'Connection timed out. Check your internet and try again.',
                    style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _timedOut = false);
                      _timeoutTimer?.cancel();
                      _timeoutTimer = Timer(const Duration(seconds: 8), () {
                        if (mounted) setState(() => _timedOut = true);
                      });
                      ref.invalidate(authProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4F263),
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                    child: const Text('RETRY',
                      style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: Color(0xFF08080F),
      body: ProDietAuthLoader(message: 'Getting things ready...'),
    );
  }
}
