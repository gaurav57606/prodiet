import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              "Welcome Back",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: T2Spacing.xs),
            Text(
              "Log in to your ProDiet account",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: T2Spacing.xxl),
            DmTextField(
              controller: _emailController,
              label: "Email Address",
              hint: "name@example.com",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, size: 20),
            ),
            const SizedBox(height: T2Spacing.lg),
            DmTextField(
              controller: _passwordController,
              label: "Password",
              hint: "Enter your password",
              obscureText: _obscurePassword,
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/t2/forgot-password'),
                child: Text(
                  "Forgot Password?",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: T2Spacing.xl),
            DmButton(
              label: "Login",
              isLoading: isLoading,
              onPressed: () {
                if (isLoading) return;
                ref.read(authProvider.notifier).signIn(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
              },
            ),
            const SizedBox(height: T2Spacing.xl),
            Row(
              children: [
                Expanded(child: Divider(color: theme.colorScheme.outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: T2Spacing.md),
                  child: Text(
                    "OR",
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                Expanded(child: Divider(color: theme.colorScheme.outline)),
              ],
            ),
            const SizedBox(height: T2Spacing.xl),
            DmButton(
              label: "Continue with Google",
              variant: DmButtonVariant.outline,
              icon: Icons.g_mobiledata,
              onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
            ),
            const SizedBox(height: T2Spacing.lg),
            Center(
              child: TextButton(
                onPressed: () => context.goNamed('t2Signup'),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

