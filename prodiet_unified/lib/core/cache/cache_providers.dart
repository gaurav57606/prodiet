import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'semantic_cache.dart';

final semanticCacheProvider = Provider<SemanticCache>((ref) {
  return SemanticCache(
    ref.watch(supabaseServiceProvider),
    ref.watch(analyticsServiceProvider),
  );
});
