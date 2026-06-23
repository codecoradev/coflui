import 'package:coflui/src/theme/coflui_breakpoints.dart';
import 'package:flutter/material.dart';

/// A responsive grid that derives its column count purely from
/// [CofluiBreakpoints] — no manual per-breakpoint hints required.
///
/// Defaults: mobile = 1 column, tablet = 2, desktop = 3. Override the three
/// column counts if a particular layout needs denser packing.
///
/// Children are laid out at a fixed, computed width so every cell in a row is
/// equal — using [Wrap] under the hood so rows wrap automatically.
class CofluiGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  const CofluiGrid({
    super.key,
    required this.children,
    this.spacing = 12,
    this.runSpacing = 12,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final cols = switch (CofluiBreakpoints.deviceOf(width)) {
          CofluiDevice.desktop => desktopColumns,
          CofluiDevice.tablet => tabletColumns,
          CofluiDevice.mobile => mobileColumns,
        };
        final childWidth = (width - spacing * (cols - 1)) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children
              .map((c) => SizedBox(width: childWidth, child: c))
              .toList(),
        );
      },
    );
  }
}
