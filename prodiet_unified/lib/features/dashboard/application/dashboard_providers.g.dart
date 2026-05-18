// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Dashboard)
final dashboardProvider = DashboardProvider._();

final class DashboardProvider
    extends $AsyncNotifierProvider<Dashboard, DashboardSummary> {
  DashboardProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardHash();

  @$internal
  @override
  Dashboard create() => Dashboard();
}

String _$dashboardHash() => r'93be590a63adcd7dda2cf1df149a5cfd4aad3c51';

abstract class _$Dashboard extends $AsyncNotifier<DashboardSummary> {
  FutureOr<DashboardSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DashboardSummary>, DashboardSummary>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<DashboardSummary>, DashboardSummary>,
        AsyncValue<DashboardSummary>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
