import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: DmEmptyState(
          title: 'No notifications yet',
          message: 'We will notify you when your diet plan is updated or a goal is reached.',
          icon: Icons.notifications_none_rounded,
        ),
      ),
    );
  }
}
