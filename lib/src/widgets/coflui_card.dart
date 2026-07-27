import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A styled surface container with an optional title.
///
/// Used by the dynamic `card`/`section` builders and directly in hand-written
/// UI. Defaults match the e_pg card look (white surface, soft border, subtle
/// shadow, rounded corners) but every value is overridable.
///
/// **Borderless mode**: pass [borderless] `true` (or [borderWidth] `0`) to
/// render a card with no outline — useful for flat layouts, gradient cards,
/// or when the card sits inside another surface.
///
/// **Custom backgrounds**: pass [gradient] for a gradient-painted card (takes
/// precedence over [color]). Set [color] to any [Colors] value.
///
/// ```dart
/// CofluiCard(borderless: true, child: …)            // no border
/// CofluiCard(gradient: CofluiGradients.accent, …)   // brand gradient bg
/// CofluiCard(color: Colors.transparent, elevation: 0, …)  // flat overlay
/// ```
class CofluiCard extends StatelessWidget {
  final Widget? child;
  final String? title;

  /// Outer padding inside the card. Defaults to 14 on all sides.
  final EdgeInsetsGeometry padding;

  /// Outer margin around the card. Defaults to zero (caller controls via
  /// wrapping widget). Useful when embedding in a list/grid.
  final EdgeInsetsGeometry margin;

  /// Corner radius. Defaults to 14.
  final double radius;

  /// Surface background color. Ignored when [gradient] is set.
  /// Defaults to [CofluiColors.surface] (white).
  final Color? color;

  /// Optional gradient background. Takes precedence over [color].
  final Gradient? gradient;

  /// Border color. Ignored when [borderless] is true.
  /// Defaults to a soft grey (#EDEFF3).
  final Color? borderColor;

  /// Border width. Defaults to 1. Set to 0 (or [borderless] `true`) to hide.
  final double borderWidth;

  /// Drop-shadow blur radius. Defaults to 6. Set to 0 for a flat card.
  final double elevation;

  /// Drop-shadow color. Defaults to a subtle dark tint.
  final Color? shadowColor;

  /// Shadow vertical offset. Defaults to 2.
  final Offset shadowOffset;

  /// Constrain the card to a max width (centers itself when set). Useful for
  /// desktop / web layouts.
  final double? maxWidth;

  /// Title-to-content gap. Defaults to 10.
  final double? titleGap;

  /// **Borderless mode** — removes the border (sets borderWidth to 0).
  /// Convenience alias for `borderWidth: 0`.
  final bool borderless;

  const CofluiCard({
    super.key,
    this.child,
    this.title,
    this.padding = const EdgeInsets.all(14),
    this.margin = EdgeInsets.zero,
    this.radius = 14,
    this.color,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1,
    this.elevation = 6,
    this.shadowColor,
    this.shadowOffset = const Offset(0, 2),
    this.maxWidth,
    this.titleGap,
    this.borderless = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasBorder = !borderless && borderWidth > 0;
    final hasShadow = !borderless && elevation > 0;

    Widget card = Container(
      padding: padding,
      margin: margin,
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? CofluiColors.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: hasBorder
            ? Border.all(
                color: borderColor ?? const Color(0xFFEDEFF3),
                width: borderWidth,
              )
            : null,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: shadowColor ??
                      const Color(0xFF1A1A1A).withValues(alpha: 0.04),
                  blurRadius: elevation,
                  offset: shadowOffset,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title?.isNotEmpty == true) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: CofluiTypography.cardTitle,
                fontWeight: FontWeight.bold,
                color: CofluiColors.onSurface,
              ),
            ),
            Gap(titleGap ?? 10),
          ],
          if (child != null) child!,
        ],
      ),
    );

    // Center when maxWidth is set.
    if (maxWidth != null) {
      card = Center(child: card);
    }
    return card;
  }
}
