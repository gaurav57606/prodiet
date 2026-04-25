import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/shared/widgets/dm_button.dart';
import 'package:dietmate_pro/shared/widgets/dm_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
              "Create Account",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Start your journey with DietMate Pro",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const DmTextField(
              label: "Full Name",
              hint: "John Doe",
              prefixIcon: Icon(Icons.person_outline, size: 20),
            ),
            const SizedBox(height: AppSpacing.lg),
            const DmTextField(
              label: "Email Address",
              hint: "name@example.com",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            const SizedBox(height: AppSpacing.lg),
            const DmTextField(
              label: "Password",
              hint: "Minimum 8 characters",
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline, size: 20),
              suffixIcon: Icon(Icons.visibility_off_outlined, size: 20),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              "By signing up, you agree to our Terms and Conditions and Privacy Policy.",
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            DmButton(
              label: "Create Account",
              onPressed: () => context.goNamed('dashboard'),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: TextButton(
                onPressed: () => context.goNamed('login'),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: "Log In",
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
