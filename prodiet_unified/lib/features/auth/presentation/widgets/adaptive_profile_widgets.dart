import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaptiveProfileHeader extends StatelessWidget {
  final String? name;
  final String? email;

  const AdaptiveProfileHeader({
    super.key,
    this.name,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return _buildT2(context);
    }
    return _buildT1(context);
  }

  Widget _buildT1(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: tokens.colors.primary.withValues(alpha: 0.1),
          child: Text(
            (name != null && name!.isNotEmpty) ? name!.substring(0, 1).toUpperCase() : 'U',
            style: tokens.typography.displayMedium.copyWith(
              color: tokens.colors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name ?? 'User',
          style: tokens.typography.headlineSmall.copyWith(fontWeight: FontWeight.w900),
        ),
        Text(
          email ?? 'email@example.com',
          style: tokens.typography.bodyMedium.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5)),
        ),
      ],
    );
  }

  Widget _buildT2(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: tokens.colors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  (name != null && name!.isNotEmpty) ? name!.substring(0, 1).toUpperCase() : 'U',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (name ?? 'USER').toUpperCase(),
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: tokens.colors.onSurface,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    (email ?? 'EMAIL@EXAMPLE.COM').toUpperCase(),
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tokens.colors.primary.withValues(alpha: 0.7),
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AdaptiveMenuTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool showBorder;

  const AdaptiveMenuTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return _buildT2(context);
    }
    return _buildT1(context);
  }

  Widget _buildT1(BuildContext context) {
    final tokens = context.tokens;
    return ListTile(
      leading: Icon(icon, color: tokens.colors.onSurface.withValues(alpha: 0.5)),
      title: Text(label, style: tokens.typography.titleMedium),
      trailing: Icon(Icons.chevron_right_rounded, color: tokens.colors.onSurface.withValues(alpha: 0.2)),
      onTap: onTap,
    );
  }

  Widget _buildT2(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          border: showBorder ? Border(bottom: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.1))) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: tokens.colors.primary, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: GoogleFonts.barlowCondensed(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: tokens.colors.onSurface,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: tokens.colors.outline, size: 14),
          ],
        ),
      ),
    );
  }
}
