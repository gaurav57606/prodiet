import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/vendor/presentation/widgets/adaptive_vendor_widgets.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({super.key});

  Future<void> _openPlatform(String query, String platform) async {
    final String url = platform.toLowerCase() == 'zomato'
        ? 'https://www.zomato.com/search?q=$query'
        : 'https://www.swiggy.com/search?query=$query';
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    
    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'ORDER & RESTOCK' : 'Order Food'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDietSearchAlert(context),
            const SizedBox(height: 32),
            
            _buildSectionLabel(context, 'BEST MATCHES'),
            const SizedBox(height: 16),
            
            AdaptiveVendorMatchCard(
              platform: 'Zomato',
              platformColor: const Color(0xFFE23744),
              match: '94% MATCH',
              items: [
                AdaptiveVendorItemTile(
                  name: 'Protein Quinoa Bowl',
                  restaurant: 'Fitbowl Kitchen · 1.2km',
                  macros: '482 kcal · 40g P · 44g C · 11g F',
                  price: '₹320',
                  isBest: true,
                  onTap: () => _openPlatform('Protein Quinoa Bowl', 'Zomato'),
                ),
                AdaptiveVendorItemTile(
                  name: 'Grilled Chicken Salad',
                  restaurant: 'Healthy Bites · 2.4km',
                  macros: '390 kcal · 36g P · 22g C · 14g F',
                  price: '₹280',
                  onTap: () => _openPlatform('Grilled Chicken Salad', 'Zomato'),
                ),
              ],
            ),

            AdaptiveVendorMatchCard(
              platform: 'Swiggy',
              platformColor: const Color(0xFFFC8019),
              match: '87% MATCH',
              items: [
                AdaptiveVendorItemTile(
                  name: 'Chicken Quinoa Power Bowl',
                  restaurant: 'The Macro Kitchen · 3.1km',
                  macros: '510 kcal · 42g P · 50g C · 13g F',
                  price: '₹350',
                  onTap: () => _openPlatform('Chicken Quinoa Power Bowl', 'Swiggy'),
                ),
              ],
            ),

            const SizedBox(height: 32),
            _buildSectionLabel(context, 'LOCAL VENDORS'),
            const SizedBox(height: 16),
            
            _buildLocalVendorsGroup(context),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () => _openPlatform("Protein Quinoa Bowl", "Zomato"),
                style: isT2 ? FilledButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ) : null,
                child: Text(
                  isT2 ? 'ORDER FROM ZOMATO — ₹320' : 'Order Now — ₹320',
                  style: isT2 ? GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900, fontSize: 16) : null,
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDietSearchAlert(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    const purple = Color(0xFFB06EFF);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isT2 ? 'SEARCHING FOR YOUR DIET' : 'Optimizing for your Plan',
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
              color: purple,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Quinoa Bowl + Grilled Chicken · 480 kcal',
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.titleSmall).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String title) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Text(
      title,
      style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelSmall).copyWith(
        color: tokens.colors.onSurface.withValues(alpha: 0.3),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLocalVendorsGroup(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.colors.primary.withValues(alpha: 0.05),
              border: Border(bottom: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.05))),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on_rounded, size: 16, color: tokens.colors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isT2 ? 'SEARCHED 8 VENDORS NEAR SECTOR 14' : '8 Nearby Grocery Stores Found',
                    style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
                      color: tokens.colors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildLocalVendorTile(context, "R", "Ramesh Grocery", "0.3km", "Replied ✓"),
          _buildLocalVendorTile(context, "S", "Sharma Kirana", "0.6km", "Pending...", isPending: true),
          _buildLocalVendorTile(context, "M", "Modern Provision", "1.1km", "Replied ✓", isLast: true),
        ],
      ),
    );
  }

  Widget _buildLocalVendorTile(BuildContext context, String av, String nm, String dist, String msg, {bool isPending = false, bool isLast = false}) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: tokens.colors.primary.withValues(alpha: 0.1),
            child: Text(av, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: tokens.colors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isT2 ? nm.toUpperCase() : nm,
                  style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.titleSmall).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(dist, style: tokens.typography.labelSmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.4))),
              ],
            ),
          ),
          Text(
            isT2 ? msg.toUpperCase() : msg,
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 12) : tokens.typography.labelSmall).copyWith(
              color: isPending ? tokens.colors.onSurface.withValues(alpha: 0.3) : tokens.colors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
