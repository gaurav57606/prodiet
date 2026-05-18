import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/navigation/app_navigator.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/features/auth/presentation/widgets/adaptive_auth_widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  final int _selectedTab = 1; // 0 = Sign In, 1 = Create Account

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms and Privacy Policy')),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await ref.read(authProvider.notifier).signUp(
      email,
      password,
      '$firstName $lastName'.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.displayMessage),
            backgroundColor: tokens.colors.error,
          ),
        );
      }
    });

    return AdaptiveAuthScaffold(
      header: const AdaptiveAuthHeader(
        title: "Create your account",
        subtitle: "Step 1 of 2 — Personal details",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveAuthTabSwitcher(
                  selectedTab: _selectedTab,
                  onTabChanged: (val) {
                    if (val == 0) AppNavigator.toLogin(context);
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'FIRST NAME',
                        controller: _firstNameController,
                        hint: 'John',
                        prefixIcon: isT2 ? const Icon(Icons.person_outline) : null,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        label: 'LAST NAME',
                        controller: _lastNameController,
                        hint: 'Doe',
                        prefixIcon: isT2 ? const Icon(Icons.person_outline) : null,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'EMAIL ADDRESS',
                  controller: _emailController,
                  hint: 'you@example.com',
                  prefixIcon: isT2 ? const Icon(Icons.email_outlined) : null,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'PASSWORD',
                  controller: _passwordController,
                  hint: '••••••••',
                  prefixIcon: isT2 ? const Icon(Icons.lock_outline) : null,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (v) => (v == null || v.length < 8) ? 'Min 8 chars' : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'CONFIRM PASSWORD',
                  controller: _confirmPasswordController,
                  hint: '••••••••',
                  prefixIcon: isT2 ? const Icon(Icons.lock_outline) : null,
                  obscureText: _obscureConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (v) {
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                        activeColor: tokens.colors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.6), fontSize: 13),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms',
                              style: TextStyle(color: tokens.colors.primary, decoration: TextDecoration.underline),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: tokens.colors.primary, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Continue →',
                  isLoading: isLoading,
                  onPressed: _signUp,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
                const _AuthDivider(),
                const SizedBox(height: 24),
                AdaptiveAuthSocialButtons(
                  onGooglePressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                  onApplePressed: () {},
                ),
                const SizedBox(height: 40),
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
            "or sign up with",
            style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.3), fontSize: 11),
          ),
        ),
        Expanded(child: Divider(color: tokens.colors.onSurface.withValues(alpha: 0.1), thickness: 1)),
      ],
    );
  }
}
