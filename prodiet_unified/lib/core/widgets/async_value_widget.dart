import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'error_widget.dart';
import 'loading_widget.dart';

// Generic wrapper — eliminates boilerplate .when() in every screen
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  const AsyncValueWidget({
    required this.value,
    required this.builder,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const ProDietLoader(),
      error: (e, _) {
        final appError = e is AppError
          ? e : UnknownError(message: e.toString());
        return ProDietErrorWidget(error: appError, onRetry: onRetry);
      },
      data: builder,
    );
  }
}
