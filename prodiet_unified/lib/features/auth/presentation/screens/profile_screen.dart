import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/app/app_routes.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/auth/presentation/widgets/adaptive_profile_widgets.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isCurved = tokens.dashboardLayout == AppDashboardLayout.curved;
    final user = ref.watch(currentUserProvider);
    final activeTheme = ref.watch(activeThemeProvider);

    return Scaffold(
      backgroundColor: isCurved ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isCurved ? 'PROFILE' : 'Profile'),
        titleTextStyle: isCurved ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isCurved,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveProfileHeader(
              name: user?.name,
              email: user?.email,
            ),
            const SizedBox(height: 40),

            _buildSectionHeader(context, 'APP SETTINGS'),
            const SizedBox(height: 12),
            _buildContainer(
              context,
              Column(
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
                  _buildThemeOption(
                    context, 
                    ref, 
                    'T2 Neon Pro', 
                    ActiveTheme.t2Dark, 
                    activeTheme == ActiveTheme.t2Dark,
                    Icons.bolt_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'ACCOUNT'),
            const SizedBox(height: 12),
            _buildContainer(
              context,
              Column(
                children: [
                  AdaptiveMenuTile(
                    label: 'Preferences', 
                    icon: Icons.settings_suggest_rounded,
                    onTap: () => context.push(AppRoutes.preferences),
                  ),
                  AdaptiveMenuTile(
                    label: 'Edit Profile', 
                    icon: Icons.person_outline_rounded,
                    onTap: () => _showEditProfileSheet(context, ref, user),
                  ),
                  AdaptiveMenuTile(
                    label: 'Health Goals', 
                    icon: Icons.track_changes_rounded,
                    onTap: () => context.push(AppRoutes.authHealthGoals),
                  ),
                  AdaptiveMenuTile(
                    label: 'Notifications', 
                    icon: Icons.notifications_none_rounded,
                    onTap: () => context.push(AppRoutes.notifications),
                    showBorder: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: FilledButton(
                onPressed: () => _handleLogout(context, ref),
                style: FilledButton.styleFrom(
                  backgroundColor: tokens.colors.error.withValues(alpha: 0.1),
                  foregroundColor: tokens.colors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isCurved ? 16 : 12),
                    side: isCurved ? BorderSide(color: tokens.colors.error.withValues(alpha: 0.5)) : BorderSide.none,
                  ),
                ),
                child: Text(
                  isCurved ? 'SIGN OUT' : 'LOGOUT', 
                  style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w900)
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final tokens = context.tokens;
    final isCurved = tokens.dashboardLayout == AppDashboardLayout.curved;

    return Text(
      title,
      style: (isCurved ? GoogleFonts.barlowCondensed(fontSize: 14) : tokens.typography.labelSmall).copyWith(
        color: tokens.colors.onSurface.withValues(alpha: 0.3),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildContainer(BuildContext context, Widget child) {
    final tokens = context.tokens;
    final isCurved = tokens.dashboardLayout == AppDashboardLayout.curved;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: isCurved ? BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.05)),
      ) : BoxDecoration(
        color: tokens.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
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
    final tokens = context.tokens;
    final isCurved = tokens.dashboardLayout == AppDashboardLayout.curved;

    return ListTile(
      leading: Icon(
        icon, 
        color: isSelected ? tokens.colors.primary : tokens.colors.onSurface.withValues(alpha: 0.5),
        size: 20,
      ),
      title: Text(
        isCurved ? label.toUpperCase() : label, 
        style: (isCurved ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.titleMedium).copyWith(
          color: isSelected ? tokens.colors.primary : tokens.colors.onSurface,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
        )
      ),
      trailing: isSelected ? Icon(Icons.check_circle_rounded, color: tokens.colors.primary, size: 20) : null,
      onTap: () => ref.read(activeThemeProvider.notifier).setTheme(themeMode),
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
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    
    await ref.read(authProvider.notifier).signOut();
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, AppUser? user) {
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final tokens = context.tokens;
    final isCurved = tokens.dashboardLayout == AppDashboardLayout.curved;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tokens.colors.surface,
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
            Text(
              isCurved ? 'EDIT PROFILE' : 'Edit Profile', 
              style: (isCurved ? GoogleFonts.barlowCondensed(fontSize: 24) : tokens.typography.titleLarge).copyWith(fontWeight: FontWeight.w900)
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              style: isCurved ? GoogleFonts.barlowCondensed() : null,
              decoration: InputDecoration(
                labelText: 'Display Name',
                labelStyle: isCurved ? GoogleFonts.barlowCondensed() : null,
                filled: true,
                fillColor: tokens.colors.onSurface.withValues(alpha: 0.05),
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
                    ref.invalidate(authProvider);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
                ),
                child: Text(
                  isCurved ? 'SAVE CHANGES' : 'Save Changes', 
                  style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w900)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
