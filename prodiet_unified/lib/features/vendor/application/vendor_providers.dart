import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/features/vendor/data/vendor_repository.dart';

import 'package:prodiet_unified/core/services/analytics_service.dart';

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  final analytics = ref.watch(analyticsServiceProvider);
  return VendorRepository(supabase, analytics);
});
