import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({required this.child, super.key});
  final Widget child;

  static void reportError(Object error, StackTrace stack) {
    debugPrint('ErrorBoundary caught: $error\n$stack');
  }

  // Static setup — call this once before runApp
  static void setup() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      debugPrint('ErrorWidget triggered: ${details.exception}');
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

