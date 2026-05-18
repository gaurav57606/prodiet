import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

enum ConnectionStatus { online, offline, degraded }

class ConnectionMonitor extends Notifier<ConnectionStatus> {
  late final Connectivity _connectivity;
  final _logger = Logger();
  final _statusController = StreamController<ConnectionStatus>.broadcast();
  StreamSubscription? _subscription;
  Timer? _debounceTimer;

  Stream<ConnectionStatus> get statusChanges => _statusController.stream;

  @override
  ConnectionStatus build() {
    _connectivity = Connectivity();
    _init();
    ref.onDispose(() {
      _subscription?.cancel();
      _debounceTimer?.cancel();
      _statusController.close();
    });
    return ConnectionStatus.online;
  }

  void _init() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      // Debounce to prevent rapid flapping when switching networks (e.g. WiFi to LTE)
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        if (results.contains(ConnectivityResult.none)) {
          _updateState(ConnectionStatus.offline);
        } else {
          // Double check actual HTTP connectivity
          final hasInternet = await verifyActualInternet();
          _updateState(hasInternet ? ConnectionStatus.online : ConnectionStatus.degraded);
        }
      });
    });
  }

  void _updateState(ConnectionStatus newStatus) {
    if (state != newStatus) {
      state = newStatus;
      _statusController.add(newStatus);
      if (newStatus == ConnectionStatus.offline) {
        _logger.w('[ConnectionMonitor] Connection status: OFFLINE');
      } else if (newStatus == ConnectionStatus.degraded) {
        _logger.w('[ConnectionMonitor] Connection status: DEGRADED (Local online, but ping failed)');
      } else {
        _logger.i('[ConnectionMonitor] Connection status: ONLINE');
      }
    }
  }

  /// Mark the connection manually as degraded (e.g. on api timeout or failure)
  void markDegraded() {
    _updateState(ConnectionStatus.degraded);
  }

  /// Verify actual reachability cross-platform using google clients url
  Future<bool> verifyActualInternet() async {
    try {
      final response = await http
          .get(Uri.parse('https://clients3.google.com/generate_204'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) return false;
    return await verifyActualInternet();
  }
}

final connectionMonitorProvider = NotifierProvider<ConnectionMonitor, ConnectionStatus>(() {
  return ConnectionMonitor();
});
