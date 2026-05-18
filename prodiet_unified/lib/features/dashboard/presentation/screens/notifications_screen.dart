import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/dashboard/application/notification_providers.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/adaptive_notification_widgets.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'NOTIFICATIONS' : 'Notifications'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(notificationsProvider.future),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'RECENT'),
            ),
            notificationsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
              data: (notifs) {
                if (notifs.isEmpty) {
                  return const SliverFillRemaining(
                    child: ProDietEmptyState(
                      icon: Icons.notifications_none_rounded,
                      headline: 'All caught up!',
                      subtext: 'No new notifications to show.',
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final notif = notifs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildNotificationTile(context, ref, notif),
                        );
                      },
                      childCount: notifs.length,
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'PREFERENCES'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildSettingsGroup(context, ref),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Text(
        title,
        style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelSmall).copyWith(
          color: tokens.colors.onSurface.withValues(alpha: 0.3),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, WidgetRef ref, Map<String, dynamic> notif) {
    final type = notif['type'] as String? ?? 'system';
    final isRead = notif['is_read'] as bool? ?? false;
    final createdAt = DateTime.tryParse(notif['created_at'] as String? ?? '') ?? DateTime.now();

    String emoji;
    switch (type) {
      case 'meal': emoji = '🍽️'; break;
      case 'water': emoji = '💧'; break;
      case 'streak': emoji = '🔥'; break;
      default: emoji = 'ℹ️';
    }

    return AdaptiveNotificationTile(
      title: notif['title'] as String? ?? 'Notification',
      subtitle: _formatTime(createdAt),
      emoji: emoji,
      isRead: isRead,
      onTap: () async {
        if (!isRead) {
          await Supabase.instance.client
              .from('notifications')
              .update({'is_read': true})
              .eq('id', notif['id']);
          ref.invalidate(notificationsProvider);
        }
      },
    );
  }

  Widget _buildSettingsGroup(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildSettingsToggle(
            context,
            title: 'MEAL REMINDERS',
            value: settings.meals,
            onChanged: (v) => notifier.toggleMeals(v),
          ),
          Divider(height: 1, color: tokens.colors.onSurface.withValues(alpha: 0.05)),
          _buildSettingsToggle(
            context,
            title: 'HYDRATION ALERTS',
            value: settings.water,
            onChanged: (v) => notifier.toggleWater(v),
          ),
          Divider(height: 1, color: tokens.colors.onSurface.withValues(alpha: 0.05)),
          _buildSettingsToggle(
            context,
            title: 'DAILY SUMMARIES',
            value: settings.daily,
            onChanged: (v) => notifier.toggleDaily(v),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsToggle(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.bodyMedium).copyWith(
          fontWeight: FontWeight.w900,
        ),
      ),
      activeColor: tokens.colors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.tokens.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => const _NotificationSettingsSheet(),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(time);
  }
}

class _NotificationSettingsSheet extends ConsumerWidget {
  const _NotificationSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isT2 ? 'PUSH SETTINGS' : 'Notification Settings',
            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 24) : tokens.typography.headlineSmall).copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          _buildSheetToggle(context, 'MEALS', settings.meals, (v) => notifier.toggleMeals(v)),
          _buildSheetToggle(context, 'WATER', settings.water, (v) => notifier.toggleWater(v)),
          _buildSheetToggle(context, 'DAILY', settings.daily, (v) => notifier.toggleDaily(v)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSheetToggle(BuildContext context, String label, bool value, ValueChanged<bool> onChanged) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900, fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: tokens.colors.primary,
          ),
        ],
      ),
    );
  }
}
