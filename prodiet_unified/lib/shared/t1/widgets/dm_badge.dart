import 'package:flutter/material.dart';

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
                color: color ?? theme.colorScheme.error,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.scaffoldBackgroundColor, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Center(
                child: Text(
                  label!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
