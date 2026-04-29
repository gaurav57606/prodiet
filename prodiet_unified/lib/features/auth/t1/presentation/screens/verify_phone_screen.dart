import 'package:flutter/material.dart';

// Phone verification not implemented in v1.
// Reserved for a future update. Do not route to this screen.
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
