// ── USAGE PATTERN FOR ALL FEATURE SCREENS ──────────
//
// LOADING STATE → pass skeleton:
//   AsyncValueWidget(
//     value: ref.watch(mealsProvider),
//     skeleton: const MealListSkeleton(),
//     builder: (meals) => MealList(meals: meals),
//   )
//
// EMPTY STATE → pass emptyState + isEmpty check:
//   AsyncValueWidget(
//     value: ref.watch(inventoryProvider),
//     skeleton: const MealListSkeleton(),
//     isEmpty: (items) => items.isEmpty,
//     emptyState: ProDietEmptyState(
//       emoji: EmptyStateConfigs.inventory.emoji,
//       headline: EmptyStateConfigs.inventory.headline,
//       subtext: EmptyStateConfigs.inventory.subtext,
//       buttonLabel: EmptyStateConfigs.inventory.buttonLabel,
//       onButtonTap: () => context.push(AppRoutes.t1Ocr),
//     ),
//     builder: (items) => InventoryList(items: items),
//   )
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'loading_widget.dart';
import 'error_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final Widget? skeleton; // custom skeleton for loading state
  final Widget? emptyState; // shown when data is empty list/null
  final bool Function(T)? isEmpty; // optional check for "is data empty?"
  final VoidCallback? onRetry; // callback for retry button

  const AsyncValueWidget({
    required this.value,
    required this.builder,
    this.skeleton,
    this.emptyState,
    this.isEmpty,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => skeleton ?? const ProDietLoader(),
      error: (e, st) {
        final appError =
            e is AppError ? e : UnknownError(message: e.toString());
        return ProDietErrorWidget(error: appError, onRetry: onRetry);
      },
      data: (data) {
        if (isEmpty != null && isEmpty!(data) && emptyState != null) {
          return emptyState!;
        }
        return builder(data);
      },
    );
  }
}
