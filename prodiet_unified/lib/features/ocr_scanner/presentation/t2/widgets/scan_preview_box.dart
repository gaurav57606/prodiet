import 'package:flutter/material.dart';

class ScanPreviewBox extends StatelessWidget {
  const ScanPreviewBox({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lime = theme.colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Stack(
          children: [
            // Corners
            _buildCorner(lime, top: 9, left: 9),
            _buildCorner(lime, top: 9, right: 9, rotate: 1),
            _buildCorner(lime, bottom: 9, left: 9, rotate: 3),
            _buildCorner(lime, bottom: 9, right: 9, rotate: 2),
            
            // Scan Line Placeholder
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, lime, Colors.transparent],
                  ),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scanning...",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: lime,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Hold steady",
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(Color color, {double? top, double? bottom, double? left, double? right, int rotate = 0}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: RotatedBox(
        quarterTurns: rotate,
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: 3),
              left: BorderSide(color: color, width: 3),
            ),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4)),
          ),
        ),
      ),
    );
  }
}
