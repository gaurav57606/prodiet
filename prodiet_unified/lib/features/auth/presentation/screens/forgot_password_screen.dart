import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/presentation/widgets/adaptive_auth_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
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
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final isLoading = _isSubmitting;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: tokens.colors.error,
        ));
      }
    });

    return AdaptiveAuthScaffold(
      header: AdaptiveAuthHeader(
        title: isT2 ? "Reset password" : "Reset Password",
        subtitle: "Enter your email and we'll send a reset link",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Link
            GestureDetector(
              onTap: () => context.pop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: isT2 ? const Color(0xFFB06EFF) : tokens.colors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Back to sign in",
                    style: TextStyle(
                      color: isT2 ? const Color(0xFFB06EFF) : tokens.colors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Email Field
            Text(
              "EMAIL ADDRESS",
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                color: isT2 ? const Color(0xFF888888) : tokens.colors.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _emailController,
              hint: "name@example.com",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 20,
                color: isT2 ? const Color(0xFF666666) : tokens.colors.onSurface.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            AppButton(
              label: "Send Reset Link",
              isLoading: isLoading,
              onPressed: _onSubmit,
              width: double.infinity,
            ),

            const SizedBox(height: 32),

            // Info Card
            _buildInfoCard(context, tokens, isT2),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppThemeTokens tokens, bool isT2) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isT2 ? const Color(0xFF1A1A20) : tokens.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isT2 ? const Color(0xFF2A2A34) : tokens.colors.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DIDN'T RECEIVE IT?",
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              color: isT2 ? const Color(0xFF666666) : tokens.colors.onSurface.withValues(alpha: 0.3),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: isT2 ? const Color(0xFF888888) : tokens.colors.onSurface.withValues(alpha: 0.5),
                fontSize: 12,
              ),
              children: [
                const TextSpan(text: "Check spam folder · Wait 2 minutes · "),
                TextSpan(
                  text: "Resend email",
                  style: TextStyle(
                    color: isT2 ? const Color(0xFFB06EFF) : tokens.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (_isSubmitting) return;
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter your email first")),
                        );
                        return;
                      }
                      await ref.read(authProvider.notifier).sendPasswordReset(email);
                      if (!context.mounted) return;
                      if (ref.read(authProvider) is! AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Reset email sent again ✓")),
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
