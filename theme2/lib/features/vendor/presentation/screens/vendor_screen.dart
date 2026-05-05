import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_button.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final purple = const Color(0xFFB06EFF);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order & Restock",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 24),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: purple.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SEARCHING FOR YOUR DIET", style: theme.textTheme.labelSmall?.copyWith(color: purple, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                    const SizedBox(height: 3),
                    Text("Quinoa Bowl + Grilled Chicken · 480 kcal · 38g protein", style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text("Best Matches · Order Food", style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
            ),

            _buildVendorCard(context, "Zomato", const Color(0xFFE23744), "94% match", [
              {'nm': 'Protein Quinoa Bowl', 'rest': 'Fitbowl Kitchen · 1.2km · 25 min', 'macros': '482 kcal · 40g P · 44g C · 11g F', 'price': '₹320', 'isBest': true},
              {'nm': 'Grilled Chicken Salad', 'rest': 'Healthy Bites · 2.4km · 35 min', 'macros': '390 kcal · 36g P · 22g C · 14g F', 'price': '₹280', 'isBest': false},
            ]),

            _buildVendorCard(context, "Swiggy", const Color(0xFFFC8019), "87% match", [
              {'nm': 'Chicken Quinoa Power Bowl', 'rest': 'The Macro Kitchen · 3.1km · 40 min', 'macros': '510 kcal · 42g P · 50g C · 13g F', 'price': '₹350', 'isBest': false},
            ]),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
              child: Text("Local Vendors Near You", style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DmCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        border: Border(bottom: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.15))),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Searched 8 vendors near Sector 14", style: theme.textTheme.titleMedium?.copyWith(fontSize: 12, color: theme.colorScheme.primary)),
                          Text("Message sent · Awaiting price replies", style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    _buildLocalVendor(context, "R", "Ramesh Grocery", "0.3km", "Replied ✓"),
                    _buildLocalVendor(context, "S", "Sharma Kirana", "0.6km", "Pending...", isPending: true),
                    _buildLocalVendor(context, "M", "Modern Provision", "1.1km", "Replied ✓"),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: DmButton(label: "Order from Zomato — ₹320", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCard(BuildContext context, String platform, Color platformColor, String match, List<Map<String, dynamic>> items) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outline))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(platform, style: theme.textTheme.titleLarge?.copyWith(fontSize: 13, color: platformColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                    child: Text(match, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontSize: 10)),
                  ),
                ],
              ),
            ),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['nm'], style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
                        Text(item['rest'], style: theme.textTheme.bodySmall),
                        Text(item['macros'], style: theme.textTheme.bodySmall?.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(item['price'], style: theme.textTheme.displayMedium?.copyWith(fontSize: 16, color: theme.colorScheme.primary)),
                      if (item['isBest']) Text("Best", style: theme.textTheme.bodySmall?.copyWith(fontSize: 9)),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalVendor(BuildContext context, String av, String nm, String dist, String msg, {bool isPending = false}) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outline))),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Center(child: Text(av, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: primary))),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nm, style: theme.textTheme.titleSmall),
                Text(dist, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Text(msg, style: theme.textTheme.labelSmall?.copyWith(color: isPending ? theme.colorScheme.onSurfaceVariant : primary)),
        ],
      ),
    );
  }
}
