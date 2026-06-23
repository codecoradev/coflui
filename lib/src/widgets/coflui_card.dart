import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A styled surface container with an optional title.
///
/// Used by the dynamic `card`/`section` builders and directly in hand-written
/// UI. Defaults match the e_pg card look (white surface, soft border, subtle
/// shadow, rounded corners) but every value is overridable.
class CofluiCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double elevation;
  final double? titleGap;

  const CofluiCard({
    super.key,
    this.child,
    this.title,
    this.padding = const EdgeInsets.all(14),
    this.radius = 14,
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.elevation = 6,
    this.titleGap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? CofluiColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? const Color(0xFFEDEFF3),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withValues(alpha: 0.04),
            blurRadius: elevation,
            offset: const Offset(0, 2),
          ),
        ],
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
  }
}
