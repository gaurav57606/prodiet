import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/presentation/widgets/adaptive_auth_widgets.dart';

const String _indiaCountryCode = '+91';

class VerifyPhoneScreen extends ConsumerStatefulWidget {
  final String phone;
  const VerifyPhoneScreen({super.key, required this.phone});

  @override
  ConsumerState<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends ConsumerState<VerifyPhoneScreen> {
  late final TextEditingController _phoneController;
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  
  bool _otpSent = false;
  bool _isLoading = false;
  int _countdown = 60;
  Timer? _timer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.phone);
    if (widget.phone.isNotEmpty) {
      _otpSent = true;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _countdown--;
          });
        }
      }
    });
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length != 10 || int.tryParse(phone) == null) {
      setState(() => _errorMessage = 'Please enter a valid 10-digit number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendPhoneOtp('$_indiaCountryCode$phone');
      
      if (mounted) {
        setState(() {
          _otpSent = true;
          _isLoading = false;
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    final phone = _phoneController.text.trim();
    final otp = _otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      setState(() => _errorMessage = 'Please enter the 6-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.verifyPhoneOtp('$_indiaCountryCode$phone', otp);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid OTP code. Please try again.';
        });
      }
    }
  }

  void _handleOtpInput(String value, int index) {
    if (value.length > 1) {
      final digits = value.trim().split('').where((char) => int.tryParse(char) != null).toList();
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _otpControllers[i].text = digits[i];
      }
      _otpFocusNodes[digits.length < 6 ? digits.length : 5].requestFocus();
      return;
    }

    if (value.isNotEmpty) {
      if (index < 5) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    setState(() {}); // Update border highlights
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return AdaptiveAuthScaffold(
      header: AdaptiveAuthHeader(
        title: _otpSent ? "Verify OTP" : "Phone Verification",
        subtitle: _otpSent 
          ? "Enter the 6-digit code sent to $_indiaCountryCode ${_phoneController.text}" 
          : "Enter your mobile number to receive a verification code",
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
                    color: isT2 ? const Color(0xFF4DD8D0) : tokens.colors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Back",
                    style: TextStyle(
                      color: isT2 ? const Color(0xFF4DD8D0) : tokens.colors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (!_otpSent) ...[
              _buildLabel('MOBILE NUMBER', tokens, isT2),
              const SizedBox(height: 8),
              AppTextField(
                controller: _phoneController,
                hint: '00000 00000',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                prefixIcon: Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    _indiaCountryCode,
                    style: TextStyle(
                      color: tokens.colors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ] else ...[
              _buildLabel('ENTER 6-DIGIT CODE', tokens, isT2),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index, tokens, isT2)),
              ),
              const SizedBox(height: 24),
              Center(
                child: _countdown > 0 
                  ? Text(
                      'Resend in 0:${_countdown.toString().padLeft(2, '0')}',
                      style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.4)),
                    )
                  : TextButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: isT2 ? const Color(0xFF4DD8D0) : tokens.colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
              ),
            ],
            
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: tokens.colors.error, fontSize: 13),
              ),
            ],
            
            const SizedBox(height: 32),
            AppButton(
              label: _otpSent ? 'Verify & Continue' : 'Send OTP',
              isLoading: _isLoading,
              onPressed: _isLoading ? null : (_otpSent ? _verifyOtp : _sendOtp),
              width: double.infinity,
            ),
            
            if (_otpSent) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _otpSent = false),
                  child: Text(
                    'Change Phone Number',
                    style: TextStyle(color: tokens.colors.onSurface.withValues(alpha: 0.4)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index, AppThemeTokens tokens, bool isT2) {
    final hasFocus = _otpFocusNodes[index].hasFocus;
    final hasText = _otpControllers[index].text.isNotEmpty;
    
    return Container(
      width: 44,
      height: 52,
      decoration: BoxDecoration(
        color: isT2 ? const Color(0xFF1A1A20) : tokens.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (hasFocus || hasText)
              ? (isT2 ? const Color(0xFF4DD8D0) : tokens.colors.primary)
              : (isT2 ? const Color(0xFF2A2A34) : tokens.colors.outline.withValues(alpha: 0.1)),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: tokens.colors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        showCursor: false,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) => _handleOtpInput(value, index),
      ),
    );
  }

  Widget _buildLabel(String text, AppThemeTokens tokens, bool isT2) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: isT2 ? const Color(0xFF888888) : tokens.colors.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}
