import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaptiveNotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool isRead;
  final VoidCallback onTap;

  const AdaptiveNotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tokens.colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tokens.colors.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: tokens.colors.onSurface.withValues(alpha: isRead ? 0.5 : 1.0),
                      ),
                    ),
                    Text(
                      subtitle.toUpperCase(),
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tokens.colors.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: tokens.colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: tokens.colors.surfaceContainerHigh,
        child: Text(emoji),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
          color: tokens.colors.onSurface.withValues(alpha: isRead ? 0.6 : 1.0),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.4), fontSize: 12),
      ),
      trailing: isRead ? null : Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: tokens.colors.primary, shape: BoxShape.circle),
      ),
      onTap: onTap,
    );
  }
}
