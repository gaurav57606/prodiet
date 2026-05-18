import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';

class AdaptiveAuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AdaptiveAuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              Color(0xFF3B1F6B),
              Color(0xFF0D0D0F),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1630),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.track_changes,
                color: Color(0xFFB06EFF),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "DietMaster",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: " Pro",
                    style: TextStyle(color: Color(0xFFB06EFF), fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tokens.colors.surface,
            tokens.colors.surface.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: tokens.colors.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.track_changes,
                color: tokens.colors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(text: 'Pro', style: TextStyle(color: tokens.colors.onSurface)),
                  TextSpan(text: 'Diet', style: TextStyle(color: tokens.colors.primary)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: tokens.colors.onSurface.withValues(alpha: 0.45),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdaptiveAuthTabSwitcher extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;
  const AdaptiveAuthTabSwitcher({super.key, required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return Container(
        height: 46,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E24),
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          children: [
            _buildT2Tab(context, "Sign in", selectedTab == 0, () => onTabChanged(0)),
            _buildT2Tab(context, "Create account", selectedTab == 1, () => onTabChanged(1)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.radius.md),
      ),
      child: Row(
        children: [
          _buildT1Tab(context, 'Sign in', selectedTab == 0, () => onTabChanged(0)),
          _buildT1Tab(context, 'Create account', selectedTab == 1, () => onTabChanged(1)),
        ],
      ),
    );
  }

  Widget _buildT1Tab(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    final tokens = context.tokens;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? tokens.colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(tokens.radius.sm),
          ),
          child: Center(
            child: Text(
              label,
              style: tokens.typography.labelLarge.copyWith(
                color: isSelected ? tokens.colors.onPrimary : tokens.colors.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildT2Tab(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFB06EFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class AdaptiveAuthSocialButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  const AdaptiveAuthSocialButtons({super.key, required this.onGooglePressed, required this.onApplePressed});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return Row(
        children: [
          Expanded(
            child: _buildT2Social(
              label: "Google",
              icon: const Text("G", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
              onPressed: onGooglePressed,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildT2Social(
              label: "Apple",
              icon: const Icon(Icons.apple, color: Colors.white, size: 20),
              onPressed: onApplePressed,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Google',
            variant: AppButtonVariant.outline,
            icon: Icons.g_mobiledata_rounded,
            onPressed: onGooglePressed,
          ),
        ),
      ],
    );
  }

  Widget _buildT2Social({required String label, required Widget icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E24),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF333338)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class AdaptiveAuthScaffold extends StatelessWidget {
  final Widget header;
  final Widget body;
  const AdaptiveAuthScaffold({super.key, required this.header, required this.body});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D0F),
        body: Stack(
          children: [
            Positioned(top: 0, left: 0, right: 0, child: header),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.35,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF111114),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: body,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: Column(
        children: [
          header,
          Expanded(child: body),
        ],
      ),
    );
  }
}
