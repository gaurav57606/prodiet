import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';

class DietPlanDetailScreen extends StatelessWidget {
  final DietDay day;
  const DietPlanDetailScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'DAY ${day.dayNumber} DETAILS',
          style: GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMealSection('BREAKFAST', day.breakfast, T2Colors.lime, Icons.wb_sunny_outlined),
          const SizedBox(height: 16),
          _buildMealSection('LUNCH', day.lunch, T2Colors.amber, Icons.wb_cloudy_outlined),
          const SizedBox(height: 16),
          _buildMealSection('DINNER', day.dinner, T2Colors.coral, Icons.nightlight_outlined),
          const SizedBox(height: 16),
          _buildMealSection('SNACKS', day.snacks, T2Colors.sky, Icons.apple_outlined),
        ],
      ),
    );
  }

  Widget _buildMealSection(String title, String content, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: T2Colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: color, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.barlowCondensed(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700, height: 1.2),
          ),
        ],
      ),
    );
  }
}
