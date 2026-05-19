# ROUTER_FAILURE_ANALYSIS.md - GoRouter Navigation Integrity Report

## 1. Problem Architecture: GoRouter Sync vs Async Race
During app startup, the Flutter router instance (`GoRouter`) is resolved synchronously:
```dart
final routerProvider = Provider<GoRouter>((ref) { ... });
```
When `GoRouter` initializes:
1. It registers listeners on auth-state changes.
2. It executes `redirectLogic` synchronously to determine whether the user must be routed to `/login`, `/dashboard`, or `/`.
3. If any provider accessed within `redirectLogic` tries to eagerly communicate with a backend service (like Supabase) that is still loading, it triggers a fatal runtime exception.
4. Because this exception happens inside the router's build phase, the entire navigation stack collapses, displaying a permanent white blank frame.

## 2. Solution: State-Machine Shielding & Deferred Router Initialization
We hardened the GoRouter integration in `lib/app/router.dart` and `lib/app/app.dart`:
- **State-Machine Routing Shield**: `GoRouter` and navigation-bound providers are not built or evaluated until the centralized `bootstrapStateProvider` resolves to `success`. This completely shields the router from accessing uninitialized services.
- **Pre-Frame Warmup Shield**: Eager sync services, FCM binding, and analytical hooks are entirely removed from the router's initialization thread and deferred to a secure `_runDeferredWarmup()` called via a post-frame callback in `ProDietApp`.
- **Zero-Crash Redirects**: In `redirectLogic`, the system reads `activeThemeInitializedProvider` and `authProvider` to securely guide routing transitions. Because the underlying Supabase service is guaranteed to be fully active, these lookups are 100% crash-proof.
- **No Blank Startup Screens**: On initial load, the entrypoint in `lib/app/app.dart` safely renders `BootstrapLoadingScreen` (which is a beautiful loading indicator) while Riverpod warms up. Once the theme and auth resolve, `bootstrapStateProvider` transitions to `success` and the router smoothly takes over to direct the user to `/dashboard` or `/login`.
