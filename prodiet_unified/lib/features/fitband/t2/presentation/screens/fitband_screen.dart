import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/alert_strip.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/fitband/application/fitband_providers.dart';

class FitbandScreen extends ConsumerStatefulWidget {
  const FitbandScreen({super.key});

  @override
  ConsumerState<FitbandScreen> createState() => _FitbandScreenState();
}

class _FitbandScreenState extends ConsumerState<FitbandScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(fitbandProvider.notifier).init());
  }

  @override
  Widget build(BuildContext context) {
    final fitState = ref.watch(fitbandProvider);
    // Platform guard for BLE/Sensors simulation
    final isSupported = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    if (!isSupported) {
      return Scaffold(
        backgroundColor: T2Colors.bgDefault,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.watch_off_rounded,
                  color: T2Colors.textMuted, size: 64),
              const SizedBox(height: 24),
              Text(
                'DEVICE NOT SUPPORTED',
                style: GoogleFonts.barlowCondensed(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Fitband integration requires a physical mobile device with BLE support.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: T2Colors.textSecondary, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: fitState.isLoading
          ? const Center(child: CircularProgressIndicator(color: T2Colors.lime))
          : RefreshIndicator(
              onRefresh: () => ref.read(fitbandProvider.notifier).refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AlertStrip(
                      message: fitState.hasPermission
                          ? 'LIVE ACTIVITY DATA ACTIVE'
                          : 'PLATFORM NOT SUPPORTED',
                      subMessage: fitState.hasPermission
                          ? 'Synced with Google Fit / Apple Health'
                          : 'Please grant permissions for live data',
                      isWarning: !fitState.hasPermission,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACTIVITY',
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: T2Colors.lime,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildDeviceChip(
                                  fitState.hasPermission
                                      ? 'HEALTH SYNC ACTIVE'
                                      : 'NO HEALTH ACCESS',
                                  fitState.hasPermission
                                      ? T2Colors.lime
                                      : T2Colors.coral),
                              const SizedBox(width: 8),
                              _buildDeviceChip(
                                  'CONNECTED', T2Colors.textSecondary),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Heart Rate Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: T2Colors.bgElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: T2Colors.border),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'HEART RATE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                    color: T2Colors.textMuted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      fitState.heartRate?.toString() ?? '--',
                                      style: GoogleFonts.barlowCondensed(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w900,
                                        color: T2Colors.purple,
                                        height: 1.0,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'bpm',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: T2Colors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Placeholder for Heart Rate Graph
                            SizedBox(
                              width: 120,
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(15, (index) {
                                  final h = [
                                    20,
                                    30,
                                    25,
                                    40,
                                    35,
                                    45,
                                    30,
                                    20,
                                    25,
                                    35,
                                    40,
                                    30,
                                    25,
                                    20,
                                    15
                                  ][index];
                                  return Container(
                                    width: 4,
                                    height: h.toDouble(),
                                    decoration: BoxDecoration(
                                      color: T2Colors.purple
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Steps & Active Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: _buildMetricTile(
                                  'STEPS',
                                  fitState.steps.toString(),
                                  'Goal: 10k',
                                  T2Colors.lime)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildMetricTile(
                                  'CALORIES',
                                  fitState.calories.toStringAsFixed(0),
                                  'Active kcal',
                                  T2Colors.coral)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'RECENT SESSIONS',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.5,
                          color: T2Colors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (_, __) =>
                          const Divider(color: T2Colors.border, height: 1),
                      itemBuilder: (context, index) {
                        final titles = [
                          'Morning Walk',
                          'Gym Session',
                          'Evening Jog'
                        ];
                        final times = ['07:30 AM', '11:00 AM', '06:15 PM'];
                        final kcal = ['120 kcal', '310 kcal', '215 kcal'];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          title: Text(
                            titles[index],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
                          subtitle: Text(
                            times[index],
                            style: const TextStyle(
                                color: T2Colors.textMuted, fontSize: 12),
                          ),
                          trailing: Text(
                            kcal[index],
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: T2Colors.lime,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDeviceChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMetricTile(
      String label, String value, String sub, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: T2Colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 1.2,
              color: T2Colors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.barlowCondensed(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: accent,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              color: T2Colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
