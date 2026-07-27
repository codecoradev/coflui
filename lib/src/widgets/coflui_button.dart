import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:flutter/material.dart';

/// Visual style of a [CofluiButton].
enum CofluiButtonVariant { primary, outline, danger, ghost }

/// A thin, variant-aware wrapper over Flutter's native button widgets.
///
/// One standard button used by both the dynamic renderer and hand-written UI.
/// Maps cleanly to Material buttons so it integrates with any theme:
///   - [CofluiButtonVariant.primary] → [FilledButton]
///   - [CofluiButtonVariant.outline] → [OutlinedButton]
///   - [CofluiButtonVariant.danger]  → [FilledButton] (error color)
///   - [CofluiButtonVariant.ghost]   → [TextButton]
class CofluiButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final CofluiButtonVariant variant;
  final IconData? icon;
  final bool fullWidth;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double radius;

  /// Override the button's background color (takes precedence over variant).
  final Color? backgroundColor;

  /// Override the text/icon color (takes precedence over variant).
  final Color? foregroundColor;

  /// Stroke color for the outline variant.
  final Color? borderColor;

  /// Stroke width for the outline variant. Defaults to 1.2.
  final double borderWidth;

  /// Material elevation (shadow). Defaults to 0 (flat Material 3 look).
  final double elevation;

  /// Minimum width — useful for icon-only or compact buttons.
  final double? minWidth;

  /// Fixed height. Defaults to Material's standard (~40-48).
  final double? fixedHeight;

  const CofluiButton({
    super.key,
    this.onPressed,
    this.label,
    this.child,
    this.variant = CofluiButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
    this.padding,
    this.radius = 10,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.elevation = 0,
    this.minWidth,
    this.fixedHeight,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final palette = _Palette.of(variant, cs);
    // Custom color overrides take precedence over variant palette.
    final effectiveBackground = backgroundColor ?? palette.background;
    final effectiveForeground = foregroundColor ?? palette.foreground;
    final effectiveStroke = borderColor ?? palette.stroke;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    // Loading state: disable press + swap content for a spinner.
    final effectiveOnPressed = isLoading ? null : onPressed;
    final content = isLoading
        ? _spinner(effectiveForeground)
        : (child ?? _content(effectiveForeground));
    final baseStyle = ButtonStyle(
      padding: WidgetStatePropertyAll(padding),
      minimumSize: WidgetStatePropertyAll(Size(
        minWidth ?? 0,
        fixedHeight ?? 0,
      )),
      elevation: WidgetStatePropertyAll(elevation),
      shape: WidgetStatePropertyAll(shape),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontSize: CofluiTypography.itemTitle,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    final btn = switch (variant) {
      CofluiButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          style: baseStyle.copyWith(
            backgroundColor:
                WidgetStatePropertyAll(effectiveBackground ?? cs.primary),
            foregroundColor: WidgetStatePropertyAll(effectiveForeground),
          ),
          child: content,
        ),
      CofluiButtonVariant.danger => FilledButton(
          onPressed: effectiveOnPressed,
          style: baseStyle.copyWith(
            backgroundColor:
                WidgetStatePropertyAll(effectiveBackground ?? CofluiColors.error),
            foregroundColor:
                WidgetStatePropertyAll(effectiveForeground),
          ),
          child: content,
        ),
      CofluiButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: baseStyle.copyWith(
            backgroundColor:
                WidgetStatePropertyAll(effectiveBackground),
            foregroundColor: WidgetStatePropertyAll(effectiveForeground),
            side: WidgetStatePropertyAll(
              BorderSide(
                color: effectiveStroke ?? cs.primary,
                width: borderWidth,
              ),
            ),
          ),
          child: content,
        ),
      CofluiButtonVariant.ghost => TextButton(
          onPressed: effectiveOnPressed,
          style: baseStyle.copyWith(
            foregroundColor: WidgetStatePropertyAll(cs.primary),
          ),
          child: content,
        ),
    };

    if (!fullWidth) return btn;
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth.isFinite
          ? SizedBox(width: constraints.maxWidth, child: btn)
          : btn,
    );
  }

  Widget _spinner(Color foreground) => SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: foreground,
        ),
      );

  Widget _content(Color foreground) {
    final text = label ?? '';
    final style = TextStyle(
      fontSize: CofluiTypography.itemTitle,
      fontWeight: FontWeight.w600,
      color: foreground,
    );
    // Label di-bungkus Flexible + ellipsis supaya tombol yang sempit tidak
    // pernah meluber (RenderFlex overflow). Ikon tetap ukuran tetap; teks
    // yang menyusut/memotong dengan graceful ellipsis ("Kirim Pengu…").
    if (icon == null) {
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: foreground),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class _Palette {
  final Color? background;
  final Color foreground;
  final Color? stroke;

  const _Palette({this.background, required this.foreground, this.stroke});

  factory _Palette.of(CofluiButtonVariant v, ColorScheme cs) {
    switch (v) {
      case CofluiButtonVariant.outline:
        return _Palette(
          background: CofluiColors.surface,
          foreground: cs.primary,
          stroke: cs.primary,
        );
      case CofluiButtonVariant.danger:
        return _Palette(
          background: CofluiColors.error,
          foreground: CofluiColors.onError,
        );
      case CofluiButtonVariant.ghost:
        return _Palette(foreground: cs.primary);
      case CofluiButtonVariant.primary:
        return _Palette(background: cs.primary, foreground: cs.onPrimary);
    }
  }
}
