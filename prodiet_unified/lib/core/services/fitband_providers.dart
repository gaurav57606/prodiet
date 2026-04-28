import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/services/fitband_service.dart';

final fitbandServiceProvider = Provider<FitbandService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FitbandService(supabase);
});

final fitbandSyncProvider = Provider<void>((ref) {
  final service = ref.watch(fitbandServiceProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) return;

  final listener = AppLifecycleListener(
    onShow: () async {
      final hasPermission = await service.requestPermissions();
      if (hasPermission) {
        final data = await service.getTodayActivity();
        await service.syncToSupabase(user.id, data);
      }
    },
    onResume: () async {
      final hasPermission = await service.requestPermissions();
      if (hasPermission) {
        final data = await service.getTodayActivity();
        await service.syncToSupabase(user.id, data);
      }
    },
  );

  ref.onDispose(() => listener.dispose());
});
