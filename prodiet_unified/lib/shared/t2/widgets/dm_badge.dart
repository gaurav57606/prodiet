import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class DmBadge extends StatelessWidget {
  final Widget child;
  final String? label;
  final Color? color;

  const DmBadge({
    super.key,
    required this.child,
    this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (label != null)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: color ?? const Color(0xFFFF5C3A), // T2 Danger/Error color
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: T2Colors.bgDefault, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Center(
                child: Text(
                  label!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
