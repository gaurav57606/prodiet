import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';

const String _indiaCountryCode = '+91';

class VerifyPhoneScreen extends ConsumerStatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  ConsumerState<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends ConsumerState<VerifyPhoneScreen> {
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _otpSent = false;
  bool _isLoading = false;
  int _countdown = 45;
  Timer? _timer;
  String? _errorMessage;

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

  String _friendlyError(dynamic e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid') && msg.contains('token'))
      return 'Invalid OTP code. Please check and try again.';
    if (msg.contains('expired'))
      return 'OTP has expired. Please request a new one.';
    if (msg.contains('too many'))
      return 'Too many attempts. Please wait a few minutes.';
    if (msg.contains('network'))
      return 'Connection error. Check your internet.';
    return 'Something went wrong. Please try again.';
  }

  void _startTimer() {
    _countdown = 45;
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
          _errorMessage = _friendlyError(e);
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
      // Success - AuthNotifier will pick up the session and redirect automatically
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _friendlyError(e);
        });
      }
    }
  }

  void _handleOtpInput(String value, int index) {
    // Paste logic
    if (value.length > 1) {
      final digits = value
          .trim()
          .split('')
          .where((char) => int.tryParse(char) != null)
          .toList();
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
        // Removed auto-submit as per TASK requirement
      }
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              _otpSent ? 'Verify OTP' : 'Phone Verification',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _otpSent
                  ? 'Enter the 6-digit code sent to $_indiaCountryCode ${_phoneController.text}'
                  : 'Enter your mobile number to receive a verification code',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            if (!_otpSent) ...[
              _buildLabel('MOBILE NUMBER', theme),
              const SizedBox(height: 8),
              DmTextField(
                controller: _phoneController,
                hintText: '00000 00000',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                prefixIcon: Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: const Text(
                    _indiaCountryCode,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ] else ...[
              _buildLabel('ENTER 6-DIGIT CODE', theme),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: 24),
              Center(
                child: _countdown > 0
                    ? Text(
                        'Resend in 0:${_countdown.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4)),
                      )
                    : TextButton(
                        onPressed: _isLoading ? null : _sendOtp,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: scheme.primary,
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
                style: TextStyle(color: scheme.error, fontSize: 13),
              ),
            ],
            const SizedBox(height: 32),
            DmButton(
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
                    style:
                        TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength:
            index == 0 ? 10 : 1, // Allow paste catch on first box if needed
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Colors.white.withValues(alpha: 0.05),
          filled: true,
        ),
        onChanged: (value) => _handleOtpInput(value, index),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    final scheme = theme.colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }
}
