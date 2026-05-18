import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/navigation/app_navigator.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/features/auth/presentation/widgets/adaptive_auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  int _selectedTab = 0; // 0 = Sign In, 1 = Create Account
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.error.displayMessage),
            backgroundColor: tokens.colors.error,
            behavior: SnackBarBehavior.floating,
          ));
      }
    });

    return AdaptiveAuthScaffold(
      header: AdaptiveAuthHeader(
        title: isT2 ? "DietMaster Pro" : "ProDiet",
        subtitle: 'Your intelligent nutrition companion',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveAuthTabSwitcher(
                  selectedTab: _selectedTab,
                  onTabChanged: (val) => setState(() => _selectedTab = val),
                ),
                if (_selectedTab == 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: TextButton(
                        onPressed: () => AppNavigator.toSignup(context),
                        child: const Text('Go to full signup →'),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'EMAIL ADDRESS',
                  controller: _emailController,
                  hint: 'you@example.com',
                  prefixIcon: isT2 ? const Icon(Icons.email_outlined) : null,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || v.isEmpty) ? 'Email required' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PASSWORD",
                      style: tokens.typography.labelSmall.copyWith(
                        fontWeight: FontWeight.w900,
                        color: tokens.colors.onSurface.withValues(alpha: 0.4),
                        letterSpacing: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => AppNavigator.toForgotPassword(context),
                      child: Text(
                        "Forgot?",
                        style: TextStyle(
                          color: tokens.colors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _passwordController,
                  hint: isT2 ? "Enter password" : "••••••••",
                  prefixIcon: isT2 ? const Icon(Icons.lock_outline) : null,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: _selectedTab == 0 ? 'Sign In' : 'Continue →',
                  isLoading: isLoading,
                  onPressed: () async {
                    if (isLoading) return;
                    if (_selectedTab == 1) {
                      AppNavigator.toSignup(context);
                      return;
                    }
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    await ref.read(authProvider.notifier).signIn(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  },
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
                const _AuthDivider(),
                const SizedBox(height: 24),
                AdaptiveAuthSocialButtons(
                  onGooglePressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                  onApplePressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Apple Sign-In coming soon")),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () => AppNavigator.toSignup(context),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.5), fontSize: 13),
                          ),
                          TextSpan(
                            text: " Create one",
                            style: TextStyle(
                              color: tokens.colors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Expanded(child: Divider(color: tokens.colors.onSurface.withValues(alpha: 0.1), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "or continue with",
            style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontSize: 11),
          ),
        ),
        Expanded(child: Divider(color: tokens.colors.onSurface.withValues(alpha: 0.1), thickness: 1)),
      ],
    );
  }
}
