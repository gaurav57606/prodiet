import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_spacing.dart';

class DmLoader extends StatelessWidget {
  final bool isShimmer;
  final double? width;
  final double? height;
  final double borderRadius;

  const DmLoader.circular({super.key}) 
    : isShimmer = false, width = null, height = null, borderRadius = 0;

  const DmLoader.shimmer({
    super.key, 
    required this.width, 
    required this.height, 
    this.borderRadius = AppSpacing.radiusMedium,
  }) : isShimmer = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isShimmer) {
      return Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest,
        highlightColor: theme.colorScheme.surface,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: theme.colorScheme.primary,
        strokeWidth: 3,
      ),
    );
  }
}
