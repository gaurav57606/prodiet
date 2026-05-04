import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum CacheNamespace {
  nutrition, // TTL: 90 days
  recipe, // TTL: 30 days
  mealPlan, // TTL: 30 days
}

class SemanticCache {
  final SupabaseClient _client;
  final AnalyticsService _analytics;
  SemanticCache(this._client, this._analytics);

  // Returns cached response JSON or null on miss
  Future<Map<String, dynamic>?> get(CacheNamespace namespace, String query,
      {String? userId}) async {
    final hash = _hash(namespace, query);
    try {
      final result = await _client
          .from('ai_cache')
          .select('response_json, expires_at')
          .eq('query_hash', hash)
          .maybeSingle();
      if (result == null) return null;
      // Check expiry
      final expires = DateTime.parse(result['expires_at']);
      if (expires.isBefore(DateTime.now())) {
        await _delete(hash); // clean up stale entry
        return null;
      }
      // Increment hit count async (fire and forget)
      _incrementHit(hash);

      if (userId != null) {
        _analytics.logEvent(
          userId,
          AnalyticsService.kAiCacheHit,
          data: {'namespace': namespace.name},
        );
      }

      return result['response_json'] as Map<String, dynamic>;
    } catch (e) {
      return null; // Cache miss on error — never block the call
    }
  }

  // Store a response in cache
  Future<void> put(CacheNamespace namespace, String query,
      Map<String, dynamic> response) async {
    final hash = _hash(namespace, query);
    final ttl = _ttl(namespace);
    try {
      await _client.from('ai_cache').upsert({
        'namespace': namespace.name,
        'query_hash': hash,
        'response_json': response,
        'hit_count': 0, // Start at 0; RPC increments on reads
        'created_at': DateTime.now().toIso8601String(),
        'expires_at': DateTime.now().add(ttl).toIso8601String(),
      }, onConflict: 'query_hash'); // Explicit conflict target
    } catch (e) {
      // Cache write failure is silent — never block main flow
    }
  }

  // Hash format: '${namespace.name}::${query}' (lowercase, trimmed)
  // MUST match the hash logic in all Supabase edge functions that share this cache table.
  // Edge functions use CacheNamespace.name values: 'nutrition', 'recipe', 'mealPlan'
  String _hash(CacheNamespace ns, String query) {
    final normalized = '${ns.name}::${query.toLowerCase().trim()}';
    return sha256.convert(utf8.encode(normalized)).toString();
  }

  Duration _ttl(CacheNamespace ns) {
    switch (ns) {
      case CacheNamespace.nutrition:
        return const Duration(days: 90);
      case CacheNamespace.recipe:
        return const Duration(days: 30);
      case CacheNamespace.mealPlan:
        return const Duration(days: 30);
    }
  }

  Future<void> _delete(String hash) async {
    await _client.from('ai_cache').delete().eq('query_hash', hash);
  }

  Future<void> _incrementHit(String hash) async {
    try {
      await _client.rpc('increment_cache_hit', params: {'hash': hash});
    } catch (e) {
      // Ignore RPC failure
    }
  }
}
