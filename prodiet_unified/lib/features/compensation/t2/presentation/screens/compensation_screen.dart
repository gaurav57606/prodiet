import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class CompensationScreen extends StatelessWidget {
  const CompensationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADJUST',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: T2Colors.coral,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You missed a meal — here is the fix',
                    style: TextStyle(
                      color: T2Colors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Missed Meal Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: T2Colors.coral.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: T2Colors.coral.withOpacity(0.5), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MISSED MEAL',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: T2Colors.coral,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Morning Snack',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: T2Colors.coral,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '10:00 AM · Almonds + Fruit · 180 kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: T2Colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'IMPACT ANALYSIS',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: T2Colors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildImpactChip('-180 kcal', T2Colors.coral),
                  const SizedBox(width: 8),
                  _buildImpactChip('-6g Protein', T2Colors.coral),
                  const SizedBox(width: 8),
                  _buildImpactChip('-12g Carbs', T2Colors.coral),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: T2Colors.bgElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: T2Colors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: T2Colors.lime.withOpacity(0.05),
                        border: Border(left: BorderSide(color: T2Colors.lime, width: 3)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AUTO-ADJUSTMENT PLAN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                    color: T2Colors.lime,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Distributed across remaining meals',
                                  style: TextStyle(fontSize: 11, color: T2Colors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildAdjustRow('Lunch · 12:30 PM', '+15g protein · Quinoa 100g → 120g', '+15g'),
                    _buildAdjustRow('Dinner · 7:30 PM', '+80 kcal · Extra salmon 30g', '+80'),
                    _buildAdjustRow('Evening Snack', '+12g carbs · Add banana', '+12g', isLast: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: T2Colors.lime,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'ACCEPT ADJUSTMENT',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: T2Colors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'CUSTOMISE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Recalculate entire plan for remaining days ›',
                  style: TextStyle(
                    color: T2Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAdjustRow(String title, String sub, String delta, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: T2Colors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(color: T2Colors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            delta,
            style: GoogleFonts.barlowCondensed(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFB8FF00),
            ),
          ),
        ],
      ),
    );
  }
}
