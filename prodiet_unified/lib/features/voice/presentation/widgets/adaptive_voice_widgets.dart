import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';

class AdaptiveMicButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;

  const AdaptiveMicButton({
    super.key,
    required this.isListening,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: tokens.colors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: tokens.colors.primary.withValues(alpha: 0.3), 
            width: isT2 ? 3 : 2
          ),
          boxShadow: isListening ? [
            BoxShadow(
              color: tokens.colors.primary.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 10,
            )
          ] : null,
        ),
        child: Center(
          child: Icon(
            isListening ? Icons.stop_rounded : Icons.mic_rounded,
            color: tokens.colors.primary,
            size: 48,
          ),
        ),
      ),
    );
  }
}

class AdaptiveVoiceWaveform extends StatelessWidget {
  final bool isListening;
  final Animation<double> animation;

  const AdaptiveVoiceWaveform({
    super.key,
    required this.isListening,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(12, (i) {
          const bases = [10.0, 20.0, 15.0, 30.0, 18.0, 25.0, 12.0, 22.0, 15.0, 28.0, 10.0, 20.0];
          final h = isListening
            ? bases[i] + (animation.value * bases[i] * 0.8)
            : 6.0;
          return Container(
            width: isT2 ? 4 : 3,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: tokens.colors.primary.withValues(alpha: isListening ? 1.0 : 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
