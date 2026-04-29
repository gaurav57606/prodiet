import 'package:flutter/material.dart';
import 'skeleton_box.dart';

class NutritionSearchSkeleton extends StatelessWidget {
  const NutritionSearchSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SkeletonBox(width: 48, height: 48, borderRadius: 8),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 160, height: 16),
                  SizedBox(height: 8),
                  SkeletonBox(width: 100, height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
