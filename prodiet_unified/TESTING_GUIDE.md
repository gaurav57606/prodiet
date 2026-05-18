# ProDiet Unified — Testing & Verification Guide

ProDiet Unified utilizes a multi-tiered, production-grade pyramid testing strategy. This ensures state integrity, offline-first sync consistency, and design aesthetics across multiple themes.

---

## 1. Directory Mapping & Testing Architecture

The codebase has been refactored to align with a strict testing topology that categorizes tests by operational concern:

```
test/
├── unit/           # Pure domain models, utility functions, and business rules.
├── repositories/   # Local & Supabase database integration, authentication, and data logic.
├── providers/      # Riverpod notifiers, state managers, and transition pipelines.
├── widgets/        # Component UI rendering, dark modes, dynamic theme, and text scaling limits.
├── integration/    # Multi-step end-to-end user journeys (login, preference persistence, logout).
├── sync/           # Outbox processing, conflict resolution, connectivity transitions, and debouncing.
└── OCR/            # OCR pre-processing pipelines, text filtering, and food item selection.
```

### Component Details
*   **Unit Tests (`test/unit/`)**: Verify that domain models (e.g., `AppUser`, `Meal`) serialize and deserialize cleanly, and that local utilities do not leak memory or overflow numeric types.
*   **Repository Tests (`test/repositories/`)**: Cover mocked network communications. They verify that database models map to domain models and that API network failures throw safe, structured `AppError` types.
*   **Provider State Tests (`test/providers/`)**: Validate that Riverpod Notifiers mutate state predictably in response to user actions or asynchronous triggers.
*   **Widget UI Tests (`test/widgets/`)**: Check typography colors, padding boundaries, accessibility text scaling (large layouts), and how gracefully loading/error states are displayed using custom wrappers.
*   **Integration Tests (`test/integration/`)**: Emulate a full active user session from login, loading Dashboard details, modifying and persisting preferences to Disk, and executing a safe clean-up on logout.
*   **Sync Engine Tests (`test/sync/`)**: Challenge local storage queue behavior, exponential retry backoffs, and online/offline state switching.
*   **OCR Preprocessing Tests (`test/OCR/`)**: Emulate image loading, preprocessing, results mapping, item toggling selection, and bulk-saving items directly to the database.

---

## 2. Command Execution Cheat Sheet

Run specific test blocks or generate full coverage files using the following commands:

```bash
# Run the entire test suite
flutter test

# Run a specific test directory (e.g., OCR tests)
flutter test test/OCR/

# Run a specific file
flutter test test/widgets/accessibility_and_theme_test.dart

# Run tests filtering by their description name match
flutter test --name="Theme Switching"

# Generate code coverage (creates coverage/lcov.info)
flutter test --coverage

# Generate and view visual HTML coverage report (Linux/macOS)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 3. Dependency Mocking & Stubbing (Mocktail)

We use `mocktail` for robust, type-safe mocking. Follow these principles to construct stable tests:

### Mocking Repositories & Services
Use class mocks for external repositories or state services:

```dart
class MockAuthRepository extends Mock implements AuthRepository {}
class MockFcmService extends Mock implements FcmService {}
```

### Stubbing Asynchronous Streams
When stubbing streams like `authStateChanges()`, ensure you cover login and logout state transitions using stream controllers:

```dart
final authStreamController = StreamController<supabase.AuthState>.broadcast();
when(() => mockAuthRepo.authStateChanges())
    .thenAnswer((_) => authStreamController.stream);
```

### Mocking Supabase Sessions
Create valid mock JWT sessions to feed into repositories:

```dart
supabase.Session makeSession(String userId, String email) {
  return supabase.Session(
    accessToken: 'tok_$userId',
    tokenType: 'bearer',
    user: supabase.User(
      id: userId,
      email: email,
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    ),
  );
}
```

---

## 4. Connectivity Emulation

Do not mock connectivity using simple boolean overrides. Instead, override the `connectivityProvider` with a customized `ConnectivityNotifier` subclass:

```dart
class MockConnectivityNotifier extends ConnectivityNotifier {
  final ConnectivityStatus initialStatus;
  MockConnectivityNotifier({this.initialStatus = ConnectivityStatus.online});

  @override
  Future<ConnectivityStatus> build() async => initialStatus;
  
  void setConnection(ConnectivityStatus newStatus) {
    state = AsyncValue.data(newStatus);
  }
}

// Override in ProviderScope
ProviderScope(
  overrides: [
    connectivityProvider.overrideWith(() => MockConnectivityNotifier()),
  ],
  child: const ProDietApp(),
)
```

This guarantees that repositories, sync engines, and widgets react instantly to real-time changes in active network states.

---

## 5. Coverage Goals & Quality Gates

To prevent regressions in production, PRs should meet these criteria before merging:

| Layer | Coverage Threshold | Critical Items to Validate |
| :--- | :--- | :--- |
| **Outbox & Sync** | **100%** | Conflict resolution, retry counts, database sync queue. |
| **Authentication** | **95%** | Token storage, credentials purging on logout, session expiration. |
| **OCR Pipeline** | **90%** | Image pick, parser state updates, item saving. |
| **Theme & UI** | **85%** | Text scaling (up to 3.0x), error widget displaying. |
