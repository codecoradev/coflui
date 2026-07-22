import 'package:flutter/material.dart';

import '../theme/coflui_colors.dart';
import '../theme/coflui_typography.dart';

/// Visual style of a [CofluiChip].
enum CofluiChipVariant { neutral, success, warning, danger, info }

/// A compact pill / badge — colored label with an optional leading icon.
///
/// Used for status indicators (approved / pending / rejected), tags,
/// counters, and small categorical labels. Every variant resolves through
/// [CofluiColors] so it rebrands automatically.
///
/// ```dart
/// CofluiChip('Approved', variant: CofluiChipVariant.success)
/// CofluiChip('3', variant: CofluiChipVariant.info, icon: Icons.attach_file)
/// ```
class CofluiChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final CofluiChipVariant variant;

  /// Override the resolved background color.
  final Color? color;

  /// Override the resolved foreground (text/icon) color.
  final Color? foreground;

  /// Corner radius. Defaults to a pill-ish 8.
  final double radius;

  /// Horizontal padding. Defaults to 10.
  final double paddingH;

  /// Vertical padding. Defaults to 4.
  final double paddingV;

  const CofluiChip(
    this.label, {
    super.key,
    this.icon,
    this.variant = CofluiChipVariant.neutral,
    this.color,
    this.foreground,
    this.radius = 8,
    this.paddingH = 10,
    this.paddingV = 4,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? _bgOf(variant);
    final fg = foreground ?? _fgOf(variant);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: CofluiTypography.badge + 1,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  /// Soft background per variant (tinted from the accent token).
  static Color _bgOf(CofluiChipVariant v) => switch (v) {
        CofluiChipVariant.success =>
          CofluiColors.accentGreen.withValues(alpha: 0.14),
        CofluiChipVariant.warning =>
          CofluiColors.warning.withValues(alpha: 0.16),
        CofluiChipVariant.danger =>
          CofluiColors.error.withValues(alpha: 0.12),
        CofluiChipVariant.info =>
          CofluiColors.accentBlue.withValues(alpha: 0.12),
        CofluiChipVariant.neutral =>
          CofluiColors.onSurface.withValues(alpha: 0.08),
      };

  /// Foreground (text/icon) color per variant.
  static Color _fgOf(CofluiChipVariant v) => switch (v) {
        CofluiChipVariant.success =>
          _darken(CofluiColors.accentGreen, 0.12),
        CofluiChipVariant.warning => CofluiColors.warning,
        CofluiChipVariant.danger => CofluiColors.error,
        CofluiChipVariant.info => CofluiColors.accentBlue,
        CofluiChipVariant.neutral => CofluiColors.onSurfaceVariant,
      };

  /// Darken a [color] by [amount] (0..1) for readable text on tints.
  static Color _darken(Color color, double amount) {
    final darkened = Color.lerp(color, Colors.black, amount)!;
    return darkened;
  }
}
