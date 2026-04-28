import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class DietPlanScreen extends StatelessWidget {
  const DietPlanScreen({super.key});

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
                    'PLAN',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: T2Colors.lime,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: T2Colors.lime.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ACTIVE: HYPERTROPHY 2.0',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                        color: T2Colors.lime,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Macro Target Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildTargetCard('PROTEIN', '180g', 'Target: 2.2g/kg', T2Colors.coral),
                  _buildTargetCard('CARBS', '250g', 'Target: 3.5g/kg', T2Colors.amber),
                  _buildTargetCard('FATS', '70g', 'Target: 0.8g/kg', T2Colors.purple),
                  _buildTargetCard('FIBER', '35g', 'Min: 25g/day', T2Colors.sky),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'WEEKLY OVERVIEW',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: T2Colors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDayCircle('M', true),
                  _buildDayCircle('T', false),
                  _buildDayCircle('W', false),
                  _buildDayCircle('T', false),
                  _buildDayCircle('F', false),
                  _buildDayCircle('S', false),
                  _buildDayCircle('S', false),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: T2Colors.bgDeep,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: T2Colors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.refresh_rounded, color: T2Colors.lime, size: 32),
                    const SizedBox(height: 16),
                    Text(
                      'RECALCULATE PLAN',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Based on your last 7 days performance and current weight (74.2kg)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: T2Colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: T2Colors.lime,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'GENERATE NEW PLAN',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetCard(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: T2Colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              letterSpacing: 1.2,
              color: T2Colors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.barlowCondensed(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            sub,
            style: TextStyle(
              fontSize: 10,
              color: T2Colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCircle(String day, bool isActive) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? T2Colors.lime : T2Colors.bgDeep,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? T2Colors.lime : T2Colors.border,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: TextStyle(
          color: isActive ? Colors.black : T2Colors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }
}
