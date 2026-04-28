import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // TOP HERO SECTION
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A0030),
                  Color(0xFF0D0020),
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
                      color: const Color(0xFF1A2050),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: Color(0xFF40D8C0),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(text: 'Verify your ', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'phone', style: TextStyle(color: Color(0xFF40D8C0))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP sent to +91 98765 43210',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
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
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF8B5CF6)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Enter the 6-digit code',
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  // OTP INPUT ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 44,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _controllers[index].text.isNotEmpty 
                              ? const Color(0xFF8B5CF6) 
                              : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else {
                                _focusNodes[index].unfocus();
                              }
                            } else {
                              if (index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            }
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // TIMER ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Code expires in ',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                      ),
                      Text(
                        '0:${_secondsLeft.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Color(0xFFFFB040), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(color: Colors.white.withOpacity(0.2)),
                      ),
                      GestureDetector(
                        onTap: _secondsLeft == 0 ? _startTimer : null,
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            color: _secondsLeft == 0 ? const Color(0xFF8B5CF6) : Colors.white.withOpacity(0.2),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // Verify Button
                  DmButton(
                    label: 'Verify & Continue',
                    onPressed: () => context.goNamed(AppRoutes.dashboardName),
                    width: double.infinity,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Wrong number? ',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text(
                          'Change it',
                          style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
