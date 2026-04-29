import 'package:flutter/material.dart';

// NOTE: Phone verification is not implemented in v1.
// This screen is reserved for a future update.
// Do not route to this screen.
class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Phone verification coming soon.'),
      ),
    );
  }
}
