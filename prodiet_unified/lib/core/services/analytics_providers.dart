import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/observability/analytics/analytics_manager.dart';
import 'package:prodiet_unified/core/services/remote_config_service.dart';

final analyticsManagerProvider = Provider<AnalyticsManager>((ref) {
  return AnalyticsManager();
});

final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService();
});
