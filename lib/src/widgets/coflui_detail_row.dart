import 'package:flutter/material.dart';

import '../theme/coflui_colors.dart';
import '../theme/coflui_typography.dart';

/// A labeled detail row: icon + label + value.
///
/// Used in detail views, summaries, and read-only info layouts. The [icon]
/// sits on the leading edge, [label] is a small muted caption, and [value]
/// is the prominent text.
///
/// **Value styling**: pass [valueStyle] for full control (size, weight, color,
/// family, letterSpacing, decoration, …). The shorthand [valueColor] /
/// [valueFontSize] / [valueFontWeight] props merge ON TOP of [valueStyle]
/// for convenience — so you can mix-and-match.
///
/// [icon] is a [Widget] (typically a [CofluiIcon] or [Icon]) so it accepts
/// any source: Material icon, SVG, PNG asset, or network URL. Pass `null`
/// to render the row without a leading icon.
///
/// ```dart
/// CofluiDetailRow(
///   icon: CofluiIcon.icon(Icons.person, size: 20),
///   label: 'Name',
///   value: 'Budi',
///   valueFontWeight: FontWeight.bold,
///   valueFontSize: 18,
/// )
/// ```
class CofluiDetailRow extends StatelessWidget {
  /// Leading icon widget (typically a [CofluiIcon] or [Icon]).
  /// When `null`, the row renders without an icon.
  final Widget? icon;

  /// Small muted label above the value.
  final String label;

  /// Prominent value text.
  final String value;

  /// Base text style for the value. Defaults to body typography.
  /// Override individual properties via [valueColor] / [valueFontSize] /
  /// [valueFontWeight] / [valueFontFamily] — those merge on top.
  final TextStyle? valueStyle;

  /// Value text color override. Merged on top of [valueStyle].
  final Color? valueColor;

  /// Value font size override. Merged on top of [valueStyle].
  final double? valueFontSize;

  /// Value font weight override. Merged on top of [valueStyle].
  final FontWeight? valueFontWeight;

  /// Value font family override. Merged on top of [valueStyle].
  final String? valueFontFamily;

  /// Value text overflow behavior. Defaults to clip (single line).
  final TextOverflow? valueOverflow;

  /// Max lines for the value. Defaults to null (unbounded).
  final int? valueMaxLines;

  /// Spacing between the icon and the text column. Defaults to 12.
  /// Ignored when [icon] is null.
  final double iconGap;

  /// Spacing between label and value. Defaults to 2.
  final double labelGap;

  const CofluiDetailRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
    this.valueColor,
    this.valueFontSize,
    this.valueFontWeight,
    this.valueFontFamily,
    this.valueOverflow,
    this.valueMaxLines,
    this.iconGap = 12,
    this.labelGap = 2,
  });

  /// Build the effective value TextStyle by merging all overrides.
  TextStyle get _effectiveValueStyle => TextStyle(
        fontSize: CofluiTypography.body,
        color: CofluiColors.onSurface,
      )
          // Base style from caller (if any)
          .merge(valueStyle)
          // Convenience overrides — applied last so they win.
          .copyWith(
            color: valueColor,
            fontSize: valueFontSize,
            fontWeight: valueFontWeight,
            fontFamily: valueFontFamily,
          );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          icon!,
          SizedBox(width: iconGap),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: CofluiTypography.caption,
                  color: CofluiColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: labelGap),
              Text(
                value,
                style: _effectiveValueStyle,
                overflow: valueOverflow,
                maxLines: valueMaxLines,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
