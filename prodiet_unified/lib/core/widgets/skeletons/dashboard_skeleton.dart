import 'package:flutter/material.dart';
import 'skeleton_box.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top greeting row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(width: 200, height: 22),
              SkeletonBox(width: 40, height: 40, borderRadius: 20),
            ],
          ),
          SizedBox(height: 24),

          // 2. Calorie ring card
          Center(
            child: Column(
              children: [
                SkeletonBox(width: 120, height: 120, borderRadius: 60),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonBox(width: 60, height: 12),
                    SizedBox(width: 12),
                    SkeletonBox(width: 60, height: 12),
                    SizedBox(width: 12),
                    SkeletonBox(width: 60, height: 12),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // 3. Water card
          SkeletonBox(width: double.infinity, height: 72),
          SizedBox(height: 24),

          // 4. Meals row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(width: 100, height: 90),
              SkeletonBox(width: 100, height: 90),
              SkeletonBox(width: 100, height: 90),
            ],
          ),
          SizedBox(height: 24),

          // 5. AI tip card
          SkeletonBox(width: double.infinity, height: 88),
        ],
      ),
    );
  }
}
