// -- Run this in Supabase SQL Editor before using this feature:
// CREATE TABLE public.weight_logs (
//   id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
//   user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
//   weight_kg NUMERIC NOT NULL,
//   logged_at TIMESTAMPTZ DEFAULT NOW()
// );
// ALTER TABLE public.weight_logs ENABLE ROW LEVEL SECURITY;
// CREATE POLICY "own_weight" ON public.weight_logs
//   FOR ALL USING (auth.uid() = user_id);

import 'package:prodiet_unified/core/services/supabase_service.dart';
import '../domain/weight_entry.dart';
import '../domain/progress_summary.dart';

class ProgressRepository {
  final SupabaseService _supabase;

  ProgressRepository(this._supabase);

  Future<List<WeightEntry>> getWeightHistory(String userId, {int days = 30}) async {
    final startDate = DateTime.now().subtract(Duration(days: days)).toIso8601String();
    
    final response = await _supabase.perform((client) async {
      return await client
          .from('weight_logs')
          .select()
          .eq('user_id', userId)
          .gte('logged_at', startDate)
          .order('logged_at', ascending: true);
    }, context: 'progress.getWeightHistory');
    
    return (response as List).map((row) => WeightEntry.fromJson(row)).toList();
  }

  Future<void> logWeight(String userId, double weightKg) async {
    await _supabase.perform((client) async {
      // 1. Insert into history
      await client.from('weight_logs').insert({
        'user_id': userId,
        'weight_kg': weightKg,
        'logged_at': DateTime.now().toIso8601String(),
      });

      // 2. Update current weight in users table
      await client
          .from('users')
          .update({'weight_kg': weightKg})
          .eq('id', userId);
    }, context: 'progress.logWeight');
  }

  Future<ProgressSummary> getProgressSummary(String userId, {int days = 30}) async {
    final results = await Future.wait<dynamic>([
      getWeightHistory(userId, days: days),
      _supabase.perform((client) async {
        return await client
            .from('users')
            .select('target_weight_kg, weight_kg')
            .eq('id', userId)
            .single();
      }, context: 'progress.getUserProfileTarget'),
    ]);

    final entries = results[0] as List<WeightEntry>;
    final userProfile = results[1] as Map<String, dynamic>;
    
    final targetWeight = (userProfile['target_weight_kg'] as num? ?? 70.0).toDouble();
    final initialWeight = (userProfile['weight_kg'] as num? ?? 70.0).toDouble();

    return ProgressSummary.calculate(entries, targetWeight, initialWeight);
  }
}
