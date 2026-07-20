import 'package:flutter/material.dart';

/// Coflui type scale (logical pixels, NOT screenutil-scaled).
///
/// Values are raw doubles so the package stays dependency-free and predictable
/// across devices. Responsive behavior is handled at the *layout* level
/// (breakpoints, grids, max-width) rather than by stretching element sizes.
class CofluiTypography {
  CofluiTypography._();

  /// Extra-large display size for hero numbers (stats, big counters).
  static const double heroNumber = 42.0;

  /// Large display size for page-level hero text.
  static const double display = 28.0;

  /// Section / page title size.
  static const double sectionTitle = 20.0;

  /// Card title size.
  static const double cardTitle = 18.0;

  /// Item / list-tile title size.
  static const double itemTitle = 16.0;

  /// Body text size — the default for most content.
  static const double body = 14.0;

  /// Default font weight for body text.
  static const FontWeight bodyWeight = FontWeight.normal;

  /// Caption / secondary label size.
  static const double caption = 12.0;

  /// Default font weight for caption text.
  static const FontWeight captionWeight = FontWeight.normal;

  /// Badge text size (very small labels).
  static const double badge = 10.0;

  /// Detail / micro text size (timestamps, metadata).
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
