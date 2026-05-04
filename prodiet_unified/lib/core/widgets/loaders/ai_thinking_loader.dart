import 'dart:async';
import 'package:flutter/material.dart';

class AiThinkingLoader extends StatefulWidget {
  final String mode; // 'diet' or 'ocr'
  const AiThinkingLoader({required this.mode, super.key});

  @override
  State<AiThinkingLoader> createState() => _AiThinkingLoaderState();
}

class _AiThinkingLoaderState extends State<AiThinkingLoader> {
  int _currentStep = 0;
  late Timer _timer;

  final Map<String, List<({String icon, String text})>> _steps = {
    'diet': [
      (icon: '🥗', text: "Reading your fitness goals..."),
      (icon: '🧠', text: "Calculating your calorie targets..."),
      (icon: '📅', text: "Building your 7-day plan..."),
      (icon: '✨', text: "Almost done — adding variety..."),
    ],
    'ocr': [
      (icon: '📸', text: "Reading your grocery bill..."),
      (icon: '🔍', text: "Identifying ingredients..."),
      (icon: '🏷️', text: "Looking up nutritional data..."),
      (icon: '📦', text: "Adding items to your pantry..."),
    ],
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted) {
        setState(() {
          if (_currentStep < 3) {
            _currentStep++;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepData = _steps[widget.mode]?[_currentStep] ?? _steps['diet']![0];

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  stepData.icon,
                  key: ValueKey('icon_$_currentStep'),
                  style: const TextStyle(fontSize: 80),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  stepData.text,
                  key: ValueKey('text_$_currentStep'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 4,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "This usually takes 5–10 seconds",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
