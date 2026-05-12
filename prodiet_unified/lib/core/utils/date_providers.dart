import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that returns the current time.
/// Can be overridden in tests to ensure deterministic results.
final nowProvider = Provider<DateTime>((ref) => DateTime.now());
