import 'package:coflui/src/dynamic/models/ui_style.dart';
import 'package:flutter/material.dart';

/// Mengkonversi [UIStyle] (dataclass netral) ke objek Flutter siap pakai.
///
/// Semua ukuran dimensi adalah **logical pixel mentah** (tidak di-scale).
/// Package tetap dependency-free — responsivitas ditangani di level layout.
class StyleResolver {
  const StyleResolver._();

  static EdgeInsets padding(UIStyle s) {
    final all = s.padding;
    final vx = s.paddingHorizontal ?? all;
    final vy = s.paddingVertical ?? all;
    return EdgeInsets.symmetric(
      horizontal: vx ?? 0,
      vertical: vy ?? 0,
    );
  }

  static double radius(UIStyle s, [double fallback = 0]) => s.radius ?? fallback;

  static Alignment align(UIStyle s, [Alignment fallback = Alignment.centerLeft]) {
    switch ((s.align ?? '').toLowerCase()) {
      case 'left':
      case 'start':
        return Alignment.centerLeft;
      case 'right':
      case 'end':
        return Alignment.centerRight;
      case 'center':
        return Alignment.center;
      case 'justify':
        return Alignment.centerLeft;
      default:
        return fallback;
    }
  }

  static TextAlign textAlign(UIStyle s, [TextAlign fallback = TextAlign.start]) {
    switch ((s.align ?? '').toLowerCase()) {
      case 'left':
      case 'start':
        return TextAlign.start;
      case 'right':
      case 'end':
        return TextAlign.end;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      default:
        return fallback;
    }
  }

  static CrossAxisAlignment crossAxis(UIStyle s,
      [CrossAxisAlignment fallback = CrossAxisAlignment.stretch]) {
    switch ((s.crossAxis ?? '').toLowerCase()) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'center':
        return CrossAxisAlignment.center;
      case 'end':
        return CrossAxisAlignment.end;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      default:
        return fallback;
    }
  }

  static MainAxisAlignment mainAxis(UIStyle s,
      [MainAxisAlignment fallback = MainAxisAlignment.start]) {
    switch ((s.mainAxis ?? '').toLowerCase()) {
      case 'start':
        return MainAxisAlignment.start;
      case 'center':
        return MainAxisAlignment.center;
      case 'end':
        return MainAxisAlignment.end;
      case 'spacebetween':
      case 'space_between':
        return MainAxisAlignment.spaceBetween;
      case 'spacearound':
      case 'space_around':
        return MainAxisAlignment.spaceAround;
      case 'spaceevenly':
      case 'space_evenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return fallback;
    }
  }

  static TextStyle textStyle(UIStyle s, BuildContext ctx, {TextStyle? base}) {
    final theme = Theme.of(ctx);
    return (base ?? theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: s.fontSize,
      fontWeight: s.fontWeight,
      fontStyle: (s.fontStyle ?? '').toLowerCase() == 'italic'
          ? FontStyle.italic
          : null,
      color: s.color,
    );
  }

  static BoxDecoration? box(UIStyle s) {
    final hasBorder = s.borderColor != null && (s.borderWidth ?? 0) > 0;
    if (s.bgColor == null && !hasBorder && s.radius == null) return null;
    return BoxDecoration(
      color: s.bgColor,
      borderRadius: BorderRadius.circular(radius(s, 0)),
      border: hasBorder
          ? Border.all(color: s.borderColor!, width: s.borderWidth ?? 1)
          : null,
    );
  }
}
