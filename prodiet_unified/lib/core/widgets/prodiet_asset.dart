import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AssetType {
  image,
  svg,
  auto,
}

/// A unified widget to render ProDiet assets (Images or SVGs)
/// with consistent error handling and scaling.
class ProDietAsset extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final AssetType type;
  final Widget? placeholder;

  const ProDietAsset({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.type = AssetType.auto,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSvg = type == AssetType.svg || 
        (type == AssetType.auto && assetPath.toLowerCase().endsWith('.svg'));

    if (isSvg) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null 
            ? ColorFilter.mode(color!, BlendMode.srcIn) 
            : null,
        placeholderBuilder: (context) => placeholder ?? _buildDefaultPlaceholder(),
      );
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) => 
          placeholder ?? _buildDefaultPlaceholder(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 20, color: Colors.grey),
      ),
    );
  }
}
