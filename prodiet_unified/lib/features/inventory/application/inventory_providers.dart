import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:prodiet_unified/core/data/local/offline_providers.dart';
import 'package:prodiet_unified/core/sync/sync_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/inventory/data/inventory_repository.dart';
import 'package:prodiet_unified/features/inventory/domain/inventory_item.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(
    ref.watch(supabaseServiceProvider),
    ref.watch(appDatabaseProvider),
    ref.watch(syncQueueRepositoryProvider),
  );
});

final inventoryStreamProvider = StreamProvider.autoDispose<List<InventoryItem>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return Stream.value([]);
  
  return ref.watch(inventoryRepositoryProvider).watchInventory(userId);
});

final lowStockProvider = Provider.autoDispose<List<InventoryItem>>((ref) {
  final inventory = ref.watch(inventoryStreamProvider).value ?? [];
  return inventory.where((item) => item.isLowStock).toList();
});

final inventoryCategoryFilterProvider = StateProvider<String?>((ref) => 'All');
