import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/vendor/data/vendor_repository.dart';

import 'package:prodiet_unified/core/services/analytics_providers.dart';

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final analytics = ref.watch(analyticsServiceProvider);
  return VendorRepository(supabase, analytics);
});
