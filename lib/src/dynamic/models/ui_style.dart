// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

/// Model style untuk [UIComponent].
///
/// Style di-parse dari JSON mentah menjadi tipe Flutter yang siap dipakai
/// (Color, FontWeight, dll) sehingga builder tidak perlu parse ulang.
///
/// Semua nilai dimensi adalah **logical pixel mentah** (tidak di-scale) agar
/// package tetap dependency-free dan prediktif lintas device. Responsivitas
/// ditangani di level *layout* (grid, breakpoints, max-width).
///
/// Konvensi field JSON:
/// ```json
/// {
///   "padding": 16,
///   "paddingVertical": 8,
///   "paddingHorizontal": 12,
///   "gap": 12,
///   "fontSize": 14,
///   "fontWeight": "bold",        // "normal" | "bold" | "w500" | 700
///   "color": "#1A1A1A",          // hex #RRGGBB atau #AARRGGBB
///   "bgColor": "#FFFFFF",
///   "borderColor": "#CCCCCC",
///   "borderWidth": 1,
///   "radius": 12,
///   "align": "center",           // left | center | right | justify | start | end
///   "crossAxis": "center",       // start | center | end | stretch
///   "mainAxis": "start",         // start | center | end | spaceBetween | spaceEvenly
///   "elevation": 2,
///   "expand": true,
///   "widthFactor": 1.0,
///   "maxLines": 2
/// }
/// ```
class UIStyle {
  final double? padding;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final double? gap;

  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontStyle; // "italic" | "normal"
  final Color? color;
  final String? align;
  final int? maxLines;

  final Color? bgColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? radius;
  final double? elevation;

  final String? crossAxis;
  final String? mainAxis;
  final bool? expand;
  final double? widthFactor;

  const UIStyle({
    this.padding,
    this.paddingVertical,
    this.paddingHorizontal,
    this.gap,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.color,
    this.align,
    this.maxLines,
    this.bgColor,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.elevation,
    this.crossAxis,
    this.mainAxis,
    this.expand,
    this.widthFactor,
  });

  /// A sentinel instance with all fields null — used as a default / fallback.
  static const empty = UIStyle();

  factory UIStyle.fromJson(dynamic j) {
    if (j is String) {
      // style berupa token string belum didukung di phase awal → abaikan.
      return const UIStyle();
    }
    if (j is! Map) return const UIStyle();
    final m = Map<String, dynamic>.from(j);
    return UIStyle(
      padding: _toDouble(m['padding']),
      paddingVertical: _toDouble(m['paddingVertical'] ?? m['py']),
      paddingHorizontal: _toDouble(m['paddingHorizontal'] ?? m['px']),
      gap: _toDouble(m['gap']),
      fontSize: _toDouble(m['fontSize']),
      fontWeight: _parseWeight(m['fontWeight']),
      fontStyle: m['fontStyle'] as String?,
      color: _parseColor(m['color']),
      align: m['align'] as String?,
      maxLines: m['maxLines'] is int ? m['maxLines'] as int : null,
      bgColor: _parseColor(m['bgColor'] ?? m['backgroundColor']),
      borderColor: _parseColor(m['borderColor']),
      borderWidth: _toDouble(m['borderWidth']),
      radius: _toDouble(m['radius']),
      elevation: _toDouble(m['elevation']),
      crossAxis: m['crossAxis'] as String?,
      mainAxis: m['mainAxis'] as String?,
      expand: m['expand'] is bool ? m['expand'] as bool : null,
      widthFactor: _toDouble(m['widthFactor']),
    );
  }

  UIStyle copyWith(UIStyle? o) {
    if (o == null) return this;
    return UIStyle(
      padding: o.padding ?? padding,
      paddingVertical: o.paddingVertical ?? paddingVertical,
      paddingHorizontal: o.paddingHorizontal ?? paddingHorizontal,
      gap: o.gap ?? gap,
      fontSize: o.fontSize ?? fontSize,
      fontWeight: o.fontWeight ?? fontWeight,
      fontStyle: o.fontStyle ?? fontStyle,
      color: o.color ?? color,
      align: o.align ?? align,
      maxLines: o.maxLines ?? maxLines,
      bgColor: o.bgColor ?? bgColor,
      borderColor: o.borderColor ?? borderColor,
      borderWidth: o.borderWidth ?? borderWidth,
      radius: o.radius ?? radius,
      elevation: o.elevation ?? elevation,
      crossAxis: o.crossAxis ?? crossAxis,
      mainAxis: o.mainAxis ?? mainAxis,
      expand: o.expand ?? expand,
      widthFactor: o.widthFactor ?? widthFactor,
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static Color? _parseColor(dynamic v) {
    if (v == null) return null;
    var hex = v.toString().trim();
    if (hex.isEmpty) return null;
    if (hex.startsWith('#')) hex = hex.substring(1);
    // Expand shorthand #RGB / #RGBA
    if (hex.length == 3) {
      hex = hex.split('').map((c) => '$c$c').join();
    }
    if (hex.length == 4) {
      final r = hex[0] + hex[0];
      final g = hex[1] + hex[1];
      final b = hex[2] + hex[2];
      final a = hex[3] + hex[3];
      hex = '$a$r$g$b';
    }
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return null;
    if (hex.length == 6) return Color(0xFF000000 | value);
    return Color(value);
  }

  static FontWeight? _parseWeight(dynamic v) {
    if (v == null) return null;
    if (v is num) {
      final idx = v.toInt().clamp(0, FontWeight.values.length - 1);
      return FontWeight.values[idx];
    }
    switch (v.toString().toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      case 'w100':
      case 'thin':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
      case 'light':
        return FontWeight.w300;
      case 'w400':
      case 'regular':
        return FontWeight.w400;
      case 'w500':
      case 'medium':
        return FontWeight.w500;
      case 'w600':
      case 'semibold':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
      case 'extrabold':
        return FontWeight.w800;
      case 'w900':
      case 'black':
        return FontWeight.w900;
      default:
        return null;
    }
  }
}
