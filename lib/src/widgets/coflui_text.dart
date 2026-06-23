import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:flutter/material.dart';

/// A thin, sensible-default wrapper around [Text].
///
/// This is the single text widget used both by the dynamic UI renderer and by
/// hand-written (non-dynamic) code — one standard everywhere.
///
/// If [style] is omitted, body defaults from [CofluiTypography] /
/// [CofluiColors] are applied. Pass an explicit [style] to override fully.
class CofluiText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextScaler? textScaler;

  const CofluiText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaler,
  });

  @override
  Widget build(BuildContext context) {
    final effective =
        style ??
        TextStyle(
          fontSize: CofluiTypography.body,
          color: CofluiColors.onSurfaceVariant,
        );
    return Text(
      data,
      style: effective,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: maxLines != null ? (overflow ?? TextOverflow.ellipsis) : overflow,
      softWrap: softWrap,
      textScaler: textScaler,
    );
  }
}
