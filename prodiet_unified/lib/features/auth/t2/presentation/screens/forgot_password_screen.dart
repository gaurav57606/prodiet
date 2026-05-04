import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(authProvider.notifier).sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset link sent! Check your email inbox.'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop(); // Go back to login after sending
    } catch (_) {
      // AuthFailure state will trigger the ref.listen SnackBar
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = _isSubmitting;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: theme.colorScheme.error,
        ));
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: Stack(
        children: [
          // Top Hero Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.38,
            child: Container(
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
              child: Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1630),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x44B06EFF),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 32,
                    color: Color(0xFFB06EFF),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Form Card
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
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Link
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back,
                              size: 16, color: Color(0xFFB06EFF)),
                          SizedBox(width: 4),
                          Text(
                            "Back to sign in",
                            style: TextStyle(
                              color: Color(0xFFB06EFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Reset ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: "password",
                            style: TextStyle(
                              color: Color(0xFFB06EFF),
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      "Enter your email and we'll send a reset link",
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Email Field
                    const Text(
                      "EMAIL ADDRESS",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DmTextField(
                      controller: _emailController,
                      hint: "name@example.com",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined,
                          size: 20, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    DmButton(
                      label: "Send Reset Link",
                      isLoading: isLoading,
                      backgroundColor: const Color(0xFF1A1A2E),
                      textColor: Colors.white,
                      onPressed: _onSubmit,
                    ),

                    const SizedBox(height: 24),

                    // Info Card
                    _buildInfoCard(context, isLoading),
                  ],
                ),
              ),
            ),
          ),

          if (isLoading)
            const Positioned.fill(
              child: AbsorbPointer(child: SizedBox.shrink()),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A34), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "DIDN'T RECEIVE IT?",
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
              children: [
                const TextSpan(text: "Check spam folder · Wait 2 minutes · "),
                TextSpan(
                  text: "Resend email",
                  style: const TextStyle(
                    color: Color(0xFFB06EFF),
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (_isSubmitting) return;
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Enter your email first")),
                        );
                        return;
                      }
                      await ref
                          .read(authProvider.notifier)
                          .sendPasswordReset(email);
                      if (!context.mounted) return;
                      if (ref.read(authProvider) is! AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Reset email sent again ✓")),
                        );
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
