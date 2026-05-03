import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.displayMessage),
          backgroundColor: theme.colorScheme.error,
        ));
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(T2Spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset Password",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: T2Spacing.xs),
            Text(
              _isSuccess 
                ? "If an account exists for this email, you will receive a reset link shortly."
                : "Enter your email address and we'll send you a link to reset your password.",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: T2Spacing.xxl),
            if (!_isSuccess) ...[
              DmTextField(
                controller: _emailController,
                label: "Email Address",
                hint: "name@example.com",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
              ),
              const SizedBox(height: T2Spacing.xl),
              DmButton(
                label: "Send Reset Link",
                isLoading: isLoading,
                onPressed: () async {
                  if (isLoading) return;
                  final email = _emailController.text.trim();
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter your email"),
                    ));
                    return;
                  }
                  
                  await ref.read(authProvider.notifier).sendPasswordReset(email);
                  if (mounted && ref.read(authProvider) is! AuthFailure) {
                    setState(() => _isSuccess = true);
                  }
                },
              ),
            ] else ...[
              DmButton(
                label: "Back to Login",
                variant: DmButtonVariant.outline,
                onPressed: () => context.pop(),
              ),
            ],
            const SizedBox(height: T2Spacing.xl),
          ],
        ),
      ),
    );
  }
}
