import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import 'semantic_cache.dart';

final semanticCacheProvider = Provider<SemanticCache>((ref) {
  return SemanticCache(
    ref.watch(supabaseClientProvider),
    ref.watch(analyticsServiceProvider),
  );
});
