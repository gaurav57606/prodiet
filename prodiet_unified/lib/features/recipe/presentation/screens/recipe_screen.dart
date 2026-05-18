import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/recipe/presentation/widgets/adaptive_recipe_widgets.dart';
import 'package:prodiet_unified/shared/presentation/widgets/unified_alert_strip.dart';
import 'package:prodiet_unified/shared/presentation/widgets/unified_variety_toggle.dart';
import 'package:prodiet_unified/core/design_system/components/app_chip.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';
import 'package:prodiet_unified/core/design_system/components/app_badge.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/recipe/application/recipe_providers.dart';
import 'package:prodiet_unified/features/recipe/domain/recipe.dart';
import 'package:prodiet_unified/features/shopping_list/application/shopping_providers.dart';
import 'package:prodiet_unified/features/shopping_list/domain/models/shopping_item.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/design_system/app_accessibility.dart';

extension RecipeExoticExtension on Recipe {
  bool get isExotic => id == 'r4' || id == 'r5';
}

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  bool _isLeftSelected = true; // For variety toggle on T2 (true = Standard, false = Exotic)

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.curved;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      appBar: AppBar(
        title: Text(isT2 ? 'RECIPES' : 'Recipes'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : tokens.typography.titleMedium.copyWith(fontWeight: FontWeight.w900),
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.curved;
    
    // Watch dynamic matching recipes provider
    final recipesAsyncVal = ref.watch(matchingRecipesProvider);
    final activeAllergens = ref.watch(allergyFiltersProvider);

    return recipesAsyncVal.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => Center(
        child: Text('Failed to load recipes: $err'),
      ),
      data: (allResults) {
        // Filter by T2 variety toggle if active
        List<MatchingRecipeResult> filtered = allResults;
        if (isT2) {
          if (_isLeftSelected) {
            // Standard/usual recipes (exclude exotic)
            filtered = allResults.where((r) => !r.recipe.isExotic).toList();
          } else {
            // Exotic recipes
            filtered = allResults.where((r) => r.recipe.isExotic).toList();
          }
        }

        // Sum up total matching items in stock across the highest matched standard recipe
        final highestMatch = filtered.isNotEmpty ? filtered.first : null;
        final inStockCount = highestMatch?.inStockCount ?? 0;

        return CustomScrollView(
          slivers: [
            if (isT2) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: UnifiedVarietyToggle(
                    leftLabel: "Standard",
                    rightLabel: "Exotic",
                    isLeftSelected: _isLeftSelected,
                    onChanged: (val) {
                      setState(() {
                        _isLeftSelected = val;
                      });
                    },
                  ),
                ),
              ),
            ],

            // Beautiful stats / matching summary banner
            SliverToBoxAdapter(
              child: filtered.isNotEmpty
                  ? UnifiedAlertStrip(
                      message: "$inStockCount ingredients in stock match these",
                      subMessage: "Tap to view recipes you can cook right now!",
                      isWarning: inStockCount == 0,
                    )
                  : const UnifiedAlertStrip(
                      message: "No recipes found matching current filters",
                      subMessage: "Try disabling some allergen filters below",
                      isWarning: true,
                    ),
            ),

            // Recipe Cards Section
            if (filtered.isEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.kitchen_outlined,
                          size: 64,
                          color: tokens.colors.onSurface.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Pantry is Empty",
                          style: tokens.typography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add ingredients to unlock matches!",
                          style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () => context.push('/voice'),
                          icon: const Icon(Icons.mic_rounded),
                          label: const Text("Use Voice Assistant"),
                          style: FilledButton.styleFrom(
                            backgroundColor: tokens.colors.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                sliver: SliverList.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return AdaptiveRecipeCard(
                      title: item.recipe.name,
                      type: item.recipe.type,
                      match: "${item.matchPercentage.toStringAsFixed(0)}%",
                      isExotic: item.recipe.isExotic,
                      onTap: () => _showRecipeInspectorSheet(context, item),
                    );
                  },
                ),
              ),
            ],

            // Allergy Filter Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ALLERGY FILTER", 
                      style: tokens.typography.labelSmall.copyWith(
                        fontWeight: FontWeight.w900,
                        color: tokens.colors.onSurface.withValues(alpha: 0.3),
                        letterSpacing: isT2 ? 1.2 : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildAllergenChip("Dairy", activeAllergens),
                        _buildAllergenChip("Nuts", activeAllergens),
                        _buildAllergenChip("Gluten", activeAllergens),
                        _buildAllergenChip("Eggs", activeAllergens),
                        _buildAllergenChip("Soy", activeAllergens),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        );
      },
    );
  }

  Widget _buildAllergenChip(String name, Set<String> activeAllergens) {
    final lowerName = name.toLowerCase();
    final isSelected = activeAllergens.contains(lowerName);

    return AppChip(
      label: name.toUpperCase(),
      isSelected: isSelected,
      color: isSelected ? const Color(0xFFFF5C3A) : null,
      onTap: () {
        final current = ref.read(allergyFiltersProvider);
        if (current.contains(lowerName)) {
          ref.read(allergyFiltersProvider.notifier).state = current.difference({lowerName});
        } else {
          ref.read(allergyFiltersProvider.notifier).state = current.union({lowerName});
        }
      },
    );
  }

  void _showRecipeInspectorSheet(BuildContext context, MatchingRecipeResult matchResult) {
    final tokens = context.tokens;
    final recipe = matchResult.recipe;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tokens.colors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Beautiful dragging indicator
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: tokens.colors.outline.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header with badge and title
                  Row(
                    children: [
                      AppBadge(
                        label: recipe.type,
                        backgroundColor: tokens.colors.primary.withValues(alpha: 0.15),
                        textColor: tokens.colors.primary,
                      ),
                      const SizedBox(width: 8),
                      if (recipe.isExotic)
                        const AppBadge(
                          label: 'EXOTIC',
                          backgroundColor: Colors.purpleAccent,
                          textColor: Colors.white,
                        ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: tokens.colors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${matchResult.matchPercentage.toStringAsFixed(0)}% MATCH",
                              style: tokens.typography.labelSmall.copyWith(
                                color: tokens.colors.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe.name,
                    style: tokens.typography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Ready in 20 mins • ${recipe.calories} kcal",
                    style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Macro ring details
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final useWrap = context.useAccessibilityLayout || constraints.maxWidth < 400;
                      return useWrap
                          ? Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                _buildMacroProgress("Protein", "${recipe.protein}g", 0.75, tokens.colors.primary),
                                _buildMacroProgress("Carbs", "${recipe.carbs}g", 0.35, Colors.amberAccent),
                                _buildMacroProgress("Fats", "${recipe.fats}g", 0.55, Colors.redAccent),
                                _buildMacroProgress("Fiber", "4g", 0.20, Colors.tealAccent),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: _buildMacroProgress("Protein", "${recipe.protein}g", 0.75, tokens.colors.primary)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildMacroProgress("Carbs", "${recipe.carbs}g", 0.35, Colors.amberAccent)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildMacroProgress("Fats", "${recipe.fats}g", 0.55, Colors.redAccent)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildMacroProgress("Fiber", "4g", 0.20, Colors.tealAccent)),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Ingredients checklist
                  Text(
                    "INGREDIENTS CHECK",
                    style: tokens.typography.labelSmall.copyWith(
                      fontWeight: FontWeight.w900,
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.requiredIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = recipe.requiredIngredients[index];
                      // Check if matches in stock
                      final inStock = matchResult.inStockIngredients.any(
                        (i) => i.name.toLowerCase().trim() == ingredient.name.toLowerCase().trim(),
                      );

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: tokens.colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: inStock 
                                ? Colors.green.withValues(alpha: 0.2) 
                                : Colors.orange.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              inStock ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                              color: inStock ? Colors.greenAccent : Colors.orangeAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "${ingredient.quantity} ${ingredient.unit} ${ingredient.name}",
                              style: tokens.typography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                decoration: inStock ? null : TextDecoration.lineThrough,
                                decorationColor: tokens.colors.onSurface.withValues(alpha: 0.3),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              inStock ? "IN PANTRY" : "MISSING",
                              style: tokens.typography.labelSmall.copyWith(
                                fontWeight: FontWeight.w900,
                                color: inStock ? Colors.greenAccent : Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Quick Add Missing Items to Shopping List Action
                  if (matchResult.missingIngredients.isNotEmpty) ...[
                    Consumer(
                      builder: (context, ref, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () async {
                              final authState = ref.read(authProvider);
                              if (authState is! AuthAuthenticated) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please log in to update shopping list.')),
                                );
                                return;
                              }

                              for (var ing in matchResult.missingIngredients) {
                                final item = ShoppingItem(
                                  id: "shop_${DateTime.now().microsecondsSinceEpoch}_${ing.name.replaceAll(' ', '_')}",
                                  userId: authState.user.id,
                                  ingredientName: ing.name,
                                  quantity: ing.quantity,
                                  unit: ing.unit,
                                  isPurchased: false,
                                  source: 'recipe_missing',
                                );
                                await ref.read(shoppingActionsProvider.notifier).addItem(item);
                              }

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added ${matchResult.missingIngredients.length} missing items to your shopping list!',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: tokens.colors.primary,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                            label: const Text(
                              "QUICK ADD MISSING TO SHOPPING LIST",
                              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: tokens.colors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Cooking Steps
                  Text(
                    "COOKING INSTRUCTIONS",
                    style: tokens.typography.labelSmall.copyWith(
                      fontWeight: FontWeight.w900,
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.steps.length,
                    itemBuilder: (context, index) {
                      final step = recipe.steps[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: tokens.colors.primary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${index + 1}",
                                style: tokens.typography.labelSmall.copyWith(
                                  color: tokens.colors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                step,
                                style: tokens.typography.bodyMedium.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMacroProgress(String label, String value, double pct, Color color) {
    final tokens = context.tokens;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              value: pct,
              backgroundColor: tokens.colors.outline.withValues(alpha: 0.1),
              color: color,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: tokens.typography.labelLarge.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            label.toUpperCase(),
            style: tokens.typography.labelSmall.copyWith(
              fontSize: 8,
              color: tokens.colors.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
