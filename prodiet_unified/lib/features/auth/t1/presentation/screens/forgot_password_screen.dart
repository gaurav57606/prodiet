import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _emailSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).sendPasswordReset(email);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // TOP HERO SECTION
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.surface,
                  scheme.surfaceVariant,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: scheme.primaryContainer,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(text: 'Reset ', style: TextStyle(color: scheme.primaryContainer)),
                        TextSpan(text: 'password', style: TextStyle(color: scheme.onSurface)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your email and we'll send a reset link",
                    style: TextStyle(
                      color: scheme.onSurface.withOpacity(0.45),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => context.go('/t1/login'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                    label: const Text('Back to sign in'),
                    style: TextButton.styleFrom(foregroundColor: scheme.primary),
                  ),
                  const SizedBox(height: 40),
                  _buildLabel('EMAIL ADDRESS', scheme),
                  const SizedBox(height: 8),
                  DmTextField(
                    controller: _emailController,
                    hintText: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  // Send Button
                  DmButton(
                    label: 'Send Reset Link',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _sendReset,
                    width: double.infinity,
                  ),
                  if (_emailSent) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '✅ Reset link sent! Check your inbox.',
                        style: TextStyle(color: Colors.green.shade400, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  // Help Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outline.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DIDN\'T RECEIVE IT?',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface.withOpacity(0.4),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: scheme.onSurface.withOpacity(0.5), fontSize: 13),
                            children: [
                              const TextSpan(text: 'Check spam folder · Wait 2 minutes · '),
                              TextSpan(
                                text: 'Resend email',
                                style: TextStyle(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, ColorScheme scheme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface.withOpacity(0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}
