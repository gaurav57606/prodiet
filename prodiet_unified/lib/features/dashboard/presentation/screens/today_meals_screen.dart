import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/app/app_routes.dart';
import 'package:prodiet_unified/core/config/feature_flags.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/core/widgets/skeletons/meal_list_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/adaptive_today_meals_widgets.dart';

class TodayMealsScreen extends ConsumerWidget {
  final DateTime? date;
  const TodayMealsScreen({super.key, this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final selectedDate = date ?? DateTime.now();
    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());
    
    final summaryAsync = ref.watch(mealsForDateProvider(selectedDate));
    final dashboardAsync = ref.watch(dashboardProvider);

    final title = isToday ? 'TODAY\'S MEALS' : DateFormat('EEEE, d MMM').format(selectedDate).toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(isT2 ? title : (isToday ? 'Today\'s Meals' : DateFormat('EEEE, d MMM').format(selectedDate))),
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: summaryAsync.when(
        loading: () => const MealListSkeleton(),
        error: (err, st) => const Center(child: Text('Failed to load meals')),
        data: (summary) {
          if (summary.meals.isEmpty) {
            return ProDietEmptyState(
              icon: EmptyStateConfigs.mealPlanner.icon,
              headline: isToday ? (isT2 ? 'NOTHING LOGGED YET' : 'Nothing logged today') : 'No meals for this day',
              subtext: isToday ? 'Tap + to log your first meal.' : 'Planned meals will appear here.',
              buttonLabel: isToday ? (isT2 ? 'LOG A MEAL' : 'Log a Meal') : 'Return to Planner',
              onButtonTap: () => isToday ? _showLogMealSheet(context, ref) : context.pop(),
            );
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: isT2 ? 0 : 16, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dashboardAsync.when(
                        data: (db) => AdaptiveMealSummaryHeader(summary: summary, calorieGoal: db.caloriesGoal),
                        loading: () => const SizedBox(height: 100),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'LOGGED MEALS',
                          style: tokens.typography.labelSmall.copyWith(
                            color: tokens.colors.onSurface.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: isT2 ? 20 : 16),
                sliver: SliverList.builder(
                  itemCount: summary.meals.length,
                  itemBuilder: (context, index) {
                    final meal = summary.meals[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: AdaptiveMealCard(
                        meal: meal,
                        onTap: () => _showMealDetailSheet(context, meal),
                        onMarkEaten: () async {
                          await ref.read(mealRepositoryProvider).markEaten(meal.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Meal marked as eaten'), duration: Duration(seconds: 1)),
                            );
                          }
                        },
                        onDelete: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(isT2 ? 'DELETE MEAL?' : 'Delete Meal?'),
                              content: const Text('This will remove the meal from your log.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true), 
                                  child: Text('DELETE', style: TextStyle(color: tokens.colors.error))
                                ),
                              ],
                            ),
                          );
                          if (result == true) {
                            await ref.read(mealRepositoryProvider).deleteMeal(meal.id);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'scan_meal',
            onPressed: FeatureFlags.ocrEnabled
                ? () => context.push(AppRoutes.ocr)
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📸 Meal scan coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
            backgroundColor: tokens.colors.secondary,
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
            label: Text(isT2 ? 'SCAN MEAL' : 'Scan Meal', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'log_meal',
            onPressed: () => _showLogMealSheet(context, ref),
            backgroundColor: tokens.colors.primary,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: Text(isT2 ? 'LOG MEAL' : 'Log Meal', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _showMealDetailSheet(BuildContext context, Meal meal) {
    final tokens = context.tokens;
    showModalBottomSheet(
      context: context,
      backgroundColor: tokens.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal.name, style: tokens.typography.headlineMedium.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(
              meal.mealType.name.toUpperCase(), 
              style: tokens.typography.labelLarge.copyWith(
                color: tokens.colors.onSurface.withValues(alpha: 0.5), 
                fontWeight: FontWeight.w900, 
                letterSpacing: 1.2
              )
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroDetail(context, 'CALORIES', '${meal.calories.toInt()}', tokens.colors.onSurface),
                _buildMacroDetail(context, 'PROTEIN', '${meal.proteinG.toInt()}g', const Color(0xFF40D8B8)),
                _buildMacroDetail(context, 'CARBS', '${meal.carbsG.toInt()}g', tokens.colors.secondary),
                _buildMacroDetail(context, 'FAT', '${meal.fatG.toInt()}g', tokens.colors.error),
              ],
            ),
            const SizedBox(height: 24),
            Text('INGREDIENTS', style: tokens.typography.labelSmall.copyWith(fontWeight: FontWeight.w900, color: tokens.colors.onSurface.withValues(alpha: 0.3), letterSpacing: 1.5)),
            const SizedBox(height: 12),
            if (meal.ingredients.isEmpty)
              Text('No ingredients listed', style: tokens.typography.bodyMedium.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.3)))
            else
              Wrap(
                spacing: 8, 
                runSpacing: 8, 
                children: meal.ingredients.map((i) => Chip(
                  label: Text(i, style: TextStyle(color: tokens.colors.onSurface)), 
                  backgroundColor: tokens.colors.onSurface.withValues(alpha: 0.05),
                  side: BorderSide.none,
                )).toList()
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroDetail(BuildContext context, String label, String value, Color color) {
    final tokens = context.tokens;
    return Column(
      children: [
        Text(label, style: tokens.typography.labelSmall.copyWith(fontWeight: FontWeight.w900, color: tokens.colors.onSurface.withValues(alpha: 0.3))),
        const SizedBox(height: 4),
        Text(value, style: tokens.typography.headlineSmall.copyWith(fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }

  void _showLogMealSheet(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
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
      backgroundColor: tokens.colors.surface,
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
                  Text('LOG A MEAL', style: tokens.typography.headlineSmall.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    style: TextStyle(color: tokens.colors.onSurface),
                    decoration: _inputDecoration(context, 'Meal Name (e.g. Chicken Salad)'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<MealType>(
                    value: selectedType,
                    dropdownColor: tokens.colors.surface,
                    style: TextStyle(color: tokens.colors.onSurface),
                    decoration: _inputDecoration(context, 'Meal Type'),
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
                    style: TextStyle(color: tokens.colors.onSurface),
                    decoration: _inputDecoration(context, 'Calories (kcal)'),
                  ),
                  const SizedBox(height: 12),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text('Macros (optional)', style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.5), fontSize: 14)),
                      tilePadding: EdgeInsets.zero,
                      children: [
                        Row(
                          children: [
                            Expanded(child: TextFormField(controller: protController, keyboardType: TextInputType.number, style: TextStyle(color: tokens.colors.onSurface), decoration: _inputDecoration(context, 'Prot g'))),
                            const SizedBox(width: 8),
                            Expanded(child: TextFormField(controller: carbController, keyboardType: TextInputType.number, style: TextStyle(color: tokens.colors.onSurface), decoration: _inputDecoration(context, 'Carb g'))),
                            const SizedBox(width: 8),
                            Expanded(child: TextFormField(controller: fatController, keyboardType: TextInputType.number, style: TextStyle(color: tokens.colors.onSurface), decoration: _inputDecoration(context, 'Fat g'))),
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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a meal name')));
                          return;
                        }
                        final cal = int.tryParse(calController.text.trim());
                        if (cal == null || cal < 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid calorie amount')));
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
                      style: FilledButton.styleFrom(
                        backgroundColor: tokens.colors.primary, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                      child: isLogging 
                        ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: tokens.colors.onPrimary, strokeWidth: 2))
                        : Text('Log Meal', style: TextStyle(fontWeight: FontWeight.w900, color: tokens.colors.onPrimary)),
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

  InputDecoration _inputDecoration(BuildContext context, String label) {
    final tokens = context.tokens;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontSize: 12),
      filled: true,
      fillColor: tokens.colors.onSurface.withValues(alpha: 0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
