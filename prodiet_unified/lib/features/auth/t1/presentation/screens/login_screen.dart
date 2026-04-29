import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  int _selectedTab = 0; // 0 = Sign In, 1 = Create Account
  bool _keepSignedIn = true;
  bool _obscurePassword = true;

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

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.error.displayMessage),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ));
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // TOP HERO SECTION
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A0030),
                  Color(0xFF0D0020),
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
                      color: const Color(0xFF2A1050),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.track_changes,
                      color: Color(0xFFC080FF),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter', // Assuming Inter is the default
                      ),
                      children: [
                        TextSpan(text: 'DietMaster', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'Pro', style: TextStyle(color: Color(0xFFC080FF))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Text(
                    'Your intelligent nutrition companion',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TAB TOGGLE
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedTab == 0 ? const Color(0xFF8B5CF6) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: _selectedTab == 0 ? Colors.white : Colors.white.withValues(alpha: 0.4),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.go('/t1/signup');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedTab == 1 ? const Color(0xFF8B5CF6) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Create account',
                                  style: TextStyle(
                                    color: _selectedTab == 1 ? Colors.white : Colors.white.withValues(alpha: 0.4),
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
                  const SizedBox(height: 32),

                  // FORM SECTION
                  _buildLabel('EMAIL ADDRESS'),
                  const SizedBox(height: 8),
                  DmTextField(
                    controller: _emailController,
                    hintText: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('PASSWORD'),
                      GestureDetector(
                        onTap: () => context.go('/t1/forgot-password'),
                        child: const Text(
                          'Forgot?',
                          style: TextStyle(
                            color: Color(0xFF8B5CF6),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Keep me signed in
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _keepSignedIn,
                          onChanged: (val) => setState(() => _keepSignedIn = val ?? false),
                          activeColor: const Color(0xFF8B5CF6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Keep me signed in',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sign In Button
                  DmButton(
                    label: 'Sign In',
                    isLoading: isLoading,
                    onPressed: () async {
                      if (isLoading) return;
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
                        color: Colors.white.withValues(alpha: 0.3),
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
                          onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
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
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/t1/signup'),
                        child: const Text(
                          'Create one',
                          style: TextStyle(
                            color: Color(0xFF8B5CF6),
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
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}
