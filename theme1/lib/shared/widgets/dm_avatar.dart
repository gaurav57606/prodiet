import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

class DmAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;

  const DmAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
              )
            : _buildPlaceholder(theme),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    final initials = name != null && name!.isNotEmpty 
        ? name!.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Container(
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }
}
