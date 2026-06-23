import 'package:flutter/material.dart';

/// Coflui type scale (logical pixels, NOT screenutil-scaled).
///
/// Values are raw doubles so the package stays dependency-free and predictable
/// across devices. Responsive behavior is handled at the *layout* level
/// (breakpoints, grids, max-width) rather than by stretching element sizes.
class CofluiTypography {
  CofluiTypography._();

  static const double heroNumber = 42.0;
  static const double display = 28.0;
  static const double sectionTitle = 20.0;
  static const double cardTitle = 18.0;
  static const double itemTitle = 16.0;

  static const double body = 14.0;
  static const FontWeight bodyWeight = FontWeight.normal;

  static const double caption = 12.0;
  static const FontWeight captionWeight = FontWeight.normal;

  static const double badge = 10.0;
  static const double detail = 11.0;

  /// Default text style for body copy.
  static const TextStyle bodyStyle = TextStyle(
    fontSize: body,
    fontWeight: bodyWeight,
  );

  /// Default text style for section titles.
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: sectionTitle,
    fontWeight: FontWeight.bold,
  );
}
