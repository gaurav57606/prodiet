import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/widgets/loading_widget.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/sync/connection_monitor.dart';

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
    _timeoutTimer = Timer(const Duration(seconds: 20), () {
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
    final tokens = context.tokens;
    final scheme = tokens.colors;
    final authState = ref.watch(authProvider);
    final connectionStatus = ref.watch(connectionMonitorProvider);

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: scheme.error,
        ));
      }
    });

    if (_timedOut || authState is AuthFailure) {
      String title = 'Could not connect';
      String message = 'Connection timed out. Check your internet and try again.';

      if (authState is AuthFailure) {
        title = 'Authentication Error';
        message = authState.error.displayMessage;
      } else if (connectionStatus == ConnectionStatus.offline) {
        title = 'No Internet Connection';
        message = 'It looks like you are completely offline. Check your network and try again.';
      } else if (connectionStatus == ConnectionStatus.degraded) {
        title = 'Server Unreachable';
        message = 'The server is taking too long to respond. We will keep trying to connect.';
      } else {
        title = 'Connection Slow';
        message = 'The connection is taking longer than expected. Please wait or try again.';
      }

      return Scaffold(
        backgroundColor: scheme.surface,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 48, color: Color(0xFFF5A623)),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: tokens.typography.headlineSmall.copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: tokens.typography.bodySmall.copyWith(color: scheme.onSurface.withValues(alpha: 0.6)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _timedOut = false);
                      _timeoutTimer?.cancel();
                      _timeoutTimer = Timer(const Duration(seconds: 20), () {
                        if (mounted) setState(() => _timedOut = true);
                      });
                      ref.invalidate(authProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('RETRY', style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w900)),
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
