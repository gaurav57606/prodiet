import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> _signUp() async {
    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim().replaceAll(' ', '');
    final password = _passwordCtrl.text.trim();
    final confirmPassword = _confirmPasswordCtrl.text.trim();

    if (firstName.isEmpty) return _showError("First name is required");
    if (lastName.isEmpty) return _showError("Last name is required");
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      return _showError("Please enter a valid email address");
    }
    if (phone.isNotEmpty && phone.length < 10) {
      return _showError("Phone number must be at least 10 digits");
    }
    if (password.length < 8) {
      return _showError("Password must be at least 8 characters");
    }
    if (password != confirmPassword) {
      return _showError("Passwords do not match");
    }
    if (!_termsAccepted) {
      return _showError("Please accept the Terms of Service");
    }

    // Combine names
    final fullName = '$firstName $lastName';

    // TODO: Add phone support to signUp method if/when repository supports it
    await ref.read(authProvider.notifier).signUp(email, password, fullName);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        _showError(next.error.displayMessage);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB06EFF),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 28,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF333338),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Title & Subtitle
              const Text(
                "Create your account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Step 1 of 2 — Personal details",
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // Tab Switcher
              _buildTabSwitcher(),
              const SizedBox(height: 32),

              // Form Fields
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledField(
                      label: "FIRST NAME",
                      child: DmTextField(
                        controller: _firstNameCtrl,
                        hint: "Rohan",
                        prefixIcon: const Icon(Icons.person_outline, size: 20, color: Color(0xFF666666)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildLabeledField(
                      label: "LAST NAME",
                      child: DmTextField(
                        controller: _lastNameCtrl,
                        hint: "Sharma",
                        prefixIcon: const Icon(Icons.person_outline, size: 20, color: Color(0xFF666666)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _buildLabeledField(
                label: "EMAIL ADDRESS",
                child: DmTextField(
                  controller: _emailCtrl,
                  hint: "you@example.com",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Color(0xFF666666)),
                ),
              ),
              const SizedBox(height: 14),

              _buildLabeledField(
                label: "PHONE (OPTIONAL)",
                child: DmTextField(
                  controller: _phoneCtrl,
                  hint: "+91 98765 43210",
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: Color(0xFF666666)),
                ),
              ),
              const SizedBox(height: 14),

              _buildLabeledField(
                label: "PASSWORD",
                child: DmTextField(
                  controller: _passwordCtrl,
                  hint: "Min. 8 characters",
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20, color: Color(0xFF666666)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xFF666666),
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _buildLabeledField(
                label: "CONFIRM PASSWORD",
                child: DmTextField(
                  controller: _confirmPasswordCtrl,
                  hint: "Re-enter password",
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20, color: Color(0xFF666666)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xFF666666),
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms checkbox row
              GestureDetector(
                onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _termsAccepted ? const Color(0xFFB06EFF) : const Color(0xFF1E1E24),
                        borderRadius: BorderRadius.circular(4),
                        border: _termsAccepted ? null : Border.all(color: const Color(0xFF444444)),
                      ),
                      child: _termsAccepted 
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13, height: 1.4),
                          children: [
                            const TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms of Service",
                              style: const TextStyle(
                                color: Color(0xFFB06EFF),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Terms coming soon")),
                                  );
                                },
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                color: Color(0xFFB06EFF),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.push(AppRoutes.t2PrivacyPolicy),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Continue Button
              DmButton(
                label: "Continue →",
                isLoading: isLoading,
                backgroundColor: const Color(0xFF1A1A2E),
                textColor: Colors.white,
                onPressed: _signUp,
              ),
              const SizedBox(height: 24),

              // Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFF2A2A2E), thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "or sign up with",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFF2A2A2E), thickness: 1)),
                ],
              ),
              const SizedBox(height: 24),

              // Social Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildSocialButton(
                      label: "Google",
                      icon: const Text(
                        "G",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSocialButton(
                      label: "Apple",
                      icon: const Icon(Icons.apple, color: Colors.white, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Apple Sign-In coming soon")),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Bottom Link
              Center(
                child: GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.t2Login),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                        ),
                        TextSpan(
                          text: "Sign in",
                          style: TextStyle(
                            color: Color(0xFFB06EFF),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.goNamed(AppRoutes.t2Login),
              child: Container(
                height: double.infinity,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Text(
                  "Sign in",
                  style: TextStyle(
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFB06EFF),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Create account",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            color: Color(0xFF888888),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
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
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
