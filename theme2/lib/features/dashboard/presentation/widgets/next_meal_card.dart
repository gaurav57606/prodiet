import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/core/theme/color_schemes.dart';
import 'package:dietmate_pro/shared/widgets/dm_macro_chip.dart';

class NextMealCard extends StatelessWidget {
  const NextMealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: AppColors.lime),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "LUNCH · 12:30 PM",
                            style: TextStyle(
                              fontSize: 8,
                              letterSpacing: 1.2,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.lime.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "In 2h 15m",
                              style: TextStyle(
                                color: AppColors.lime,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        "Quinoa Bowl\n+ Grilled Chicken",
                        style: GoogleFonts.barlowCondensed(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '480',
                                  style: GoogleFonts.barlowCondensed(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.lime,
                                  ),
                                ),
                                TextSpan(
                                  text: ' kcal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.lime.withOpacity(0.1),
                              border: Border.all(color: AppColors.lime.withOpacity(0.25)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'High protein',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.lime,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: AppColors.border)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: DmMacroChip(
                              value: "38g",
                              label: "Protein",
                              type: MacroType.protein,
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: DmMacroChip(
                              value: "45g",
                              label: "Carbs",
                              type: MacroType.carbs,
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: DmMacroChip(
                              value: "12g",
                              label: "Fat",
                              type: MacroType.fat,
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: DmMacroChip(
                              value: "4g",
                              label: "Fibre",
                              type: MacroType.fibre,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildButton('Mark Done', AppColors.lime, Colors.black, true),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildButton('Swap Meal', AppColors.lime, AppColors.lime, false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color, Color textColor, bool isFilled) {
    return Container(
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFilled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isFilled ? null : Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
