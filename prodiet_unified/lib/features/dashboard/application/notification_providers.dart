import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';

class NotificationSettings {
  final bool meals;
  final bool water;
  final bool daily;
  final bool streak;

  NotificationSettings({
    this.meals = true,
    this.water = true,
    this.daily = true,
    this.streak = true,
  });

  NotificationSettings copyWith({
    bool? meals,
    bool? water,
    bool? daily,
    bool? streak,
  }) {
    return NotificationSettings(
      meals: meals ?? this.meals,
      water: water ?? this.water,
      daily: daily ?? this.daily,
      streak: streak ?? this.streak,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(NotificationSettings()) {
    _loadSettings();
  }

  static const _kMeals = 'notif_meals';
  static const _kWater = 'notif_water';
  static const _kDaily = 'notif_daily';
  static const _kStreak = 'notif_streak';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      meals: prefs.getBool(_kMeals) ?? true,
      water: prefs.getBool(_kWater) ?? true,
      daily: prefs.getBool(_kDaily) ?? true,
      streak: prefs.getBool(_kStreak) ?? true,
    );
  }

  Future<void> toggleMeals(bool value) async {
    state = state.copyWith(meals: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kMeals, value);
  }

  Future<void> toggleWater(bool value) async {
    state = state.copyWith(water: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWater, value);
  }

  Future<void> toggleDaily(bool value) async {
    state = state.copyWith(daily: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDaily, value);
  }

  Future<void> toggleStreak(bool value) async {
    state = state.copyWith(streak: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kStreak, value);
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});

final notificationsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return [];

  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('notifications')
      .select()
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .limit(20);

  return List<Map<String, dynamic>>.from(response);
});
