import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_empty_state.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: DmEmptyState(
          title: 'Recipes Coming Soon',
          message: 'Personalized recipes based on your pantry and diet plan are under development.',
          icon: Icons.restaurant_menu_rounded,
        ),
      ),
    );
  }
}
