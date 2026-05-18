import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Supported shortcut operations inside ProDiet Unified.
enum ProDietShortcutAction {
  navigateDashboard,
  navigateMeals,
  navigateInventory,
  navigateVoice,
  closePanel,
}

/// Logical intent representing a keyboard shortcut command.
class ProDietShortcutIntent extends Intent {
  final ProDietShortcutAction action;
  const ProDietShortcutIntent(this.action);
}

/// Centralized hotkey and keyboard focus manager widget for Desktop/Web.
class KeyboardNavigationListener extends StatelessWidget {
  final Widget child;
  
  /// Callback triggered when a navigation shortcut is detected.
  final ValueChanged<ProDietShortcutAction> onShortcutTriggered;

  const KeyboardNavigationListener({
    super.key,
    required this.child,
    required this.onShortcutTriggered,
  });

  @override
  Widget build(BuildContext context) {
    // Define platform-specific keyboard triggers
    final shortcuts = <ShortcutActivator, Intent>{
      // Ctrl + D -> Dashboard
      LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyD,
      ): const ProDietShortcutIntent(ProDietShortcutAction.navigateDashboard),

      // Ctrl + M -> Meals
      LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyM,
      ): const ProDietShortcutIntent(ProDietShortcutAction.navigateMeals),

      // Ctrl + I -> Inventory
      LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyI,
      ): const ProDietShortcutIntent(ProDietShortcutAction.navigateInventory),

      // Ctrl + V -> Voice Assistant
      LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyV,
      ): const ProDietShortcutIntent(ProDietShortcutAction.navigateVoice),

      // Escape -> Close Panel
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): const ProDietShortcutIntent(ProDietShortcutAction.closePanel),
    };

    final actions = <Type, Action<Intent>>{
      ProDietShortcutIntent: CallbackAction<ProDietShortcutIntent>(
        onInvoke: (intent) {
          onShortcutTriggered(intent.action);
          return null;
        },
      ),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

/// Accessibility visual helper wrapping controls with high-visibility focus borders
/// when navigated via keyboard.
class AccessibilityFocusOutline extends StatefulWidget {
  final Widget child;
  final FocusNode? focusNode;
  final double borderRadius;

  const AccessibilityFocusOutline({
    super.key,
    required this.child,
    this.focusNode,
    this.borderRadius = 8.0,
  });

  @override
  State<AccessibilityFocusOutline> createState() => _AccessibilityFocusOutlineState();
}

class _AccessibilityFocusOutlineState extends State<AccessibilityFocusOutline> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _hasFocus ? theme.colorScheme.primary : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
