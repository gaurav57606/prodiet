import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? tokens.colors.secondary.withValues(alpha: 0.1),
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null || imageUrl!.isEmpty
          ? Center(
              child: Text(
                _getInitials(name),
                style: tokens.typography.bodyMedium.copyWith(
                  color: tokens.colors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.4,
                ),
              ),
            )
          : null,
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
