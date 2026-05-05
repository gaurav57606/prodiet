import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/features/dashboard/application/notification_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_empty_state.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
              child: _buildSectionHeader(context, 'TODAY'),
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
                    child: DmEmptyState(
                      title: 'All caught up!',
                      message: 'Notifications will appear here.',
                      icon: Icons.notifications_none_rounded,
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final notif = notifs[index];
                      return _buildNotificationTile(context, ref, notif);
                    },
                    childCount: notifs.length,
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'SETTINGS'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DmCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildSettingsToggle(
                        context,
                        ref,
                        title: 'Meal Reminders',
                        subtitle: 'Remind me before scheduled meals',
                        value: ref.watch(notificationSettingsProvider.select((s) => s.meals)),
                        onChanged: (val) => ref.read(notificationSettingsProvider.notifier).toggleMeals(val),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildSettingsToggle(
                        context,
                        ref,
                        title: 'Hydration Reminders',
                        subtitle: 'Remind me to drink water every 2 hours',
                        value: ref.watch(notificationSettingsProvider.select((s) => s.water)),
                        onChanged: (val) => ref.read(notificationSettingsProvider.notifier).toggleWater(val),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildSettingsToggle(
                        context,
                        ref,
                        title: 'Daily Summary',
                        subtitle: 'Send me my daily progress at 9 PM',
                        value: ref.watch(notificationSettingsProvider.select((s) => s.daily)),
                        onChanged: (val) => ref.read(notificationSettingsProvider.notifier).toggleDaily(val),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildSettingsToggle(
                        context,
                        ref,
                        title: 'Streak Alerts',
                        subtitle: 'Alert me if my streak is at risk',
                        value: ref.watch(notificationSettingsProvider.select((s) => s.streak)),
                        onChanged: (val) => ref.read(notificationSettingsProvider.notifier).toggleStreak(val),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, WidgetRef ref, Map<String, dynamic> notif) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(
        notif['title'] as String? ?? 'Notification',
        style: TextStyle(
          fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
          color: isRead ? scheme.onSurface.withValues(alpha: 0.7) : scheme.onSurface,
        ),
      ),
      subtitle: Text(
        _formatTime(createdAt),
        style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.4), fontSize: 12),
      ),
      trailing: isRead ? null : Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
      ),
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

  Widget _buildSettingsToggle(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5), fontSize: 12)),
      activeColor: scheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(time);
  }
}

class _NotificationSettingsSheet extends ConsumerWidget {
  const _NotificationSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notification Settings',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildQuickToggle(
            context,
            'Meal Reminders',
            settings.meals,
            (v) => notifier.toggleMeals(v),
          ),
          _buildQuickToggle(
            context,
            'Hydration Alerts',
            settings.water,
            (v) => notifier.toggleWater(v),
          ),
          _buildQuickToggle(
            context,
            'Daily Summaries',
            settings.daily,
            (v) => notifier.toggleDaily(v),
          ),
          _buildQuickToggle(
            context,
            'Streak Guard',
            settings.streak,
            (v) => notifier.toggleStreak(v),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickToggle(BuildContext context, String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
