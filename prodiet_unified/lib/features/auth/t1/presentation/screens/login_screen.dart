import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.error.displayMessage),
            backgroundColor: scheme.error,
            behavior: SnackBarBehavior.floating,
          ));
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // TOP HERO SECTION
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.surface,
                  scheme.surfaceContainerHighest,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.track_changes,
                      color: scheme.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: null,
                      ),
                      children: [
                        TextSpan(
                            text: 'Pro',
                            style: TextStyle(color: scheme.onSurface)),
                        TextSpan(
                            text: 'Diet',
                            style: TextStyle(color: scheme.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Text(
                    'Your intelligent nutrition companion',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.45),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM SCROLL AREA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TAB TOGGLE
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTab = 0),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 0
                                        ? scheme.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sign in',
                                      style: TextStyle(
                                        color: _selectedTab == 0
                                            ? scheme.onPrimary
                                            : scheme.onSurface
                                                .withValues(alpha: 0.4),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTab = 1),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 1
                                        ? scheme.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Create account',
                                      style: TextStyle(
                                        color: _selectedTab == 1
                                            ? scheme.onPrimary
                                            : scheme.onSurface
                                                .withValues(alpha: 0.4),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (_selectedTab == 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Center(
                            child: TextButton(
                              onPressed: () =>
                                  context.goNamed(AppRoutes.signupName),
                              child: const Text('Go to full signup →'),
                            ),
                          ),
                        ),

                      const SizedBox(height: 32),

                      // FORM SECTION
                      _buildLabel('EMAIL ADDRESS', theme),
                      const SizedBox(height: 8),
                      DmTextField(
                        controller: _emailController,
                        hintText: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Email required' : null,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('PASSWORD', theme),
                          GestureDetector(
                            onTap: () =>
                                context.goNamed(AppRoutes.forgotPasswordName),
                            child: Text(
                              'Forgot?',
                              style: TextStyle(
                                color: scheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DmTextField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        obscureText: _obscurePassword,
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Min 6 characters'
                            : null,
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? "Show password"
                              : "Hide password",
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: scheme.onSurface.withValues(alpha: 0.3),
                            size: 20,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action Button
                      DmButton(
                        label: _selectedTab == 0 ? 'Sign In' : 'Continue →',
                        isLoading: isLoading,
                        onPressed: () async {
                          if (isLoading) return;
                          if (_selectedTab == 1) {
                            context.goNamed(AppRoutes.signupName);
                            return;
                          }
                          if (!(_formKey.currentState?.validate() ?? false))
                            return;
                          await ref.read(authProvider.notifier).signIn(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                        },
                        width: double.infinity,
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Center(
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.3),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Google + Apple Buttons
                      Row(
                        children: [
                          Expanded(
                            child: DmButton(
                              label: 'Google',
                              variant: DmButtonVariant.outline,
                              icon: Icons.g_mobiledata_rounded,
                              onPressed: () => ref
                                  .read(authProvider.notifier)
                                  .signInWithGoogle(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DmButton(
                              label: 'Apple',
                              variant: DmButtonVariant.outline,
                              icon: Icons.apple,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Bottom Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.5)),
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed(AppRoutes.signupName),
                            child: Text(
                              'Create one',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    final scheme = theme.colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}
