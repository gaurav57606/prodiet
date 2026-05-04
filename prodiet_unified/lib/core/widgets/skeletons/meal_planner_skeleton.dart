import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';

class MealPlannerSkeleton extends StatefulWidget {
  const MealPlannerSkeleton({super.key});
  @override
  State<MealPlannerSkeleton> createState() => _MealPlannerSkeletonState();
}

class _MealPlannerSkeletonState extends State<MealPlannerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 0.7).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box(double w, double h, {double radius = 8}) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: _anim.value),
              borderRadius: BorderRadius.circular(radius)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Week header strip
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (_) => _box(36, 36, radius: 10)),
          ),
        ),
        const Divider(color: T2Colors.border, height: 1),
        // Day card skeletons
        Expanded(
            child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 4,
          itemBuilder: (_, __) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: T2Colors.bgElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: T2Colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(80, 12),
                const SizedBox(height: 10),
                _box(200, 16),
                const SizedBox(height: 8),
                Row(children: [
                  _box(60, 10),
                  const SizedBox(width: 8),
                  _box(60, 10),
                  const SizedBox(width: 8),
                  _box(60, 10),
                ]),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
