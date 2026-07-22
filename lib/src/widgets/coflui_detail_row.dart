import 'package:flutter/material.dart';

import '../theme/coflui_colors.dart';
import '../theme/coflui_typography.dart';

/// A labeled detail row: icon + label + value.
///
/// Used in detail views, summaries, and read-only info layouts. The [icon]
/// sits on the leading edge, [label] is a small muted caption, and [value]
/// is the prominent text. Pass [valueColor] to highlight (e.g. success/error).
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

  /// Optional override for the value text color (e.g. theme primary).
  final Color? valueColor;

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
    this.valueColor,
    this.iconGap = 12,
    this.labelGap = 2,
  });

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
                style: TextStyle(
                  fontSize: CofluiTypography.body,
                  color: valueColor ?? CofluiColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
