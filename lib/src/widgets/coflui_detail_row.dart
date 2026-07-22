import 'package:flutter/material.dart';

import '../theme/coflui_colors.dart';
import '../theme/coflui_typography.dart';

/// A labeled detail row: icon + label + value.
///
/// Used in detail views, summaries, and read-only info layouts. The [icon]
/// sits on the leading edge, [label] is a small muted caption, and [value]
/// is the prominent text. Pass [valueColor] to highlight (e.g. success/error).
class CofluiDetailRow extends StatelessWidget {
  /// Leading icon data. Rendered via [Icon].
  final IconData icon;

  /// Small muted label above the value.
  final String label;

  /// Prominent value text.
  final String value;

  /// Optional override for the value text color (e.g. theme primary).
  final Color? valueColor;

  /// Spacing between the icon and the text column. Defaults to 12.
  final double iconGap;

  /// Spacing between label and value. Defaults to 2.
  final double labelGap;

  const CofluiDetailRow({
    super.key,
    required this.icon,
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
        Icon(icon, size: 20, color: CofluiColors.onSurfaceVariant),
        SizedBox(width: iconGap),
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
