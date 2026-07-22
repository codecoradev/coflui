import 'package:flutter/material.dart';

/// A standard app bar with centered title, optional back button, and
/// optional gradient background.
///
/// A coflui-fied version of a typical `AppBar`:
///   - centered title
///   - optional back button ([showBack])
///   - optional [gradient] background preset (`'accent'` / `'cool'` / `'warm'`)
///   - transparent-aware foreground color
///
/// Works as a [PreferredSizeWidget] so it drops straight into [Scaffold.appBar].
class CofluiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// Action widgets shown on the trailing side.
  final List<Widget>? actions;

  /// Show the back button. Defaults to `true`.
  final bool showBack;

  /// Background color. Use [Colors.transparent] for overlays.
  final Color? backgroundColor;

  /// Title / icon color. Falls back to white when transparent.
  final Color? foregroundColor;

  /// Gradient preset name (`'accent'` / `'cool'` / `'warm'`).
  /// When set, takes precedence over [backgroundColor].
  final String? gradient;

  const CofluiAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.backgroundColor,
    this.foregroundColor,
    this.gradient,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isTransparent = backgroundColor == Colors.transparent;
    final fg = foregroundColor ?? (isTransparent ? Colors.white : null);

    AppBar bar(BuildContext ctx, {Widget? leading, Color? bg, Gradient? grad}) =>
        AppBar(
          title: Text(title, style: TextStyle(color: fg)),
          centerTitle: true,
          leading: leading,
          actions: actions,
          backgroundColor: bg,
          foregroundColor: fg,
          flexibleSpace: grad != null
              ? Container(decoration: BoxDecoration(gradient: grad))
              : null,
          surfaceTintColor:
              isTransparent ? Colors.transparent : null,
          scrolledUnderElevation: 0,
        );

    // Gradient variant.
    if (gradient != null) {
      final grad = _gradientOf(gradient!);
      return bar(
        context,
        leading: _backButton(context, fg),
        bg: Colors.transparent,
        grad: grad,
      );
    }

    return bar(
      context,
      leading: showBack ? _backButton(context, fg) : null,
      bg: backgroundColor,
    );
  }

  Widget _backButton(BuildContext context, Color? color) => IconButton(
        icon: Icon(Icons.arrow_back_ios_new, size: 20, color: color),
        onPressed: () => Navigator.of(context).maybePop(),
      );

  Gradient _gradientOf(String name) {
    // Local import-free resolution to avoid pulling gradients into the
    // preferred-size hot path when unused.
    switch (name.toLowerCase()) {
      case 'cool':
      case 'cyan':
        return _constCool;
      case 'warm':
      case 'orange':
        return _constWarm;
      default:
        return _constAccent;
    }
  }
}

// ── Const gradient fallbacks ──────────────────────────────────────────────
// CofluiGradients uses getters (to honor runtime overrides), but an app bar
// is constructed frequently. These const snapshots keep the zero-config look
// without a per-build allocation when callers pass a preset name.
// For full rebrand fidelity, import CofluiGradients and pass a Gradient via a
// custom flexibleSpace instead.

const _constAccent = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFEDFA8), Color(0xFFFEA72C), Color(0xFFC1965C), Color(0xFF088ECE)],
  stops: [0.0, 0.25, 0.55, 1.0],
);

const _constCool = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFB5EDED), Color(0xFF37CCCC), Color(0xFF088ECE)],
  stops: [0.0, 0.4, 1.0],
);

const _constWarm = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFEDFA8), Color(0xFFFEA72C), Color(0xFFF2C806)],
  stops: [0.0, 0.5, 1.0],
);
