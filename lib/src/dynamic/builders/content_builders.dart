// ignore_for_file: avoid_dynamic_calls

import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/resolvers/icon_resolver.dart';
import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/widgets/coflui_detail_row.dart';
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
  /// - `leading` / `trailing`: icon name, code-point, asset, or URL
  ///   (auto-detected via [resolveIconWidget]).
  /// - `leadingSize` / `trailingSize`: icon size (default 24).
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
      leading: resolveIconWidget(
        props['leading'],
        size: _toDouble(props['leadingSize']) ?? 24,
      ),
      trailing: resolveIconWidget(
        props['trailing'],
        size: _toDouble(props['trailingSize']) ?? 24,
      ),
      onTap: action != null
          ? () => controller.onAction(action, c.id)
          : null,
    );
  }

  /// Builds a `detailRow` from JSON.
  ///
  /// Props:
  /// - `icon`: Material icon name, code-point, asset path, or URL
  ///   (auto-detected via [resolveIconWidget]).
  /// - `iconSize`: icon size in logical px (default 20).
  /// - `label`: small caption text (falls back to `label`).
  /// - `value`: prominent text (falls back to `value`).
  /// - `highlight`: when `true`, renders the value in the theme primary color.
  static Widget detailRow(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final label = (props['label'] ?? c.label ?? '').toString();
    final value = (props['value'] ?? c.value ?? '').toString();
    final highlight = props['highlight'] == true;
    final iconSize = _toDouble(props['iconSize']) ?? 20;

    return CofluiDetailRow(
      icon: resolveIconWidget(
        props['icon'],
        size: iconSize,
        color: CofluiColors.onSurfaceVariant,
      ),
      label: label,
      value: value,
      valueColor: highlight ? Theme.of(ctx).colorScheme.primary : null,
    );
  }
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}
