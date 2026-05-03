import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
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
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      user?.name != null && user!.name.isNotEmpty 
                        ? user.name.substring(0, 1).toUpperCase() 
                        : 'U',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: T1Spacing.md),
                  Text(
                    user?.name ?? 'User',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    user?.email ?? 'email@example.com',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
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
                    onTap: () {},
                  ),
                  _buildMenuTile(
                    theme, 
                    'Health Goals', 
                    Icons.track_changes_rounded,
                    onTap: () {},
                  ),
                  _buildMenuTile(
                    theme, 
                    'Notifications', 
                    Icons.notifications_none_rounded,
                    onTap: () {},
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
                  backgroundColor: theme.colorScheme.error.withOpacity(0.1),
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
          color: theme.colorScheme.onSurface.withOpacity(0.3),
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
      leading: Icon(icon, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.5)),
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
      leading: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.5)),
      title: Text(label, style: theme.textTheme.titleMedium),
      trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.2)),
      onTap: onTap,
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).signOut();
            },
            child: Text('LOGOUT', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
