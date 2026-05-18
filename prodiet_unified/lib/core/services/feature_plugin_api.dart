import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation configuration item streamed from active plugins
/// to register dynamic menu selections in the app sidebar or bottom bars.
class PluginNavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String routePath;
  final int order;

  const PluginNavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.routePath,
    this.order = 100,
  });
}

/// Abstract contract governing future third-party integrations, subscription
/// modules, wearable analytics dashboards, or community plugins.
abstract class BaseAppPlugin {
  /// Unique domain namespace (e.g., 'premium_entitlements', 'social_sharing').
  String get pluginId;

  /// User-friendly label displayed in plugin manager.
  String get displayName;

  /// Triggered during app startup lifecycle before rendering.
  Future<void> initialize(BuildContext context);

  /// Dynamic list of GoRouter routes that this plugin registers in the app.
  List<RouteBase> getRoutes();

  /// Navigation destination definition if the plugin exposes a core screen.
  PluginNavigationItem? getNavigationItem() => null;

  /// Triggered during GDPR privacy wipes or account logouts.
  Future<void> purgeMemory() async {}
}

/// Dynamic registry coordinator managing all active features and plugin integrations.
class PluginRegistry {
  PluginRegistry._();
  
  static final PluginRegistry _instance = PluginRegistry._();
  static PluginRegistry get instance => _instance;

  final Map<String, BaseAppPlugin> _registeredPlugins = {};

  /// Registers and hooks a new plugin into the core ecosystem.
  void registerPlugin(BaseAppPlugin plugin) {
    if (_registeredPlugins.containsKey(plugin.pluginId)) {
      throw ArgumentError('Plugin with ID "${plugin.pluginId}" is already registered.');
    }
    _registeredPlugins[plugin.pluginId] = plugin;
  }

  /// Removes and purges a registered plugin at runtime.
  Future<void> unregisterPlugin(String pluginId) async {
    final plugin = _registeredPlugins.remove(pluginId);
    if (plugin != null) {
      await plugin.purgeMemory();
    }
  }

  /// Lists all currently active plugins.
  List<BaseAppPlugin> getActivePlugins() => _registeredPlugins.values.toList();

  /// Returns true if a specific plugin is loaded.
  bool hasPlugin(String pluginId) => _registeredPlugins.containsKey(pluginId);

  /// Retrieves all plugin navigation routes to inject into GoRouter.
  List<RouteBase> buildPluginRoutes() {
    final List<RouteBase> routes = [];
    for (final plugin in _registeredPlugins.values) {
      routes.addAll(plugin.getRoutes());
    }
    return routes;
  }

  /// Retrieves all sidebar/navigation rail integrations, sorted by display order.
  List<PluginNavigationItem> getNavigationItems() {
    final List<PluginNavigationItem> items = [];
    for (final plugin in _registeredPlugins.values) {
      final nav = plugin.getNavigationItem();
      if (nav != null) {
        items.add(nav);
      }
    }
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }
}
