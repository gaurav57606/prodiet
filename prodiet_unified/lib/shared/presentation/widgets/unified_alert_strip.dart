import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';

class UnifiedAlertStrip extends StatelessWidget {
  final String message;
  final String subMessage;
  final bool isWarning;

  const UnifiedAlertStrip({
    super.key,
    required this.message,
    required this.subMessage,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = isWarning ? const Color(0xFFFFB040) : tokens.colors.primary;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.symmetric(
          horizontal: BorderSide(color: color.withValues(alpha: 0.20), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isWarning ? Icons.bolt : Icons.warning_amber_rounded,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: tokens.typography.labelMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subMessage,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'View ›',
            style: tokens.typography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
