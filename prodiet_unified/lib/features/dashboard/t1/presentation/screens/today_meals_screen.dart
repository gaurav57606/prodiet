import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/config/feature_flags.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_colors.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/features/meal_planner/domain/daily_meal_summary.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/meal_list_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class TodayMealsScreen extends ConsumerWidget {
  final DateTime? date;
  const TodayMealsScreen({super.key, this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = date ?? DateTime.now();
    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());
    
    final summaryAsync = ref.watch(mealsForDateProvider(selectedDate));
    final dashboardAsync = ref.watch(dashboardProvider);

    final title = isToday ? 'Today\'s Meals' : DateFormat('EEEE, d MMM').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AsyncValueWidget<DailyMealSummary>(
        value: summaryAsync,
        skeleton: const MealListSkeleton(),
        isEmpty: (s) => s.meals.isEmpty,
        emptyState: ProDietEmptyState(
          icon: EmptyStateConfigs.mealPlanner.icon,
          headline: isToday ? 'Nothing logged today' : 'No meals for this day',
          subtext: isToday ? 'Tap + to log your first meal.' : 'Planned meals will appear here.',
          buttonLabel: isToday ? 'Log a Meal' : 'Return to Planner',
          onButtonTap: () => isToday ? _showLogMealSheet(context, ref) : context.pop(),
        ),
        builder: (summary) => ListView(
          padding: const EdgeInsets.all(T1Spacing.lg),
          children: [
            dashboardAsync.when(
              data: (db) => _buildSummaryHeader(theme, summary, db.caloriesGoal),
              loading: () => const SizedBox(height: 100),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: T1Spacing.xl),
            Text(
              'LOGGED MEALS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: T1Spacing.md),
            ...summary.meals.map((meal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMealCard(context, ref, theme, meal),
            )),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'scan_meal',
            onPressed: FeatureFlags.ocrEnabled
                ? () => context.pushNamed(AppRoutes.ocrName)
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📸 Meal scan coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
            backgroundColor: theme.colorScheme.secondary,
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
            label: const Text('SCAN MEAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'log_meal',
            onPressed: () => _showLogMealSheet(context, ref),
            backgroundColor: theme.colorScheme.primary,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text('LOG MEAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme, DailyMealSummary summary, int calorieGoal) {
    final remaining = (calorieGoal - summary.totalCalories).toInt().clamp(0, 9999);
    return DmCard(
      color: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryStat(theme, 'TOTAL KCAL', '${summary.totalCalories.toInt()}', theme.colorScheme.primary),
              _buildSummaryStat(theme, 'REMAINING', '$remaining', const Color(0xFF40D8B8)),
              _buildSummaryStat(theme, 'MEALS', '${summary.eatenCount}/${summary.meals.length}', theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            ],
          ),
          const SizedBox(height: 20),
          _buildMacroBar(theme, summary),
        ],
      ),
    );
  }

  Widget _buildMacroBar(ThemeData theme, DailyMealSummary summary) {
    final totalMacros = summary.totalProteinG + summary.totalCarbsG + summary.totalFatG;
    if (totalMacros == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                Expanded(flex: (summary.totalProteinG * 100 / totalMacros).toInt(), child: Container(color: T1ColorSchemes.macroProtein)),
                const SizedBox(width: 2),
                Expanded(flex: (summary.totalCarbsG * 100 / totalMacros).toInt(), child: Container(color: T1ColorSchemes.macroCarbs)),
                const SizedBox(width: 2),
                Expanded(flex: (summary.totalFatG * 100 / totalMacros).toInt(), child: Container(color: T1ColorSchemes.macroFat)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMacroLabel(theme, 'PROT', '${summary.totalProteinG.toInt()}g', T1ColorSchemes.macroProtein),
            _buildMacroLabel(theme, 'CARB', '${summary.totalCarbsG.toInt()}g', T1ColorSchemes.macroCarbs),
            _buildMacroLabel(theme, 'FAT', '${summary.totalFatG.toInt()}g', T1ColorSchemes.macroFat),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroLabel(ThemeData theme, String label, String value, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildSummaryStat(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(fontSize: 8, color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w900, fontSize: 20)),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, WidgetRef ref, ThemeData theme, Meal meal) {
    final accentColor = _getMealColor(theme, meal.mealType);
    
    return Dismissible(
      key: Key(meal.id),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.onError),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: const Color(0xFF40D8B8), borderRadius: BorderRadius.circular(16)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Mark Eaten', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.check_circle_outline_rounded, color: Colors.black),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Meal?'),
              content: const Text('This will remove the meal from your log.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: Text('DELETE', style: TextStyle(color: theme.colorScheme.error))),
              ],
            ),
          );
          if (result == true) {
            await ref.read(mealRepositoryProvider).deleteMeal(meal.id);
            return true;
          }
        } else if (direction == DismissDirection.endToStart) {
          await ref.read(mealRepositoryProvider).markEaten(meal.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Meal marked as eaten'), duration: Duration(seconds: 1)),
            );
          }
          return false; // Don't remove the card, the StreamProvider will update the state
        }
        return false;
      },
      child: DmCard(
        padding: EdgeInsets.zero,
        color: accentColor.withValues(alpha: 0.06),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.15)),
        child: InkWell(
          onTap: () => _showMealDetailSheet(context, theme, meal),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              meal.mealType.name.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: accentColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusBadge(theme, meal.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(meal.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, fontSize: 18)),
                      ],
                    ),
                    Text('${meal.calories.toInt()} kcal', style: theme.textTheme.titleMedium?.copyWith(color: accentColor, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, MealStatus status) {
    final color = status == MealStatus.eaten ? const Color(0xFF40D8B8) : (status == MealStatus.skipped ? theme.colorScheme.outline : theme.colorScheme.secondary);
    final label = status == MealStatus.eaten ? 'Eaten' : (status == MealStatus.skipped ? 'Skipped' : 'Pending');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Text(label.toUpperCase(), style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900)),
    );
  }

  Color _getMealColor(ThemeData theme, MealType type) {
    switch (type) {
      case MealType.breakfast: return theme.colorScheme.tertiary;
      case MealType.lunch: return theme.colorScheme.secondary;
      case MealType.snack: return const Color(0xFF40D8B8);
      case MealType.dinner: return theme.colorScheme.primary;
    }
  }

  void _showMealDetailSheet(BuildContext context, ThemeData theme, Meal meal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(meal.mealType.name.toUpperCase(), style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroDetail(theme, 'CALORIES', '${meal.calories.toInt()}', theme.colorScheme.onSurface),
                _buildMacroDetail(theme, 'PROTEIN', '${meal.proteinG.toInt()}g', T1ColorSchemes.macroProtein),
                _buildMacroDetail(theme, 'CARBS', '${meal.carbsG.toInt()}g', T1ColorSchemes.macroCarbs),
                _buildMacroDetail(theme, 'FAT', '${meal.fatG.toInt()}g', T1ColorSchemes.macroFat),
              ],
            ),
            const SizedBox(height: 24),
            Text('INGREDIENTS', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withValues(alpha: 0.3), letterSpacing: 1.5)),
            const SizedBox(height: 12),
            if (meal.ingredients.isEmpty)
              Text('No ingredients listed', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)))
            else
              Wrap(
                spacing: 8, 
                runSpacing: 8, 
                children: meal.ingredients.map((i) => Chip(
                  label: Text(i, style: TextStyle(color: theme.colorScheme.onSurface)), 
                  backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  side: BorderSide.none,
                )).toList()
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroDetail(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }

  void _showLogMealSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userId = ref.read(currentUserIdProvider);
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final protController = TextEditingController();
    final carbController = TextEditingController();
    final fatController = TextEditingController();
    MealType selectedType = MealType.breakfast;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final isLogging = ref.watch(isLoggingMealProvider);
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LOG A MEAL', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _inputDecoration(theme, 'Meal Name (e.g. Chicken Salad)'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<MealType>(
                    value: selectedType,
                    dropdownColor: theme.colorScheme.surface,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _inputDecoration(theme, 'Meal Type'),
                    items: MealType.values.map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.name[0].toUpperCase() + t.name.substring(1)),
                    )).toList(),
                    onChanged: (v) => setState(() => selectedType = v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: calController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: _inputDecoration(theme, 'Calories (kcal)'),
                  ),
                  const SizedBox(height: 12),
                  Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text('Macros (optional)', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 14)),
                      tilePadding: EdgeInsets.zero,
                      children: [
                        Row(
                          children: [
                            Expanded(child: TextFormField(controller: protController, keyboardType: TextInputType.number, style: TextStyle(color: theme.colorScheme.onSurface), decoration: _inputDecoration(theme, 'Prot g'))),
                            const SizedBox(width: 8),
                            Expanded(child: TextFormField(controller: carbController, keyboardType: TextInputType.number, style: TextStyle(color: theme.colorScheme.onSurface), decoration: _inputDecoration(theme, 'Carb g'))),
                            const SizedBox(width: 8),
                            Expanded(child: TextFormField(controller: fatController, keyboardType: TextInputType.number, style: TextStyle(color: theme.colorScheme.onSurface), decoration: _inputDecoration(theme, 'Fat g'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: isLogging ? null : () async {
                        final name = nameController.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a meal name')),
                          );
                          return;
                        }

                        final cal = int.tryParse(calController.text.trim());
                        if (cal == null || cal < 0 || cal > 10000) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter a valid calorie amount (0–10,000)')),
                          );
                          return;
                        }

                        ref.read(isLoggingMealProvider.notifier).state = true;
                        try {
                          final protein = double.tryParse(protController.text.trim()) ?? 0.0;
                          final carbs = double.tryParse(carbController.text.trim()) ?? 0.0;
                          final fat = double.tryParse(fatController.text.trim()) ?? 0.0;

                          await ref.read(mealRepositoryProvider).logMeal(
                            userId,
                            name: name,
                            mealType: selectedType,
                            calories: cal.toDouble(),
                            proteinG: protein.clamp(0.0, 1000.0),
                            carbsG: carbs.clamp(0.0, 1000.0),
                            fatG: fat.clamp(0.0, 1000.0),
                          );
                          if (context.mounted) Navigator.pop(context);
                        } finally {
                          ref.read(isLoggingMealProvider.notifier).state = false;
                        }
                      },
                      style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: isLogging 
                        ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2))
                        : const Text('Log Meal', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontSize: 12),
      filled: true,
      fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
