import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_empty_state.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: DmEmptyState(
          title: 'Settings Coming Soon',
          message: 'Advanced personalization and app preferences are being polished for the next update.',
          icon: Icons.tune_rounded,
        ),
      ),
    );
  }
}
