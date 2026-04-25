import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/utils/extensions.dart';

class DmAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? fallbackText;

  const DmAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colorScheme.primary.withOpacity(0.1),
        border: Border.all(color: context.colorScheme.primary.withOpacity(0.2), width: 1.5),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildFallback(context),
                errorWidget: (context, url, error) => _buildFallback(context),
              )
            : _buildFallback(context),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Center(
      child: Text(
        fallbackText?.isNotEmpty == true ? fallbackText![0].toUpperCase() : '?',
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
