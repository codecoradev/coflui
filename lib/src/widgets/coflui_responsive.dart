import 'package:coflui/src/theme/coflui_breakpoints.dart';
import 'package:flutter/material.dart';

/// Renders a different widget subtree per form factor.
///
/// Resolution is purely [CofluiBreakpoints]-driven (width thresholds):
///   - [mobile] is always required
///   - [tablet] falls back to [mobile] when null
///   - [desktop] falls back to [tablet] (then [mobile]) when null
///
/// ```dart
/// CofluiResponsive(
///   mobile: OneColumnLayout(),
///   tablet: TwoColumnLayout(),
///   desktop: MasterDetailLayout(),
/// )
/// ```
class CofluiResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const CofluiResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final device = CofluiBreakpoints.deviceOf(constraints.maxWidth);
        switch (device) {
          case CofluiDevice.desktop:
            return desktop ?? tablet ?? mobile;
          case CofluiDevice.tablet:
            return tablet ?? mobile;
          case CofluiDevice.mobile:
            return mobile;
        }
      },
    );
  }
}
