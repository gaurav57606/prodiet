import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/water_log.dart';
import '../domain/water_summary.dart';

class WaterRepository {
  final SupabaseClient _supabase;

  WaterRepository(this._supabase);

  Future<WaterSummary> getTodaySummary(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final results = await Future.wait<dynamic>([
      _supabase
          .from('water_logs')
          .select('amount_ml')
          .eq('user_id', userId)
          .eq('date', today),
      _supabase
          .from('users')
          .select('daily_water_goal_ml')
          .eq('id', userId)
          .single(),
    ]);

    final logs = results[0] as List<dynamic>;
    final userData = results[1] as Map<String, dynamic>;
    final targetMl = (userData['daily_water_goal_ml'] as num? ?? 2000).toInt();

    int total = 0;
    for (var log in logs) {
      total += (log['amount_ml'] as num).toInt();
    }

    return WaterSummary(
      totalMl: total,
      targetMl: targetMl,
      glasses: (total / 250).floor(),
      targetGlasses: (targetMl / 250).floor(),
    );
  }

  Future<void> logGlass(String userId, {int ml = 250}) async {
    await logCustomAmount(userId, ml);
  }

  Future<void> logCustomAmount(String userId, int ml) async {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    
    final data = {
      'user_id': userId,
      'amount_ml': ml,
      'logged_at': now.toIso8601String(),
      'date': date.toIso8601String().split('T')[0],
    };
    
    await _supabase.from('water_logs').insert(data);
  }

  Future<void> deleteLastLog(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final lastLog = await _supabase
        .from('water_logs')
        .select('id')
        .eq('user_id', userId)
        .eq('date', today)
        .order('logged_at', ascending: false)
        .limit(1)
        .maybeSingle();
    
    if (lastLog != null) {
      await _supabase.from('water_logs').delete().eq('id', lastLog['id']);
    }
  }

  Stream<List<WaterLog>> watchTodayLogs(String userId) {
    final today = DateTime.now().toIso8601String().split('T')[0];

    return _supabase
        .from('water_logs')
        .stream(primaryKey: ['id'])
        .eq('date', today)                    // Server-side date filter
        .map((data) => data
            .where((row) => row['user_id'] == userId) // Client-side user filter
            .map((row) => WaterLog.fromJson(row))
            .toList()
            ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt)));
  }
}
