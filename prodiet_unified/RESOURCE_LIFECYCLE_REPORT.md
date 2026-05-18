# RESOURCE_LIFECYCLE_REPORT — Stateful Disposal & Subscription Tracking

This report documents the resource lifecycle management and automated clean-up protocols established inside ProDiet Unified.

---

## 1. Controller Disposal Standards

All Stateful widgets in the application that initialize controller instances must adhere to a strict **Disposal and Cleanup Pattern**:

```dart
class _CustomScreenState extends State<CustomScreen> {
  late final TextEditingController _textController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // 1. Dispose text controllers to release keyboard listeners
    _textController.dispose();
    // 2. Dispose scroll controllers to release layout listeners
    _scrollController.dispose();
    // 3. Finalize base state disposal
    super.dispose();
  }
}
```

### Verified Implementations:
*   [WaterScreenState](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/features/water/presentation/screens/water_screen.dart#L26-L29): Disposes of `_customController` safely.
*   [VoiceScreenState](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/features/voice/presentation/screens/voice_screen.dart#L47-L50): Cleanly tears down microphone stream listeners and recording indicators.
*   [AdaptiveInventoryWidgetsState](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/features/inventory/presentation/widgets/adaptive_inventory_widgets.dart#L211-L215): Clears search controllers and list scrolls on screen unmount.

---

## 2. Dynamic Stream Subscription Containment

Unclosed streams can persist in memory indefinitely, executing callbacks on dead widgets and leaking system variables. ProDiet Unified enforces:

1.  **Riverpod StreamProvider Listeners**:
    By using Riverpod's `ref.watch` inside build methods, subscriptions are automatically established, tracked, and safely cancelled by the Riverpod framework on teardown.
2.  **Explicit Background Subscriptions**:
    Any manual `StreamSubscription` initialized in domain models is managed using:
    *   **Auto-disposable streams** bound to custom providers.
    *   Explicitly stored subscription variables that trigger `.cancel()` within custom `dispose()` hooks.

---

## 3. Riverpod autoDispose & State Reclaim Rules

To keep the application's RAM footprint completely flat, we enforce the following provider configuration guidelines:

```
+-----------------------------------------------------------------+
|                       ProDiet Provider Tree                     |
+-----------------------------------------------------------------+
          |
          +---> [ Global Configuration ]
          |     - databaseProvider (Long-lived)
          |     - supabaseServiceProvider (Long-lived)
          |
          +---> [ Active UI View States ]
                - waterSummaryProvider.autoDispose
                - todayWaterLogsProvider.autoDispose
                - voiceStateProvider.autoDispose
                (Wiped from memory instantly when screen closes)
```

By ensuring that every screen-specific provider utilizes the `.autoDispose` annotation, the memory system automatically reclaims references to cached logs, summary models, and UI variables as soon as the user exits the respective module.
