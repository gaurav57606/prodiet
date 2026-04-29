import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/features/meal_planner/domain/daily_meal_summary.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/meal_list_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';

class TodayMealsScreen extends ConsumerWidget {
  const TodayMealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(todayMealsProvider);
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Meals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AsyncValueWidget<DailyMealSummary>(
        value: summaryAsync,
        skeleton: const MealListSkeleton(),
        isEmpty: (s) => s.meals.isEmpty,
        emptyState: ProDietEmptyState(
          emoji: '🍽️',
          headline: 'Nothing logged today',
          subtext: 'Tap + to log your first meal.',
          buttonLabel: 'Log a Meal',
          onButtonTap: () => _showLogMealSheet(context, ref),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogMealSheet(context, ref),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('LOG MEAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme, DailyMealSummary summary, int calorieGoal) {
    return DmCard(
      color: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryStat(theme, 'TOTAL KCAL', '${summary.totalCalories.toInt()}', theme.colorScheme.primary),
              _buildSummaryStat(theme, 'REMAINING', '${(calorieGoal - summary.totalCalories).toInt().clamp(0, 9999)}', const Color(0xFF40D8B8)),
              _buildSummaryStat(theme, 'MEALS', '${summary.eatenCount}/${summary.meals.length}', Colors.white.withValues(alpha: 0.5)),
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
                Expanded(flex: (summary.totalProteinG * 100 / totalMacros).toInt(), child: Container(color: const Color(0xFFC080FF))),
                const SizedBox(width: 2),
                Expanded(flex: (summary.totalCarbsG * 100 / totalMacros).toInt(), child: Container(color: const Color(0xFFFF8C64))),
                const SizedBox(width: 2),
                Expanded(flex: (summary.totalFatG * 100 / totalMacros).toInt(), child: Container(color: const Color(0xFF40D8B8))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMacroLabel(theme, 'PROT', '${summary.totalProteinG.toInt()}g', const Color(0xFFC080FF)),
            _buildMacroLabel(theme, 'CARB', '${summary.totalCarbsG.toInt()}g', const Color(0xFFFF8C64)),
            _buildMacroLabel(theme, 'FAT', '${summary.totalFatG.toInt()}g', const Color(0xFF40D8B8)),
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
    final accentColor = _getMealColor(meal.mealType);
    final timeStr = DateFormat('hh:mm a').format(meal.createdAt);
    
    return Dismissible(
      key: Key(meal.id),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: const Color(0xFF40D8B8), borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.check_circle_outline_rounded, color: Colors.black),
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
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('DELETE', style: TextStyle(color: Colors.red))),
              ],
            ),
          );
          if (result == true) {
            await ref.read(mealRepositoryProvider).deleteMeal(meal.id);
            return true;
          }
        } else if (direction == DismissDirection.endToStart) {
          await ref.read(mealRepositoryProvider).markEaten(meal.id);
          return false; // Don't remove the card, the StreamProvider will update the state
        }
        return false;
      },
      child: DmCard(
        padding: EdgeInsets.zero,
        color: accentColor.withValues(alpha: 0.06),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.15)),
        child: InkWell(
          onTap: () => _showMealDetailSheet(context, meal),
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
                              '${meal.mealType.name.toUpperCase()} · $timeStr',
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
              if (meal.status == MealStatus.pending)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1), border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => ref.read(mealRepositoryProvider).markSkipped(meal.id),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                          child: const Text('SKIP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white70)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => ref.read(mealRepositoryProvider).markEaten(meal.id),
                          style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                          child: const Text('EATEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black)),
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

  Widget _buildStatusBadge(ThemeData theme, MealStatus status) {
    final color = status == MealStatus.eaten ? const Color(0xFF40D8B8) : (status == MealStatus.skipped ? Colors.redAccent : Colors.orangeAccent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Text(status.name.toUpperCase(), style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900)),
    );
  }

  Color _getMealColor(MealType type) {
    switch (type) {
      case MealType.breakfast: return const Color(0xFFC080FF);
      case MealType.lunch: return const Color(0xFFFF8C64);
      case MealType.snack: return const Color(0xFF40D8B8);
      case MealType.dinner: return const Color(0xFF4C84FF);
    }
  }

  void _showMealDetailSheet(BuildContext context, Meal meal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 8),
            Text(meal.mealType.name.toUpperCase(), style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroDetail('CALORIES', '${meal.calories.toInt()}', Colors.white),
                _buildMacroDetail('PROTEIN', '${meal.proteinG.toInt()}g', const Color(0xFFC080FF)),
                _buildMacroDetail('CARBS', '${meal.carbsG.toInt()}g', const Color(0xFFFF8C64)),
                _buildMacroDetail('FAT', '${meal.fatG.toInt()}g', const Color(0xFF40D8B8)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('INGREDIENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white30, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            if (meal.ingredients.isEmpty)
              const Text('No ingredients listed', style: TextStyle(color: Colors.white24))
            else
              Wrap(spacing: 8, runSpacing: 8, children: meal.ingredients.map((i) => Chip(label: Text(i), backgroundColor: Colors.white.withValues(alpha: 0.05))).toList()),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroDetail(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white30)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }

  void _showLogMealSheet(BuildContext context, WidgetRef ref) {
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
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LOG A MEAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 20),
              TextField(controller: nameController, decoration: _inputDecoration('Meal Name (e.g. Chicken Salad)')),
              const SizedBox(height: 12),
              DropdownButtonFormField<MealType>(
                value: selectedType,
                dropdownColor: const Color(0xFF1E293B),
                decoration: _inputDecoration('Meal Type'),
                items: MealType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextField(controller: calController, keyboardType: TextInputType.number, decoration: _inputDecoration('Calories (kcal)')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: protController, keyboardType: TextInputType.number, decoration: _inputDecoration('Prot g'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: carbController, keyboardType: TextInputType.number, decoration: _inputDecoration('Carb g'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: fatController, keyboardType: TextInputType.number, decoration: _inputDecoration('Fat g'))),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || calController.text.isEmpty) return;
                    ref.read(isLoggingMealProvider.notifier).state = true;
                    await ref.read(mealRepositoryProvider).logMeal(
                      userId,
                      name: nameController.text,
                      mealType: selectedType,
                      calories: double.parse(calController.text),
                      proteinG: double.tryParse(protController.text) ?? 0,
                      carbsG: double.tryParse(carbController.text) ?? 0,
                      fatG: double.tryParse(fatController.text) ?? 0,
                    );
                    ref.read(isLoggingMealProvider.notifier).state = false;
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C84FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: ref.watch(isLoggingMealProvider) 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('LOG MEAL', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white30, fontSize: 12),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
