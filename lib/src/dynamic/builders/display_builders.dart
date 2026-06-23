import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/models/ui_style.dart';
import 'package:coflui/src/dynamic/resolvers/style_resolver.dart';
import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:coflui/src/widgets/coflui_text.dart';
import 'package:flutter/material.dart';

/// Builder untuk komponen display (text, heading, divider).
class DisplayBuilders {
  DisplayBuilders._();

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

  static Widget divider(BuildContext ctx, UIComponent c, _) {
    final s = c.style;
    return Divider(
      height: s.gap ?? 16,
      thickness: s.borderWidth ?? 1,
      color: s.color ?? CofluiColors.divider,
    );
  }
}
