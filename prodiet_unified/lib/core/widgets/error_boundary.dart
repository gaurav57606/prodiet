import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/observability/logger/app_logger.dart';

class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({required this.child, super.key});
  final Widget child;

  static void reportError(Object error, StackTrace stack) {
    AppLogger.critical('ErrorBoundary caught uncaught exception', error: error, stack: stack, feature: 'widget_boundary');
  }

  // Static setup — call this once before runApp
  static void setup() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      AppLogger.critical('ErrorWidget rendering boundary triggered', error: details.exception, stack: details.stack, feature: 'widget_render');
      return const _FallbackErrorWidget();
    };
  }

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _FallbackErrorWidget extends StatelessWidget {
  const _FallbackErrorWidget();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('😵', style: TextStyle(fontSize: 52)),
                  SizedBox(height: 20),
                  Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: null,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please restart the app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                      fontFamily: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when the app launches without required --dart-define-from-file env vars.
/// Only visible in debug mode. In release, the app silently skips backend init.
class MissingConfigScreen extends StatelessWidget {
  final List<String> missingVars;
  const MissingConfigScreen({super.key, required this.missingVars});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚠️ Missing Config',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The app cannot connect to the backend.\nThe following environment variables are missing:',
                  style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 15),
                ),
                const SizedBox(height: 16),
                ...missingVars.map((v) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFF6B35), width: 1),
                    ),
                    child: Text(
                      v,
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'flutter run --dart-define-from-file=.env.json',
                    style: TextStyle(
                      color: Color(0xFF58A6FF),
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Or press F5 in VS Code after the .vscode/launch.json is created.',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
