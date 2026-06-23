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
  final EdgeInsetsGeometry? padding;
  final double radius;

  const CofluiButton({
    super.key,
    this.onPressed,
    this.label,
    this.child,
    this.variant = CofluiButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.padding,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final palette = _Palette.of(variant, cs);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    final content = child ?? _content(palette.foreground);
    final baseStyle = ButtonStyle(
      padding: WidgetStatePropertyAll(padding),
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
          onPressed: onPressed,
          style: baseStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll(cs.primary),
            foregroundColor: WidgetStatePropertyAll(cs.onPrimary),
          ),
          child: content,
        ),
      CofluiButtonVariant.danger => FilledButton(
          onPressed: onPressed,
          style: baseStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll(CofluiColors.error),
            foregroundColor: WidgetStatePropertyAll(CofluiColors.onError),
          ),
          child: content,
        ),
      CofluiButtonVariant.outline => OutlinedButton(
          onPressed: onPressed,
          style: baseStyle.copyWith(
            foregroundColor: WidgetStatePropertyAll(cs.primary),
            side: WidgetStatePropertyAll(
              BorderSide(color: cs.primary, width: 1.2),
            ),
          ),
          child: content,
        ),
      CofluiButtonVariant.ghost => TextButton(
          onPressed: onPressed,
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

  Widget _content(Color foreground) {
    final text = label ?? '';
    if (icon == null) {
      return Text(
        text,
        style: TextStyle(
          fontSize: CofluiTypography.itemTitle,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: foreground),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: CofluiTypography.itemTitle,
            fontWeight: FontWeight.w600,
            color: foreground,
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
