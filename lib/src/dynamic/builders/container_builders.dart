import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/models/ui_style.dart';
import 'package:coflui/src/dynamic/resolvers/style_resolver.dart';
import 'package:coflui/src/dynamic/widgets/dynamic_ui_widget.dart';
import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/widgets/coflui_card.dart';
import 'package:coflui/src/widgets/coflui_grid.dart';
import 'package:flutter/material.dart';

/// Builder untuk komponen container (column, row, grid, card, section).
///
/// Inilah yang membuat struktur bisa **bersarang tak terhingga**: setiap
/// container merender `children`-nya melalui [DynamicUIWidget] secara rekursif.
class ContainerBuilders {
  ContainerBuilders._();

  /// Builds a vertical [Column] from a JSON `column` component.
  ///
  /// Children are recursively rendered via [DynamicUIWidget]. The column
  /// defaults to `mainAxisSize.min` to avoid layout errors inside scroll
  /// views; override with `props.mainAxisSize: "max"`.
  static Widget column(BuildContext ctx, UIComponent c, controller) {
    final s = c.style;
    final children = c.children
        .map((child) => DynamicUIWidget(child, controller: controller))
        .toList();
    // Default min: di dalam scrollview constraint heightnya unbounded;
    // Column(mainAxisSize.max) di situ tidak bisa menentukan tingginya dan
    // menyebabkan cascade layout error (terutama bila child Row stretch).
    // Override via `props.mainAxisSize: "max"`.
    final mainAxisSize =
        c.props['mainAxisSize'] == 'max' ? MainAxisSize.max : MainAxisSize.min;
    Widget content = Column(
      mainAxisAlignment: StyleResolver.mainAxis(s),
      mainAxisSize: mainAxisSize,
      // Default stretch: card & input full-width (umum untuk layout form).
      crossAxisAlignment:
          StyleResolver.crossAxis(s, CrossAxisAlignment.stretch),
      spacing: s.gap ?? 0,
      children: children,
    );
    if (s.padding != null ||
        s.paddingHorizontal != null ||
        s.paddingVertical != null) {
      content = Padding(padding: StyleResolver.padding(s), child: content);
    }
    return _maybeExpand(content, s);
  }

  /// Builds a horizontal [Row] from a JSON `row` component.
  ///
  /// Each child is automatically wrapped in [Flexible] (or [Expanded] when
  /// `props.flex` is set) to prevent unbounded-width layout crashes.
  static Widget row(BuildContext ctx, UIComponent c, controller) {
    final s = c.style;
    // Penting: child Row secara default mendapat constraint width TIDAK
    // terbatas (unbounded). Container seperti card/column yang memakai
    // `crossAxisAlignment: stretch` akan meledak (infinite width). Maka
    // setiap child dibungkus Flexible/Expanded supaya selalu dapat lebar
    // terbatas (bounded).
    //   - `props.flex` (int > 0) → Expanded (mengisi porsi persis).
    //   - tanpa flex            → Flexible loose (konten-sized, bounded).
    final children = c.children.map((child) {
      final flex = child.props['flex'];
      final inner = DynamicUIWidget(child, controller: controller);
      if (flex is int && flex > 0) {
        return Expanded(flex: flex, child: inner);
      }
      return Flexible(fit: FlexFit.loose, flex: 1, child: inner);
    }).toList();
    // Row's cross-axis = VERTIKAL (tinggi). Bila tinggi incoming tidak
    // terbatas (mis. Row di dalam Column(min) di dalam scrollview) DAN
    // crossAxisAlignment stretch, Row akan memberi child height = infinity
    // → crash. Guard: downgrade stretch → center otomatis saat tinggi unbounded.
    final requestedCross = StyleResolver.crossAxis(s, CrossAxisAlignment.center);
    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final cross =
            (!constraints.maxHeight.isFinite &&
                    requestedCross == CrossAxisAlignment.stretch)
                ? CrossAxisAlignment.center
                : requestedCross;
        return Row(
          mainAxisAlignment:
              StyleResolver.mainAxis(s, MainAxisAlignment.start),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: cross,
          spacing: s.gap ?? 8,
          children: children,
        );
      },
    );
    if (s.padding != null ||
        s.paddingHorizontal != null ||
        s.paddingVertical != null) {
      content = Padding(padding: StyleResolver.padding(s), child: content);
    }
    return _maybeExpand(content, s);
  }

  /// Responsive grid. Column count di-derive murni dari breakpoint
  /// ([CofluiGrid]). Props opsional:
  ///   - `mobileColumns`, `tabletColumns`, `desktopColumns` (int)
  ///   - `spacing`, `runSpacing` (double)
  static Widget grid(BuildContext ctx, UIComponent c, controller) {
    final s = c.style;
    final children = c.children
        .map((child) => DynamicUIWidget(child, controller: controller))
        .toList();
    return CofluiGrid(
      spacing: (c.props['spacing'] is num
          ? (c.props['spacing'] as num).toDouble()
          : s.gap ?? 12),
      runSpacing: (c.props['runSpacing'] is num
          ? (c.props['runSpacing'] as num).toDouble()
          : s.gap ?? 12),
      mobileColumns: c.props['mobileColumns'] as int? ?? 1,
      tabletColumns: c.props['tabletColumns'] as int? ?? 2,
      desktopColumns: c.props['desktopColumns'] as int? ?? 3,
      children: children,
    );
  }

  /// Builds a styled [CofluiCard] from a JSON `card` or `section` component.
  /// The `label` field becomes the card title; children are stacked in a
  /// column inside the card body.
  static Widget card(BuildContext ctx, UIComponent c, controller) {
    final s = c.style;
    final children = c.children
        .map((child) => DynamicUIWidget(child, controller: controller))
        .toList();
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: s.gap ?? 10,
      children: children,
    );

    return CofluiCard(
      title: c.label?.isNotEmpty == true ? c.label : null,
      titleGap: s.gap ?? 10,
      padding: StyleResolver.padding(const UIStyle(padding: 14)).copyWith(
        left: s.paddingHorizontal ?? 14,
        right: s.paddingHorizontal ?? 14,
        top: s.paddingVertical ?? 14,
        bottom: s.paddingVertical ?? 14,
      ),
      radius: StyleResolver.radius(s, 14),
      color: s.bgColor ?? CofluiColors.surface,
      borderColor: s.borderColor ?? const Color(0xFFEDEFF3),
      borderWidth: s.borderWidth ?? 1,
      elevation: s.elevation ?? 6,
      child: content,
    );
  }

  /// Section = card dengan label besar + divider, dipakai untuk grouping
  /// beberapa form. Mirip `card` tapi lebih bold.
  static Widget section(BuildContext ctx, UIComponent c, controller) =>
      card(ctx, c, controller);

  static Widget _maybeExpand(Widget child, UIStyle s) {
    if (s.expand == true) return Expanded(child: child);
    return child;
  }
}
