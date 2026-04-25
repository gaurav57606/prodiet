import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/dm_button.dart';
import '../widgets/auth_hero.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHero(
              title: 'Verify',
              subtitle: 'OTP sent to +91 98765 43210',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Enter the 6-digit code',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildOtpRow(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildResendRow(),
                  const SizedBox(height: AppSpacing.xl),
                  DmButton(
                    label: 'Verify & Continue',
                    onPressed: () => context.goNamed('dashboard'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildChangeNumberRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: context.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: context.colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.colorScheme.outline),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildResendRow() {
    return RichText(
      text: TextSpan(
        style: context.textTheme.bodySmall,
        children: [
          TextSpan(
            text: 'Code expires in ',
            style: TextStyle(color: context.colorScheme.onSurfaceVariant.withOpacity(0.7)),
          ),
          const TextSpan(
            text: '2:47',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' · ',
            style: TextStyle(color: context.colorScheme.onSurfaceVariant.withOpacity(0.7)),
          ),
          TextSpan(
            text: 'Resend',
            style: TextStyle(color: context.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeNumberRow() {
    return RichText(
      text: TextSpan(
        style: context.textTheme.bodySmall,
        children: [
          TextSpan(
            text: 'Wrong number? ',
            style: TextStyle(color: context.colorScheme.onSurfaceVariant.withOpacity(0.7)),
          ),
          TextSpan(
            text: 'Change it',
            style: TextStyle(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
