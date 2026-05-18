import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';

/// Premium micro-animation wrapper that scales and raises widgets on mouse hover.
/// Tailored for Web/Desktop platforms to create state-of-the-art tactile feedback.
class PremiumHoverBuilder extends StatefulWidget {
  final Widget child;
  
  /// Target scale on mouse hover. Default is 1.02.
  final double scale;
  
  /// Target opacity changes on mouse hover. Default is 1.0 (no opacity change).
  final double opacity;
  
  /// Curve used for the hover animation transitions.
  final Curve curve;

  /// Custom cursor displayed on mouse hover.
  final MouseCursor cursor;

  /// Semantic accessibility label for screen readers.
  final String? semanticLabel;

  const PremiumHoverBuilder({
    super.key,
    required this.child,
    this.scale = 1.02,
    this.opacity = 1.0,
    this.curve = const Cubic(0.25, 1.0, 0.5, 1.0), // Snappy ease-out curve
    this.cursor = SystemMouseCursors.click,
    this.semanticLabel,
  });

  @override
  State<PremiumHoverBuilder> createState() => _PremiumHoverBuilderState();
}

class _PremiumHoverBuilderState extends State<PremiumHoverBuilder> {
  bool _isHovered = false;

  void _updateHover(bool hovered) {
    if (mounted) {
      setState(() {
        _isHovered = hovered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    Widget result = MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _updateHover(true),
      onExit: (_) => _updateHover(false),
      child: AnimatedScale(
        scale: _isHovered ? widget.scale : 1.0,
        duration: tokens.motion.fast,
        curve: widget.curve,
        child: AnimatedOpacity(
          opacity: _isHovered ? widget.opacity : 1.0,
          duration: tokens.motion.fast,
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );

    if (widget.semanticLabel != null) {
      result = Semantics(
        label: widget.semanticLabel,
        container: true,
        child: result,
      );
    }

    return result;
  }
}
