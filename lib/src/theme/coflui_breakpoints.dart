import 'package:flutter/widgets.dart';

/// The three form factors Coflui adapts to.
enum CofluiDevice { mobile, tablet, desktop }

/// Responsive breakpoint configuration (width in logical pixels).
///
/// Thresholds follow Material 3 adaptive guidance:
///   - mobile    : width < 600
///   - tablet    : 600 ≤ width < 1024
///   - desktop   : width ≥ 1024
///
/// Override at app boot if your design system differs:
/// ```dart
/// CofluiBreakpoints.tablet = 840;
/// CofluiBreakpoints.desktop = 1280;
/// ```
class CofluiBreakpoints {
  CofluiBreakpoints._();

  /// The minimum width at which the layout is considered "tablet".
  static double tablet = 600;

  /// The minimum width at which the layout is considered "desktop".
  static double desktop = 1024;

  /// Classify a raw width into a [CofluiDevice].
  static CofluiDevice deviceOf(double width) {
    if (width >= desktop) return CofluiDevice.desktop;
    if (width >= tablet) return CofluiDevice.tablet;
    return CofluiDevice.mobile;
  }

  /// Resolve the active device from the current [BuildContext] (via
  /// [MediaQuery]). Prefer passing a known width (e.g. from LayoutBuilder)
  /// when rendering inside a constrained box.
  static CofluiDevice of(BuildContext context) =>
      deviceOf(MediaQuery.sizeOf(context).width);

  static bool isMobile(BuildContext context) =>
      of(context) == CofluiDevice.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == CofluiDevice.tablet;
  static bool isDesktop(BuildContext context) =>
      of(context) == CofluiDevice.desktop;
}
