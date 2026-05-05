import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_spacing.dart';

class DmLoader extends StatelessWidget {
  final bool isShimmer;
  final double? width;
  final double? height;
  final double? borderRadius;

  const DmLoader({
    super.key,
    this.isShimmer = false,
    this.width,
    this.height,
    this.borderRadius,
  });

  const DmLoader.circular({super.key})
      : isShimmer = false,
        width = null,
        height = null,
        borderRadius = null;

  const DmLoader.shimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  }) : isShimmer = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!isShimmer) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
          strokeWidth: 3,
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      highlightColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.02),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusMd),
        ),
      ),
    );
  }
}
