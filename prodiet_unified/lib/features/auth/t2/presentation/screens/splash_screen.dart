import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: scheme.error,
        ));
      }
    });

    if (_timedOut || authState is AuthFailure) {
      return Scaffold(
        backgroundColor: scheme.surface,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 48, color: Color(0xFFF5A623)),
                  const SizedBox(height: 16),
                  Text(
                    authState is AuthFailure
                        ? 'Authentication Error'
                        : 'Could not connect',
                    style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authState is AuthFailure
                        ? authState.error.displayMessage
                        : 'Connection timed out. Check your internet and try again.',
                    style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 13),
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
                        backgroundColor: scheme.primary,
                        minimumSize: const Size(180, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text('RETRY',
                        style: TextStyle(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      body: const ProDietAuthLoader(message: 'Getting things ready...'),
    );
  }
}
