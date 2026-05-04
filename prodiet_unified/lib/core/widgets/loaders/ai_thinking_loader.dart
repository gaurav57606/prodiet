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

  final Map<String, List<({IconData icon, String text})>> _steps = {
    'diet': [
      (icon: Icons.restaurant_rounded, text: "Reading your fitness goals..."),
      (icon: Icons.psychology_rounded, text: "Calculating your calorie targets..."),
      (icon: Icons.calendar_today_rounded, text: "Building your 7-day plan..."),
      (icon: Icons.auto_awesome_rounded, text: "Almost done — adding variety..."),
    ],
    'ocr': [
      (icon: Icons.camera_alt_rounded, text: "Reading your grocery bill..."),
      (icon: Icons.search_rounded, text: "Identifying ingredients..."),
      (icon: Icons.label_important_rounded, text: "Looking up nutritional data..."),
      (icon: Icons.inventory_2_rounded, text: "Adding items to your pantry..."),
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
                child: Icon(
                  stepData.icon,
                  key: ValueKey('icon_$_currentStep'),
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
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
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "This usually takes 5–10 seconds",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
