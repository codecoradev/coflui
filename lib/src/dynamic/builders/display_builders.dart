import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/models/ui_style.dart';
import 'package:coflui/src/dynamic/resolvers/icon_resolver.dart';
import 'package:coflui/src/dynamic/resolvers/style_resolver.dart';
import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:coflui/src/widgets/coflui_chip.dart';
import 'package:coflui/src/widgets/coflui_text.dart';
import 'package:flutter/material.dart';

/// Builder untuk komponen display (text, heading, divider).
class DisplayBuilders {
  DisplayBuilders._();

  /// Builds a [CofluiText] from a JSON `text` component.
  /// Uses `value` if present, otherwise falls back to `label`.
  static Widget text(BuildContext ctx, UIComponent c, _) {
    final s = c.style;
    final body =
        (c.value?.toString().isNotEmpty == true ? c.value : c.label) ?? '';
    return Align(
      alignment: StyleResolver.align(s),
      child: CofluiText(
        body.toString(),
        style: TextStyle(
          fontSize: s.fontSize ?? CofluiTypography.body,
          fontWeight: s.fontWeight ?? CofluiTypography.bodyWeight,
          color: s.color ?? CofluiColors.onSurfaceVariant,
        ),
        textAlign: StyleResolver.textAlign(s),
        maxLines: s.maxLines,
      ),
    );
  }

  /// Builds a bold, larger [CofluiText] from a JSON `heading` (or `title`)
  /// component.
  static Widget heading(BuildContext ctx, UIComponent c, _) {
    final merged = c.style.copyWith(UIStyle(
      fontSize: CofluiTypography.sectionTitle,
      fontWeight: FontWeight.bold,
      color: CofluiColors.onSurface,
    ));
    final body =
        (c.value?.toString().isNotEmpty == true ? c.value : c.label) ?? '';
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Align(
        alignment: StyleResolver.align(merged),
        child: CofluiText(
          body.toString(),
          style: TextStyle(
            fontSize: merged.fontSize,
            fontWeight: merged.fontWeight,
            color: merged.color,
          ),
          textAlign: StyleResolver.textAlign(merged),
          maxLines: merged.maxLines,
        ),
      ),
    );
  }

  /// Builds a horizontal [Divider] from a JSON `divider` component.
  /// `style.gap` controls the height; `style.borderWidth` controls thickness.
  static Widget divider(BuildContext ctx, UIComponent c, _) {
    final s = c.style;
    return Divider(
      height: s.gap ?? 16,
      thickness: s.borderWidth ?? 1,
      color: s.color ?? CofluiColors.divider,
    );
  }

  /// Builds a [CofluiChip] (status pill / badge) from a JSON `chip` component.
  ///
  /// Props:
  /// - `label`: text (falls back to `value` / `label`).
  /// - `variant`: `"success"` | `"warning"` | `"danger"` | `"info"` |
  ///   `"neutral"` (default neutral).
  /// - `icon`: Material icon name (e.g. `"check_circle"`).
  static Widget chip(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final label = (props['label'] ?? c.value ?? c.label ?? '').toString();
    final variant = _variantOf(props['variant']);
    final icon = IconResolver.resolve(props['icon']);
    final chip = CofluiChip(label, variant: variant, icon: icon);

    // When an `action` prop is present, make the chip tappable and forward
    // the tap to the controller (same convention as button / list_tile).
    final action = props['action']?.toString();
    if (action != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => controller.onAction(action, c.id),
          child: chip,
        ),
      );
    }
    return chip;
  }

  static CofluiChipVariant _variantOf(dynamic v) {
    switch ((v ?? 'neutral').toString().toLowerCase()) {
      case 'success':
      case 'approved':
      case 'ok':
      case 'green':
        return CofluiChipVariant.success;
      case 'warning':
      case 'pending':
      case 'orange':
        return CofluiChipVariant.warning;
      case 'danger':
      case 'error':
      case 'rejected':
      case 'red':
      case 'pdf':
        return CofluiChipVariant.danger;
      case 'info':
      case 'blue':
      case 'image':
      case 'img':
      case 'photo':
        return CofluiChipVariant.info;
      case 'neutral':
      default:
        return CofluiChipVariant.neutral;
    }
  }
}
