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
  static Color primary = const Color(0xFF596AA9);
  static Color onPrimary = const Color(0xFFFFFFFF);
  static Color secondary = const Color(0xFF0074D9);

  static Color puraYellow = const Color(0xFFF2C806);
  static Color puraOrange = const Color(0xFFFEA72C);
  static Color puraGreen = const Color(0xFF8EC302);
  static Color puraTeal = const Color(0xFF37CCCC);
  static Color puraPurple = const Color(0xFF6A35AE);
  static Color puraPink = const Color(0xFFB01669);

  // Surfaces
  static Color surface = const Color(0xFFFFFFFF);
  static Color onSurface = const Color(0xFF1A1A1A);
  static Color onSurfaceVariant = const Color(0xFF666666);
  static Color background = const Color(0xFFFFFFFF);
  static Color border = const Color(0xFFECF0F1);
  static Color divider = const Color(0xFFE0E0E0);
  static Color inputBorder = const Color(0xFFD8DBE3);

  // Feedback
  static Color error = const Color(0xFFC0392B);
  static Color onError = const Color(0xFFFFFFFF);
  static Color warning = const Color(0xFFF39C12);
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
