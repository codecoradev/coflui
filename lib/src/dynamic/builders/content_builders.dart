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
  /// - `highlight`: when `true`, renders the value in the theme primary color
  ///   (shorthand for valueColor = theme.primary).
  /// - `valueColor`: hex color string (e.g. "#FF8800") for the value text.
  /// - `valueFontSize`: value font size in px (e.g. 18).
  /// - `valueFontWeight`: value weight — "bold" | "normal" | "w500" | 600 | …
  /// - `valueMaxLines`: clamp the value to N lines (default unlimited).
  /// - `valueOverflow`: "ellipsis" | "clip" | "visible" (default clip).
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
      valueColor: highlight
          ? Theme.of(ctx).colorScheme.primary
          : _colorOf(props['valueColor']),
      valueFontSize: _toDouble(props['valueFontSize']),
      valueFontWeight: _weightOf(props['valueFontWeight']),
      valueMaxLines: props['valueMaxLines'] is int
          ? props['valueMaxLines'] as int
          : null,
      valueOverflow: _overflowOf(props['valueOverflow']),
    );
  }
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

/// Parse a JSON color (hex string) into a [Color]. Returns null when unset.
Color? _colorOf(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  var hex = s.replaceFirst('#', '');
  if (hex.isEmpty) return null;
  if (hex.length == 6) hex = 'FF$hex'; // #RRGGBB → opaque
  final parsed = int.tryParse(hex, radix: 16);
  return parsed != null ? Color(parsed) : null;
}

/// Parse a font weight from name or number. Returns null when unset.
FontWeight? _weightOf(dynamic v) {
  if (v == null) return null;
  if (v is int) {
    return FontWeight.values.firstWhere(
      (w) => w.index == (v ~/ 100).clamp(0, 8),
      orElse: () => FontWeight.normal,
    );
  }
  switch (v.toString().toLowerCase()) {
    case 'bold':
    case 'w700':
    case '700':
      return FontWeight.bold;
    case 'normal':
    case 'w400':
    case '400':
      return FontWeight.normal;
    case 'w100':
    case '100':
    case 'thin':
      return FontWeight.w100;
    case 'w200':
    case '200':
    case 'extralight':
      return FontWeight.w200;
    case 'w300':
    case '300':
    case 'light':
      return FontWeight.w300;
    case 'w500':
    case '500':
    case 'medium':
      return FontWeight.w500;
    case 'w600':
    case '600':
    case 'semibold':
      return FontWeight.w600;
    case 'w800':
    case '800':
    case 'extrabold':
      return FontWeight.w800;
    case 'w900':
    case '900':
    case 'black':
      return FontWeight.w900;
    default:
      return null;
  }
}

/// Parse a [TextOverflow] by name. Returns null when unset.
TextOverflow? _overflowOf(dynamic v) {
  if (v == null) return null;
  switch (v.toString().toLowerCase()) {
    case 'ellipsis':
      return TextOverflow.ellipsis;
    case 'clip':
      return TextOverflow.clip;
    case 'visible':
      return TextOverflow.visible;
    case 'fade':
      return TextOverflow.fade;
    default:
      return null;
  }
}
