import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';

/// Standard layout breakpoints for ProDiet Unified.
class AppBreakpoints {
  AppBreakpoints._();

  /// Devices with width smaller than 600dp are considered mobile (phones).
  static const double mobileMax = 600.0;

  /// Devices with width smaller than 1200dp are tablets.
  static const double tabletMax = 1200.0;

  /// Standard content container max-width on extra-large screens to prevent stretching.
  static const double maxDesktopContentWidth = 1200.0;
}

/// Dynamic viewport helper providing clean platform queries inside build contexts.
extension ResponsiveContextExtension on BuildContext {
  /// True if current viewport is a standard mobile screen.
  bool get isMobile => MediaQuery.sizeOf(this).width < AppBreakpoints.mobileMax;

  /// True if current viewport is a tablet screen.
  bool get isTablet {
    final width = MediaQuery.sizeOf(this).width;
    return width >= AppBreakpoints.mobileMax && width < AppBreakpoints.tabletMax;
  }

  /// True if current viewport is a desktop/web screen.
  bool get isDesktop => MediaQuery.sizeOf(this).width >= AppBreakpoints.tabletMax;

  /// Dynamic margin sizing optimized per form-factor.
  double get responsiveHorizontalMargin {
    if (isDesktop) return 48.0;
    if (isTablet) return 24.0;
    return 16.0;
  }
}

/// A premium, production-grade widget that builds responsive layouts
/// dynamically based on standard breakpoints.
class AdaptiveLayout extends StatelessWidget {
  /// Built for standard mobile viewports.
  final WidgetBuilder mobileBuilder;

  /// Built for tablet viewports (optional, falls back to [mobileBuilder]).
  final WidgetBuilder? tabletBuilder;

  /// Built for desktop viewports (optional, falls back to [tabletBuilder] or [mobileBuilder]).
  final WidgetBuilder? desktopBuilder;

  const AdaptiveLayout({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= AppBreakpoints.tabletMax && desktopBuilder != null) {
          return desktopBuilder!(context);
        }

        if (width >= AppBreakpoints.mobileMax && tabletBuilder != null) {
          return tabletBuilder!(context);
        }

        return mobileBuilder(context);
      },
    );
  }
}

/// Centered content container that prevents wide-screen horizontal stretching.
/// Wraps desktop views inside an elegant, premium container with subtle outlines.
class ResponsiveContentContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContentContainer({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxDesktopContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isWide = context.isDesktop;

    if (!isWide) {
      return Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: context.responsiveHorizontalMargin),
        child: child,
      );
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: padding ?? const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: tokens.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(tokens.radius.lg),
          border: Border.all(
            color: tokens.colors.outline.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
