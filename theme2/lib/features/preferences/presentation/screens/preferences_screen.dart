import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_chip.dart';
import '../../../../shared/widgets/dm_button.dart';
import '../../../../core/theme/text_styles.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Preferences",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 26),
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
            _buildSection(context, "Allergies & Intolerances", [
              const DmChip(label: "Dairy", isSelected: true, color: Color(0xFFFF5C3A)),
              const DmChip(label: "Tree Nuts", isSelected: true, color: Color(0xFFFF5C3A)),
              const DmChip(label: "Gluten", isSelected: false),
              const DmChip(label: "Eggs", isSelected: false),
              const DmChip(label: "Soy", isSelected: false),
              const DmChip(label: "Shellfish", isSelected: false),
              const DmChip(label: "Peanuts", isSelected: false),
              const DmChip(label: "Fish", isSelected: false),
            ]),
            
            _buildSection(context, "Diet Type", [
              const DmChip(label: "Non-Vegetarian", isSelected: true, color: Color(0xFFB8FF00)),
              const DmChip(label: "Vegetarian", isSelected: false),
              const DmChip(label: "Vegan", isSelected: false),
              const DmChip(label: "Keto", isSelected: false),
              const DmChip(label: "Intermittent Fast", isSelected: false),
            ]),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text("General Settings", style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DmCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildPrefRow(context, "Spice level", trailing: _buildSpiceLevel(context, 3)),
                    _buildPrefRow(context, "Meal variety", hasToggle: true, toggleValue: true),
                    _buildPrefRow(context, "Online ordering", hasToggle: true, toggleValue: true),
                    _buildPrefRow(context, "Local vendors", hasToggle: true, toggleValue: false),
                    _buildPrefRow(context, "Fitband sync", hasToggle: true, toggleValue: true),
                  ],
                ),
              ),
            ),

            _buildSection(context, "Cuisine Preferences", [
              const DmChip(label: "North Indian", isSelected: true, color: Color(0xFFB06EFF)),
              const DmChip(label: "Mediterranean", isSelected: true, color: Color(0xFFB06EFF)),
              const DmChip(label: "South Indian", isSelected: false),
              const DmChip(label: "Continental", isSelected: false),
              const DmChip(label: "Asian", isSelected: true, color: Color(0xFFB06EFF)),
              const DmChip(label: "Mexican", isSelected: false),
              const DmChip(label: "Middle Eastern", isSelected: false),
            ]),

            _buildSection(context, "Meal Frequency", [
              const DmChip(label: "3 meals", isSelected: false),
              const DmChip(label: "5 meals", isSelected: true, color: Color(0xFFB8FF00)),
              const DmChip(label: "6 meals", isSelected: false),
              const DmChip(label: "Intermittent", isSelected: false),
            ]),

            Padding(
              padding: const EdgeInsets.all(18),
              child: DmButton(
                label: "Save Preferences", 
                onPressed: () {},
                backgroundColor: const Color(0xFFB8FF00),
                textColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> chips) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.sectionLabel(theme.colorScheme)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: chips),
        ],
      ),
    );
  }

  Widget _buildPrefRow(BuildContext context, String lbl, {Widget? trailing, bool hasToggle = false, bool toggleValue = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outline))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lbl, style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
              if (!hasToggle && lbl == "Spice level") Text("Medium", style: theme.textTheme.bodySmall),
            ],
          ),
          if (hasToggle) _buildToggle(context, toggleValue) else if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildToggle(BuildContext context, bool isOn) {
    final theme = Theme.of(context);
    return Container(
      width: 38,
      height: 20,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isOn ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget _buildSpiceLevel(BuildContext context, int level) {
    final theme = Theme.of(context);
    return Row(
      children: List.generate(5, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: index < level ? theme.colorScheme.primary : const Color(0xFF3A3A35),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
