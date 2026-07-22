import 'package:flutter/material.dart';

import '../theme/coflui_colors.dart';
import '../theme/coflui_typography.dart';

/// A card-style list row with optional [leading], [title], [subtitle], and
/// [trailing] widgets.
///
/// Unlike a plain [ListTile], this renders a rounded surface container
/// (Material + InkWell) suitable for grouped lists, history items, and
/// selection rows. Every color follows [CofluiColors] / [Theme] so it
/// rebrands automatically.
class CofluiListTile extends StatelessWidget {
  /// Leading widget — typically a [CofluiIcon] or avatar.
  final Widget? leading;

  /// Primary text (bold).
  final String title;

  /// Secondary text beneath the title (muted).
  final String? subtitle;

  /// Trailing widget — typically an icon or status badge.
  final Widget? trailing;

  /// Tap handler. When `null` the row is non-interactive (no ripple).
  final VoidCallback? onTap;

  /// External padding. Defaults to horizontal 16 + vertical 6.
  final EdgeInsetsGeometry? padding;

  /// Inner content padding. Defaults to 12 on all sides.
  final EdgeInsetsGeometry contentPadding;

  /// Surface color. Defaults to the theme's lowest surface container.
  final Color? color;

  /// Corner radius.
  final double radius;

  const CofluiListTile({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
    this.contentPadding = const EdgeInsets.all(12),
    this.color,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: color ?? theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: contentPadding,
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: CofluiTypography.itemTitle,
                          fontWeight: FontWeight.w600,
                          color: CofluiColors.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: CofluiTypography.caption,
                            color: CofluiColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
