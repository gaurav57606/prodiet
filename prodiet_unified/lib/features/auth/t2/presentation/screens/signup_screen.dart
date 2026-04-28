import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_text_field.dart';

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
        padding: const EdgeInsets.all(T2Spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Account",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: T2Spacing.xs),
            Text(
              "Start your journey with DietMate Pro",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: T2Spacing.xl),
            const DmTextField(
              label: "Full Name",
              hint: "John Doe",
              prefixIcon: Icon(Icons.person_outline, size: 20),
            ),
            const SizedBox(height: T2Spacing.lg),
            const DmTextField(
              label: "Email Address",
              hint: "name@example.com",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            const SizedBox(height: T2Spacing.lg),
            const DmTextField(
              label: "Password",
              hint: "Minimum 8 characters",
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline, size: 20),
              suffixIcon: Icon(Icons.visibility_off_outlined, size: 20),
            ),
            const SizedBox(height: T2Spacing.xl),
            Text(
              "By signing up, you agree to our Terms and Conditions and Privacy Policy.",
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: T2Spacing.xl),
            DmButton(
              label: "Create Account",
              onPressed: () => context.goNamed('t2Dashboard'),
            ),
            const SizedBox(height: T2Spacing.xl),
            Center(
              child: TextButton(
                onPressed: () => context.goNamed('t2Login'),
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
