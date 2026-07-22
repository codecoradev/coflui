import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A universal icon / image widget that auto-detects its source type.
///
/// Pass any of these as the [source] and CofluiIcon picks the right renderer:
///
/// | Input                         | Detected as   | Renderer               |
/// |-------------------------------|---------------|------------------------|
/// | [IconData]                    | Material icon | [Icon]                 |
/// | `'https://…'` / `'http://…'` | network image | [CachedNetworkImage]   |
/// | `'assets/x.svg'`              | SVG asset     | [SvgPicture.asset]     |
/// | `'assets/x.png'` (any raster) | raster asset  | [Image.asset]          |
///
/// This is the single entry point for every icon / image across the package.
/// It replaces the scattered mix of `Image.asset`, `Image.network`,
/// `CachedNetworkImage`, and `Icon` calls found in legacy code.
///
/// ```dart
/// CofluiIcon(Icons.home)                    // material icon
/// CofluiIcon('assets/svg/logo.svg')         // svg asset (colorable)
/// CofluiIcon('assets/images/avatar.png')    // raster asset
/// CofluiIcon('https://example.com/a.png')   // network (disk-cached)
/// ```
///
/// For SVG/network the optional [color] is applied as a tint/blend so icons
/// can be themed. [placeholder] and [errorWidget] customize the loading /
/// failure states of network images.
class CofluiIcon extends StatelessWidget {
  /// Creates an auto-detecting icon.
  ///
  /// [source] must be an [IconData] or a non-empty [String].
  const CofluiIcon(
    this.source, {
    super.key,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  }) : assert(source is IconData || source is String, _sourceAssertion);

  /// Material icon data — rendered via [Icon].
  const CofluiIcon.icon(
    IconData icon, {
    super.key,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  })  : source = icon,
        assert(true, _sourceAssertion);

  /// Raster or SVG asset path — type inferred from the file extension.
  const CofluiIcon.asset(
    String path, {
    super.key,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  })  : source = path,
        assert(true, _sourceAssertion);

  /// Network image URL — rendered via [CachedNetworkImage] (disk-cached).
  const CofluiIcon.url(
    String url, {
    super.key,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  })  : source = url,
        assert(true, _sourceAssertion);

  static const _sourceAssertion =
      'CofluiIcon source must be an IconData or a String';

  /// The icon data or a path/URL string.
  final Object source;

  /// Logical-pixel size (applied to both width & height).
  final double size;

  /// Tint / blend color. Applied to icons, SVGs, and raster assets.
  final Color? color;

  /// How to inscribe the image into the [size]×[size] box.
  final BoxFit fit;

  /// Widget shown while a network image loads. Defaults to a subtle spinner.
  final Widget? placeholder;

  /// Widget shown when a network image fails to load. Defaults to a broken-icon.
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    // ── Material icon ──────────────────────────────────────────────
    if (source is IconData) {
      return Icon(
        source as IconData,
        size: size,
        color: color,
      );
    }

    final s = source as String;
    final w = size;
    final h = size;

    // ── Network image (disk-cached) ────────────────────────────────
    if (_isNetworkUrl(s)) {
      return CachedNetworkImage(
        imageUrl: s,
        width: w,
        height: h,
        fit: fit,
        color: color,
        colorBlendMode: color != null ? BlendMode.srcIn : null,
        placeholder: (_, __) => placeholder ?? _defaultPlaceholder(),
        errorWidget: (_, __, ___) => errorWidget ?? _defaultError(),
      );
    }

    // ── SVG asset ──────────────────────────────────────────────────
    if (_isSvg(s)) {
      return SvgPicture.asset(
        s,
        width: w,
        height: h,
        fit: fit,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        placeholderBuilder: placeholder != null ? (_) => placeholder! : null,
      );
    }

    // ── Raster asset ───────────────────────────────────────────────
    // Guard: only attempt asset load when the string looks like a path
    // (has a file extension or a path separator). Bare words like "Approved"
    // or "—" would otherwise trigger a doomed Image.asset fetch → 404 noise.
    if (!_looksLikePath(s)) {
      return errorWidget ?? _defaultError();
    }
    return Image.asset(
      s,
      width: w,
      height: h,
      fit: fit,
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,
      errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
    );
  }

  /// `http(s)://` URL detector.
  static bool _isNetworkUrl(String s) =>
      s.startsWith('http://') || s.startsWith('https://');

  /// `.svg` extension detector (case-insensitive).
  static bool _isSvg(String s) => s.toLowerCase().endsWith('.svg');

  /// Heuristic: does [s] look like an asset path or URL? A real path has a
  /// file extension or a path separator. Bare words ("Approved", "—") don't.
  static bool _looksLikePath(String s) =>
      s.contains('/') || RegExp(r'\.[a-zA-Z0-9]{2,5}$').hasMatch(s);

  Widget _defaultPlaceholder() => SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );

  Widget _defaultError() => SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.broken_image_outlined, size: size * 0.7),
      );
}

/// Extension that lets any [Object] (IconData / String) be turned into a
/// [CofluiIcon] ergonomically — useful for dynamic-UI prop parsing.
extension CofluiIconSource on Object {
  /// Wrap this value in a [CofluiIcon].
  CofluiIcon toCofluiIcon({
    double size = 24,
    Color? color,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
  }) =>
      CofluiIcon(
        this,
        size: size,
        color: color,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );
}
