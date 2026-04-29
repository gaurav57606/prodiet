import 'package:flutter/material.dart';
import 'skeleton_box.dart';

class MealListSkeleton extends StatelessWidget {
  const MealListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SkeletonBox(
            width: double.infinity,
            height: 72,
            borderRadius: 16,
          ),
        ),
      ),
    );
  }
}
