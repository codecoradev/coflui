import 'package:flutter/material.dart';

import '../theme/coflui_colors.dart';

/// Brand gradient presets built on [CofluiColors] accent tokens.
///
/// Because these are **getters** (not `const`), they always read the *current*
/// [CofluiColors] values. So overriding tokens at boot also updates gradients:
///
/// ```dart
/// void main() {
///   CofluiColors.accentOrange = const Color(0xFFFF6B6B);
///   CofluiGradients.accent; // now uses the overridden orange
///   runApp(MyApp());
/// }
/// ```
///
/// Provided presets (default look = Pura Group signature 135° Orange → Blue):
///   - [accent] — signature diagonal gradient (warm → cool)
///   - [cool]   — cyan → blue (for headers / app bars)
///   - [warm]   — orange → yellow (sunny accents)
class CofluiGradients {
  CofluiGradients._();

  /// Signature diagonal gradient (pale-orange → orange → mid → blue).
  /// 135°, 4-stop. Used by [CofluiGradientBar] and brand accents.
  static Gradient get accent => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight, // 135°
        colors: [
          CofluiColors.accentOrangePale,
          CofluiColors.accentOrange,
          CofluiColors.accentMidWarm,
          CofluiColors.accentBlue,
        ],
        stops: const [0.0, 0.25, 0.55, 1.0],
      );

  /// Cool gradient (pale-cyan → teal → blue). Good for headers & app bars.
  static Gradient get cool => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          CofluiColors.accentCyanPale,
          CofluiColors.accentTeal,
          CofluiColors.accentBlue,
        ],
        stops: const [0.0, 0.4, 1.0],
      );

  /// Warm gradient (pale-orange → orange → yellow).
  static Gradient get warm => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          CofluiColors.accentOrangePale,
          CofluiColors.accentOrange,
          CofluiColors.accentYellow,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  /// Builds a [BoxDecoration] from a named gradient preset.
  ///
  /// [preset] can be `'accent'` (default), `'cool'`, or `'warm'`.
  static BoxDecoration box({
    String preset = 'accent',
    double radius = 0,
    BorderRadius? borderRadius,
    Border? border,
  }) =>
      BoxDecoration(
        gradient: presetOf(preset),
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        border: border,
      );

  /// Resolves a gradient preset by name.
  static Gradient presetOf(String name) {
    switch (name.toLowerCase()) {
      case 'cool':
      case 'cyan':
        return cool;
      case 'warm':
      case 'orange':
        return warm;
      case 'accent':
      case 'signature':
      default:
        return accent;
    }
  }
}

/// A thin horizontal bar painted with the signature [CofluiGradients.accent]
/// gradient. Commonly placed under an app bar or at the top of a card as a
/// brand accent.
class CofluiGradientBar extends StatelessWidget {
  /// Gradient preset name: `'accent'` (default), `'cool'`, or `'warm'`.
  final String gradient;

  /// Bar height in logical pixels.
  final double height;

  /// Optional corner radius.
  final BorderRadius? borderRadius;

  const CofluiGradientBar({
    super.key,
    this.gradient = 'accent',
    this.height = 6,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: CofluiGradients.presetOf(gradient),
      ),
    );
  }
}
