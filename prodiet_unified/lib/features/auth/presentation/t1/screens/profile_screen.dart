import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_routes.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final activeTheme = ref.watch(activeThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(T1Spacing.lg),
        child: Column(
          children: [
            // User Info
            Center(
              child: Column(
                children: [
                  Builder(builder: (context) {
                    final userName = user?.name;
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Text(
                        (userName != null && userName.isNotEmpty)
                          ? userName.substring(0, 1).toUpperCase() 
                          : 'U',
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: T1Spacing.md),
                  Text(
                    user?.name ?? 'User',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    user?.email ?? 'email@example.com',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: T1Spacing.xl),

            // Theme Settings
            _buildSectionHeader(theme, 'APP SETTINGS'),
            const SizedBox(height: T1Spacing.sm),
            DmCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildThemeOption(
                    context, 
                    ref, 
                    'Light Mode', 
                    ActiveTheme.t1Light, 
                    activeTheme == ActiveTheme.t1Light,
                    Icons.light_mode_rounded,
                  ),
                  _buildThemeOption(
                    context, 
                    ref, 
                    'Dark Mode', 
                    ActiveTheme.t1Dark, 
                    activeTheme == ActiveTheme.t1Dark,
                    Icons.dark_mode_rounded,
                  ),
                  _buildThemeOption(
                    context, 
                    ref, 
                    'AMOLED Mode', 
                    ActiveTheme.t1Amoled, 
                    activeTheme == ActiveTheme.t1Amoled,
                    Icons.blur_on_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: T1Spacing.xl),

            // Account Settings
            _buildSectionHeader(theme, 'ACCOUNT'),
            const SizedBox(height: T1Spacing.sm),
            DmCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildMenuTile(
                    theme, 
                    'Preferences', 
                    Icons.settings_suggest_rounded,
                    onTap: () => context.pushNamed(AppRoutes.t1Preferences),
                  ),
                  _buildMenuTile(
                    theme, 
                    'Edit Profile', 
                    Icons.person_outline_rounded,
                    onTap: () => _showEditProfileSheet(context, ref, user),
                  ),
                  _buildMenuTile(
                    theme, 
                    'Health Goals', 
                    Icons.track_changes_rounded,
                    onTap: () => context.pushNamed(AppRoutes.healthGoalsName),
                  ),
                  _buildMenuTile(
                    theme, 
                    'Notifications', 
                    Icons.notifications_none_rounded,
                    onTap: () => context.pushNamed(AppRoutes.notificationsName),
                  ),
                ],
              ),
            ),
            const SizedBox(height: T1Spacing.xl),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () => _handleLogout(context, ref),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
                  foregroundColor: theme.colorScheme.error,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, 
    WidgetRef ref, 
    String label, 
    ActiveTheme themeMode, 
    bool isSelected,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5)),
      title: Text(label, style: theme.textTheme.titleMedium?.copyWith(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
      )),
      trailing: isSelected ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary) : null,
      onTap: () => ref.read(activeThemeProvider.notifier).setTheme(themeMode),
    );
  }

  Widget _buildMenuTile(ThemeData theme, String label, IconData icon, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
      title: Text(label, style: theme.textTheme.titleMedium),
      trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
      onTap: onTap,
    );
  }


  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    
    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    
    await ref.read(authProvider.notifier).signOut();
    // Router redirect handles navigation — no need to pop manually
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, AppUser? user) {
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 24, right: 24, top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EDIT PROFILE', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Display Name',
                filled: true,
                fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  if (user != null) {
                    await ref.read(authRepositoryProvider).updateProfile(user.id, {'name': name});
                    ref.invalidate(authProvider); // Refresh user
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


