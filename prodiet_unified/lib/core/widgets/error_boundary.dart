import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({required this.child, super.key});
  final Widget child;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();

  static void reportError(Object error, StackTrace stack) {
    // In production you would send to Sentry/Crashlytics here
    debugPrint('ErrorBoundary caught: $error\n$stack');
  }
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    // Overriding the default ErrorWidget.builder to set the internal error state
    // and show our friendly recovery UI instead of the red screen.
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() => _error = details.exception);
      }
      return const SizedBox.shrink();
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF111111),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('😵', style: TextStyle(fontSize: 52)),
                const SizedBox(height: 20),
                const Text('Something went wrong',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                const SizedBox(height: 10),
                const Text(
                    'The app hit an unexpected error.\nTap below to restart.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF888888), fontSize: 14)),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => setState(() => _error = null),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4F263),
                      minimumSize: const Size(180, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  child: const Text('TRY AGAIN',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widget.child;
  }
}
