import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';

class DietPlanScreen extends StatelessWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Program'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(T1Spacing.lg),
        children: [
          _buildHeroCard(theme),
          const SizedBox(height: T1Spacing.xl),
          _buildGoalMetrics(theme),
          const SizedBox(height: T1Spacing.xl),
          Text(
            'TODAY\'S SCHEDULE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: T1Spacing.md),
          _buildTimeline(theme),
        ],
      ),
    );
  }

  Widget _buildHeroCard(ThemeData theme) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B1FA8), Color(0xFF6B35FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B1FA8).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.fitness_center_rounded, size: 180, color: Colors.white.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ACTIVE PLAN',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Muscle Shredding 2.0',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  'Week 4 of 12 · Day 24',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalMetrics(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _metric(theme, 'WEIGHT', '72.4', 'kg', const Color(0xFF40D8B8))),
        const SizedBox(width: 12),
        Expanded(child: _metric(theme, 'BODY FAT', '14.2', '%', const Color(0xFFFF3060))),
        const SizedBox(width: 12),
        Expanded(child: _metric(theme, 'WATER', '2.5', 'L', const Color(0xFF3B1FA8))),
      ],
    );
  }

  Widget _metric(ThemeData theme, String label, String value, String unit, Color color) {
    return DmCard(
      color: color.withOpacity(0.06),
      borderSide: BorderSide(color: color.withOpacity(0.15)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: color.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: color),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: theme.textTheme.labelSmall?.copyWith(color: color.withOpacity(0.5), fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(ThemeData theme) {
    final schedule = [
      {'time': '07:00', 'title': 'Pre-Workout Snack', 'done': true},
      {'time': '08:00', 'title': 'Intense HIIT Session', 'done': true},
      {'time': '10:00', 'title': 'Post-Workout Protein', 'done': false},
      {'time': '13:00', 'title': 'Lean Lunch', 'done': false},
    ];

    return Column(
      children: schedule.map((item) {
        final isDone = item['done'] as bool;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  item['time'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(isDone ? 0.2 : 0.5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? const Color(0xFF40D8B8) : Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DmCard(
                  color: Colors.white.withOpacity(isDone ? 0.01 : 0.03),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    item['title'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(isDone ? 0.3 : 1.0),
                      fontWeight: FontWeight.w700,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
