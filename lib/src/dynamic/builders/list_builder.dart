// ignore_for_file: avoid_dynamic_calls

import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/widgets/dynamic_ui_widget.dart';
import 'package:flutter/material.dart';

/// Builder for the `list` component — repeat a child template over an array.
///
/// This is the key enabler for full-page dynamic layouts: attachments,
/// approvers, line items, comments, timelines — anything with `[]`. Instead
/// of hard-coding every item in JSON, the host provides **one child template**
/// plus an **items array**, and the list renders one copy per item with
/// `{field}` placeholders interpolated from each item.
///
/// JSON shape:
/// ```json
/// {
///   "id": "approvers",
///   "type": "list",
///   "props": {
///     "items": [
///       {"name": "Andi", "role": "Manager", "status": "approved"},
///       {"name": "Maya", "role": "Finance", "status": "pending"}
///     ],
///     "direction": "vertical",   // vertical | horizontal | wrap (default vertical)
///     "spacing": 8,
///     "emptyText": "No items"     // shown when items is empty/null
///   },
///   "children": [
///     {
///       "type": "list_tile",
///       "props": {"title": "{name}", "subtitle": "{role}", "trailing": "{status}"}
///     }
///   ]
/// }
/// ```
///
/// The **first child** is the template. Placeholders `{field}` are replaced
/// in every string (label, value, props values, nested children) from the
/// item map. Unknown keys resolve to an empty string.
class ListBuilders {
  ListBuilders._();

  static Widget list(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final items = props['items'];

    // ── Empty / null items → placeholder ────────────────────────────────
    if (items is! List || items.isEmpty) {
      final emptyText = (props['emptyText'] ?? 'No items').toString();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          emptyText,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF999999),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    // The first child is the template cloned per item.
    final template =
        c.children.isNotEmpty ? c.children.first : null;
    if (template == null) return const SizedBox.shrink();

    final spacing = _toDouble(props['spacing']) ?? 8;
    final direction = (props['direction'] ?? 'vertical').toString().toLowerCase();

    final built = items.map((raw) {
      final data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : <String, dynamic>{'value': raw};
      final child = interpolateComponent(template, data);
      return DynamicUIWidget(child, controller: controller);
    }).toList();

    switch (direction) {
      case 'wrap':
        return Wrap(spacing: spacing, runSpacing: spacing, children: built);
      case 'horizontal':
      case 'row':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(spacing: spacing, children: built),
        );
      case 'vertical':
      case 'column':
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: built,
        );
    }
  }
}

/// Interpolates `{field}` placeholders in a [UIComponent] tree against [data].
///
/// Returns a **new** tree — the original is never mutated. Placeholders are
/// matched by `\{(\w+)\}` and replaced with `data[key]?.toString()`. Unknown
/// keys become empty strings.
///
/// Scanned surfaces: [id], [label], string [value], every [props] string
/// value, and all [children] recursively.
UIComponent interpolateComponent(
  UIComponent c,
  Map<String, dynamic> data,
) =>
    UIComponent(
      id: _interp(c.id, data),
      type: c.type,
      label: c.label != null ? _interp(c.label!, data) : null,
      value: c.value is String ? _interp(c.value as String, data) : c.value,
      props: _interpProps(c.props, data),
      style: c.style,
      children: c.children
          .map((ch) => interpolateComponent(ch, data))
          .toList(),
    );

Map<String, dynamic> _interpProps(
  Map<String, dynamic> props,
  Map<String, dynamic> data,
) =>
    props.map((k, v) => MapEntry(k, _interpValue(v, data)));

dynamic _interpValue(dynamic v, Map<String, dynamic> data) {
  if (v is String) return _interp(v, data);
  if (v is List) return v.map((e) => _interpValue(e, data)).toList();
  if (v is Map) {
    return v.map((k, val) => MapEntry(k, _interpValue(val, data)));
  }
  return v;
}

/// Matches `{word}` placeholders and substitutes from [data].
String _interp(String s, Map<String, dynamic> data) =>
    s.replaceAllMapped(RegExp(r'\{(\w+)\}'), (m) {
      final key = m.group(1)!;
      final val = data[key];
      if (val == null) return '';
      if (val is bool) return val ? 'true' : 'false';
      return val.toString();
    });

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}
