import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaptiveVendorMatchCard extends StatelessWidget {
  final String platform;
  final Color platformColor;
  final String match;
  final List<Widget> items;

  const AdaptiveVendorMatchCard({
    super.key,
    required this.platform,
    required this.platformColor,
    required this.match,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isT2 ? platform.toUpperCase() : platform,
                  style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.titleMedium).copyWith(
                    color: platformColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tokens.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    match,
                    style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
                      color: tokens.colors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class AdaptiveVendorItemTile extends StatelessWidget {
  final String name;
  final String restaurant;
  final String macros;
  final String price;
  final bool isBest;
  final VoidCallback onTap;

  const AdaptiveVendorItemTile({
    super.key,
    required this.name,
    required this.restaurant,
    required this.macros,
    required this.price,
    this.isBest = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isT2 ? name.toUpperCase() : name,
                    style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 18) : tokens.typography.titleSmall).copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    isT2 ? restaurant.toUpperCase() : restaurant,
                    style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    macros,
                    style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 11) : tokens.typography.labelSmall).copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: tokens.colors.primary,
                  ),
                ),
                if (isBest)
                  Text(
                    isT2 ? 'BEST MATCH' : 'Best Match',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: tokens.colors.primary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
