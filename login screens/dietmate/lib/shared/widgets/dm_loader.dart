import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/utils/extensions.dart';

class DmLoader extends StatelessWidget {
  final bool isShimmer;
  final double? width;
  final double? height;
  final double borderRadius;

  const DmLoader.circular({super.key})
      : isShimmer = false,
        width = null,
        height = null,
        borderRadius = 0;

  const DmLoader.shimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  }) : isShimmer = true;

  @override
  Widget build(BuildContext context) {
    if (!isShimmer) {
      return Center(
        child: CircularProgressIndicator(
          color: context.colorScheme.primary,
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceVariant.withOpacity(0.3),
      highlightColor: context.colorScheme.surfaceVariant.withOpacity(0.1),
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
}
