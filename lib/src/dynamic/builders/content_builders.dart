// ignore_for_file: avoid_dynamic_calls

import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/resolvers/icon_resolver.dart';
import 'package:coflui/src/widgets/coflui_detail_row.dart';
import 'package:coflui/src/widgets/coflui_icon.dart';
import 'package:coflui/src/widgets/coflui_list_tile.dart';
import 'package:flutter/material.dart';

/// Builders for content components: `listTile` and `detailRow`.
///
/// These map the new native widgets ([CofluiListTile], [CofluiDetailRow]) into
/// the dynamic-UI engine so JSON can instantiate them directly.
class ContentBuilders {
  ContentBuilders._();

  /// Builds a `listTile` from JSON.
  ///
  /// Props:
  /// - `title`: primary text (falls back to `label`).
  /// - `subtitle`: secondary text.
  /// - `leading`: icon name / source (→ [CofluiIcon]).
  /// - `trailing`: icon name / source (→ [CofluiIcon]).
  /// - `action`: when set, tapping the tile calls
  ///   `controller.onAction(action, componentId)`.
  static Widget listTile(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final title = (props['title'] ?? c.label ?? '').toString();
    final subtitle = props['subtitle']?.toString();
    final action = props['action']?.toString();

    return CofluiListTile(
      title: title,
      subtitle: subtitle,
      leading: _iconOf(props['leading']),
      trailing: _iconOf(props['trailing']),
      onTap: action != null
          ? () => controller.onAction(action, c.id)
          : null,
    );
  }

  /// Builds a `detailRow` from JSON.
  ///
  /// Props:
  /// - `icon`: Material icon name (e.g. `"person"`).
  /// - `label`: small caption text (falls back to `label`).
  /// - `value`: prominent text (falls back to `value`).
  /// - `highlight`: when `true`, renders the value in the theme primary color.
  static Widget detailRow(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final label = (props['label'] ?? c.label ?? '').toString();
    final value = (props['value'] ?? c.value ?? '').toString();
    final iconData =
        IconResolver.resolve(props['icon']) ?? Icons.info_outline;
    final highlight = props['highlight'] == true;

    return CofluiDetailRow(
      icon: iconData,
      label: label,
      value: value,
      valueColor: highlight ? Theme.of(ctx).colorScheme.primary : null,
    );
  }

  /// Builds a leading/trailing [CofluiIcon] from a prop value.
  ///
  /// Accepts an icon name (`"home"`), a code-point (`"0xe318"`), or an
  /// asset/URL path (auto-detected by [CofluiIcon]).
  static Widget? _iconOf(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty) return null;

    // Try named/code-point resolution first.
    final resolved = IconResolver.resolve(s);
    if (resolved != null) return CofluiIcon.icon(resolved, size: 24);

    // Otherwise treat as an asset / URL path.
    return CofluiIcon(s, size: 24);
  }
}
