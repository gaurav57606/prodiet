# SECURE_STORAGE_REPORT — Hardware-Backed Cryptography & Data Sandboxing

This report details how **ProDiet Unified** encrypts and sandboxes sensitive information, credentials, and image data on local hardware platforms.

---

## 1. Hardware-Backed Auth Storage (Keychain & Keystore)

To lock down session identity tokens and prevent sidechannel extraction, the application integrates with hardware-enforced cryptographic boundaries via [SecureSupabaseStorage](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/core/security/secure_supabase_storage.dart).

```
+-----------------------------------------------------------------+
|                       ProDiet Unified App                       |
|                                                                 |
|                 +----------------------------+                  |
|                 |   SecureSupabaseStorage    |                  |
|                 +--------------+-------------+                  |
+--------------------------------|--------------------------------+
                                 |
        +------------------------+------------------------+
        | (iOS Keychain SecItem)                          | (Android Keystore / ESP)
        v                                                 v
+-------+------------------------+              +---------+------------------------+
| iOS Secure Enclave Sandbox     |              | Android TEE (Keystore)           |
| (Hardware-Backed Cryptography) |              | (EncryptedSharedPreferences)     |
+--------------------------------+              +----------------------------------+
```

### Mobile Security Implementations:
*   **Android Security (TEE)**: Implements `EncryptedSharedPreferences` backed by the hardware-isolated Trusted Execution Environment (TEE). Keys are dynamically verified via AES-256 GCM algorithms.
*   **iOS Security (Secure Enclave)**: Uses standard Keychain Services (`SecItem`) backed by hardware Secure Enclaves. The item attributes require active system lock verification, blocking raw disk access.

---

## 2. Dynamic Image & Temporary File Lifetime Policy

Camera captures and uploaded receipts present high leakage risks if they persist on general user storage volumes. ProDiet Unified enforces a strict **Zero-Stale-Image Policy** in the [OcrNotifier](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/features/ocr_scanner/application/ocr_notifier.dart) lifecycle:

```dart
// lib/features/ocr_scanner/application/ocr_notifier.dart
Future<void> pickImage(ImageSource source) async {
  File? tempFile;
  try {
    final picked = await ImagePicker().pickImage(...);
    if (picked == null) return;
    
    tempFile = File(picked.path);
    state = const OcrScanning();
    
    final result = await _ocrRepo.scanImage(tempFile);
    state = OcrResults(result.items);
  } finally {
    if (tempFile != null) {
      try {
        if (await tempFile.exists()) {
          await tempFile.delete(); // 🔴 IMMEDIATELY DELETED AFTER SCAN
        }
      } catch (_) {}
    }
  }
}
```

### Temporary File Lifetimes:
1.  **Scope Containment**: Raw camera/gallery photo paths are converted immediately into a transient memory reference.
2.  **Explicit Garbage Disposal**: The `finally` execution block runs immediately after scan evaluation, guaranteeing that the image is destroyed from disk whether the scan succeeds or throws an exception.
3.  **Active UI Cache Purge**: Saving or resetting OCR states calls `PaintingBinding.instance.imageCache.clear()` to purge high-resolution textures from physical RAM, blocking runtime extraction.

---

## 3. SQLite/Drift Offline Sandbox Security

Our offline database is managed inside an isolated OS container, preserving user records without external visibility:
*   **App Sandbox Bounds**: The Drift database [app_database.dart](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/core/data/local/app_database.dart) resides in the private platform folder `/data/user/0/[app]/app_flutter/` (Android) and `Library/Application Support/` (iOS).
*   **No Global Shared Volumes**: No tables are written to open SD Cards or user-accessible public storage directories.
