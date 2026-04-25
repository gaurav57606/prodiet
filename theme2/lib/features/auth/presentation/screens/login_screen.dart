import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/shared/widgets/dm_button.dart';
import 'package:dietmate_pro/shared/widgets/dm_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Login to your DietMate account",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const DmTextField(
              label: "Email Address",
              hint: "name@example.com",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            const SizedBox(height: AppSpacing.lg),
            const DmTextField(
              label: "Password",
              hint: "Enter your password",
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline, size: 20),
              suffixIcon: Icon(Icons.visibility_off_outlined, size: 20),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            DmButton(
              label: "Login",
              onPressed: () => context.goNamed('dashboard'),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(child: Divider(color: theme.colorScheme.outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    "OR",
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                Expanded(child: Divider(color: theme.colorScheme.outline)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            DmButton(
              label: "Continue with Google",
              variant: DmButtonVariant.outline,
              icon: Icons.g_mobiledata,
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: TextButton(
                onPressed: () => context.goNamed('signup'),
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
