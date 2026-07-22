import 'package:flutter/material.dart';

/// Coflui color palette.
///
/// Defaults mirror the e_pg design system so the package looks correct with
/// zero configuration. Every value is overridable at app boot so any project
/// can adopt its own brand without forking the package.
///
/// ```dart
/// void main() {
///   CofluiColors.primary = const Color(0xFF123456);
///   runApp(MyApp());
/// }
/// ```
class CofluiColors {
  CofluiColors._();

  // Brand

  /// Primary brand color used for buttons, active states, and key accents.
  static Color primary = const Color(0xFF596AA9);

  /// Text/icon color rendered on top of [primary].
  static Color onPrimary = const Color(0xFFFFFFFF);

  /// Secondary brand color for less prominent accents.
  static Color secondary = const Color(0xFF0074D9);

  // Accent palette (overridable brand accents)

  /// Yellow accent. Override at boot to rebrand.
  static Color accentYellow = const Color(0xFFF2C806);

  /// Orange accent. Override at boot to rebrand.
  static Color accentOrange = const Color(0xFFFEA72C);

  /// Green accent. Override at boot to rebrand.
  static Color accentGreen = const Color(0xFF8EC302);

  /// Teal accent. Override at boot to rebrand.
  static Color accentTeal = const Color(0xFF37CCCC);

  /// Purple accent. Override at boot to rebrand.
  static Color accentPurple = const Color(0xFF6A35AE);

  /// Pink accent. Override at boot to rebrand.
  static Color accentPink = const Color(0xFFB01669);

  /// Blue accent (cool end of the signature gradient).
  static Color accentBlue = const Color(0xFF088ECE);

  // Gradient intermediates (tints used by [CofluiGradients])

  /// Pale tint of [accentOrange] (gradient start).
  static Color accentOrangePale = const Color(0xFFFEDFA8);

  /// Mid warm tone between orange and blue (gradient mid-stop).
  static Color accentMidWarm = const Color(0xFFC1965C);

  /// Pale tint of [accentTeal] (cool gradient start).
  static Color accentCyanPale = const Color(0xFFB5EDED);

  // ── Deprecated aliases (kept for backward-compat, will be removed) ──
  /// Deprecated — use [accentYellow].
  @Deprecated('Use CofluiColors.accentYellow')
  static Color puraYellow = const Color(0xFFF2C806);

  /// Deprecated — use [accentOrange].
  @Deprecated('Use CofluiColors.accentOrange')
  static Color puraOrange = const Color(0xFFFEA72C);

  /// Deprecated — use [accentGreen].
  @Deprecated('Use CofluiColors.accentGreen')
  static Color puraGreen = const Color(0xFF8EC302);

  /// Deprecated — use [accentTeal].
  @Deprecated('Use CofluiColors.accentTeal')
  static Color puraTeal = const Color(0xFF37CCCC);

  /// Deprecated — use [accentPurple].
  @Deprecated('Use CofluiColors.accentPurple')
  static Color puraPurple = const Color(0xFF6A35AE);

  /// Deprecated — use [accentPink].
  @Deprecated('Use CofluiColors.accentPink')
  static Color puraPink = const Color(0xFFB01669);

  // Surfaces

  /// Background color for cards, sheets, and elevated surfaces.
  static Color surface = const Color(0xFFFFFFFF);

  /// Primary text color rendered on top of [surface].
  static Color onSurface = const Color(0xFF1A1A1A);

  /// Secondary / muted text color for captions, hints, and labels.
  static Color onSurfaceVariant = const Color(0xFF666666);

  /// App-wide background color behind all content.
  static Color background = const Color(0xFFFFFFFF);

  /// Default border color for subtle separators.
  static Color border = const Color(0xFFECF0F1);

  /// Divider line color.
  static Color divider = const Color(0xFFE0E0E0);

  /// Border color for input fields (text fields, dropdowns).
  static Color inputBorder = const Color(0xFFD8DBE3);

  // Feedback

  /// Error / destructive action color.
  static Color error = const Color(0xFFC0392B);

  /// Text/icon color rendered on top of [error].
  static Color onError = const Color(0xFFFFFFFF);

  /// Warning banner / indicator color.
  static Color warning = const Color(0xFFF39C12);

  /// Color for disabled / inactive elements.
  static Color disabled = const Color(0xFF95A5A6);

  /// Material [ColorScheme] synthesized from the current palette.
  /// Projects that already provide a ThemeData can ignore this; it exists so
  /// Coflui widgets have sensible colors even without a configured theme.
  static ColorScheme get colorScheme => ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onError,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onError,
      );
}
