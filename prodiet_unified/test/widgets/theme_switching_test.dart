import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Theme switching mid-session updates activeThemeProvider', (tester) async {
    SharedPreferences.setMockInitialValues({});
    
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Initial state
    expect(container.read(activeThemeProvider), ActiveTheme.t1Dark);

    // Switch to T2
    container.read(activeThemeProvider.notifier).setTheme(ActiveTheme.t2Dark);
    expect(container.read(activeThemeProvider), ActiveTheme.t2Dark);
    
    // Switch back to T1
    container.read(activeThemeProvider.notifier).setTheme(ActiveTheme.t1Dark);
    expect(container.read(activeThemeProvider), ActiveTheme.t1Dark);
  });
}
