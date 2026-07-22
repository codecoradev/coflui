// ignore_for_file: avoid_dynamic_calls

import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/resolvers/icon_resolver.dart';
import 'package:coflui/src/widgets/coflui_gradients.dart';
import 'package:coflui/src/widgets/coflui_icon.dart';
import 'package:flutter/material.dart';

/// Builders for media components: `icon`, `image`, and `gradientBar`.
///
/// These lean on [CofluiIcon] (auto-detecting PNG / SVG / URL / IconData) and
/// [CofluiGradientBar] so JSON gets the same widgets as hand-written UI.
class MediaBuilders {
  MediaBuilders._();

  /// Builds an `icon` from JSON.
  ///
  /// Props:
  /// - `icon`: Material icon name (e.g. `"home"`, `"send"`) OR a code-point
  ///   string (`"0xe318"`).
  /// - `source`: asset path or URL — when set, takes priority and auto-detects
  ///   PNG / SVG / network via [CofluiIcon].
  /// - `size`: double (default 24).
  /// - `color`: hex color string.
  ///
  /// Either `icon` (name) or `source` (path/url) should be provided. When both
  /// are given, `source` wins (it covers the richest formats).
  static Widget icon(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final size = _toDouble(props['size']) ?? 24;
    final color = _maybeColor(props['color']);

    // 1. Explicit source (asset / URL) — auto-detect format.
    final source = props['source']?.toString();
    if (source != null && source.isNotEmpty) {
      return CofluiIcon(source, size: size, color: color);
    }

    // 2. Named / code-point icon.
    final resolved = IconResolver.resolve(props['icon'] ?? c.value);
    if (resolved != null) {
      return CofluiIcon.icon(resolved, size: size, color: color);
    }

    // 3. value-as-source fallback (value might be a path/URL).
    final valueStr = c.value?.toString();
    if (valueStr != null && valueStr.isNotEmpty) {
      return CofluiIcon(valueStr, size: size, color: color);
    }

    // Nothing resolvable → broken-image placeholder.
    return CofluiIcon.icon(Icons.broken_image_outlined, size: size, color: color);
  }

  /// Builds an `image` from JSON.
  ///
  /// Props:
  /// - `src` / `source` / `url`: image path or URL (required).
  /// - `width`, `height`: dimensions (default: fill intrinsic via `size`).
  /// - `size`: square shorthand (used when width/height unset, default 64).
  /// - `fit`: BoxFit name (`cover` / `contain` / `fill` / `fitWidth` / …).
  /// - `color`: optional tint / blend.
  static Widget image(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final src = (props['src'] ??
            props['source'] ??
            props['url'] ??
            c.value)
        ?.toString();
    final width = _toDouble(props['width']);
    final height = _toDouble(props['height']);
    final size = _toDouble(props['size']) ?? 64;
    final fit = _boxFitOf(props['fit']);
    final color = _maybeColor(props['color']);

    if (src == null || src.isEmpty) {
      return CofluiIcon.icon(Icons.broken_image_outlined, size: size, color: color);
    }

    // CofluiIcon renders square icons. For non-square images, prefer the
    // explicit width; fit handles the aspect ratio. Falls back to `size`.
    final dimension = width ?? height ?? size;
    return CofluiIcon(src, size: dimension, fit: fit, color: color);
  }

  /// Builds a `gradientBar` from JSON.
  ///
  /// Props:
  /// - `gradient`: preset name — `"accent"` (default), `"cool"`, `"warm"`.
  /// - `height`: double (default 6).
  /// - `radius`: double corner radius (default 0).
  static Widget gradientBar(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    return CofluiGradientBar(
      gradient: (props['gradient'] ?? 'accent').toString(),
      height: _toDouble(props['height']) ?? 6,
      borderRadius: (_toDouble(props['radius']) ?? 0) > 0
          ? BorderRadius.circular(_toDouble(props['radius'])!)
          : null,
    );
  }
}

// ── Parsing helpers ────────────────────────────────────────────────────────

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

Color? _maybeColor(dynamic v) {
  if (v == null) return null;
  if (v is Color) return v;
  final s = v.toString();
  var hex = s.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex'; // #RRGGBB → opaque
  final parsed = int.tryParse(hex, radix: 16);
  return parsed != null ? Color(parsed) : null;
}

BoxFit _boxFitOf(dynamic v) {
  switch ((v ?? 'contain').toString().toLowerCase()) {
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fitwidth':
    case 'fit_width':
      return BoxFit.fitWidth;
    case 'fitheight':
    case 'fit_height':
      return BoxFit.fitHeight;
    case 'none':
      return BoxFit.none;
    case 'scaledown':
    case 'scale_down':
      return BoxFit.scaleDown;
    case 'contain':
    default:
      return BoxFit.contain;
  }
}
