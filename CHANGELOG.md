## 0.3.0

Full-page dynamic detail pages — `chip` + `list` components.

### Added
- **`CofluiChip`** — status pill / badge (5 variants: success/warning/danger/info/neutral), optional icon.
- **`list` component** — repeat a child template over an `items[]` array with
  `{field}` placeholder interpolation. The key enabler for full-page dynamic
  layouts (approvers, attachments, line items, timelines). Supports
  `direction` (vertical/horizontal/wrap), `spacing`, and `emptyText`.
- **`interpolateComponent()`** — exported helper that substitutes `{key}`
  placeholders in a `UIComponent` tree from a data map.
- **`chip` + `list` UIType** values + builder registration.
- **Example: full detail page** — `detail_page_screen.dart` renders a complete
  approval-detail document from JSON (`buildDetailJson` + `dummyApproval`).
  Clone-ready pattern: swap the data map → whole page re-renders.
- 8 new tests (chip variants, list repeat, field binding, empty state).

### Changed
- `Milestone 4` in ROADMAP → ✅ complete.

## 0.2.0

Reusable component extraction + icon system + dynamic-UI integration.

### Added
- **`CofluiIcon`** — universal icon/image widget that auto-detects its
  source: `IconData` → Material icon, `.svg` → flutter_svg, `.png`/`.jpg` →
  asset, `https://…` → `CachedNetworkImage` (disk-cached). One widget
  replaces the scattered `Image.asset` / `Image.network` / `Icon` mix.
- **`CofluiGradients`** + **`CofluiGradientBar`** — brand gradient presets
  (`accent` / `cool` / `warm`) built on overridable `CofluiColors` tokens.
- **`CofluiAppBar`** — standard app bar with optional gradient background.
- **`CofluiScaffold`** — SafeArea-wrapped scaffold helper.
- **`CofluiListTile`** — card-style list row (leading / title / subtitle /
  trailing / onTap).
- **`CofluiDetailRow`** — labeled icon+label+value row for detail views.
- **`CofluiColors`** — new `accent*` token set (yellow, orange, green, teal,
  purple, pink, blue + gradient intermediates). All overridable at boot.
- **Dynamic-UI types**: `icon`, `image`, `gradient_bar`, `list_tile`,
  `detail_row` — now callable from JSON via the engine.
- **`IconResolver`** — maps Material icon names / code-points to `IconData`.
- `flutter_svg` + `cached_network_image` dependencies.
- 28 new tests (auto-detection, new widgets, dynamic builders).

### Changed
- `CofluiButton` now supports `isLoading` (spinner + disabled).
- `CofluiTextField` now supports `label`, `prefixIcon`, `suffixIcon`,
  `validator`, `onFieldSubmitted`, plus error/focused-error borders.
- `CofluiColors.pura*` renamed → `accent*` (old names kept as
  `@Deprecated` aliases for one release).

## 0.1.0

Initial extraction — standalone dynamic UI engine + native widget set.

### Added
- Package scaffold (`pubspec.yaml`, `lib/coflui.dart` barrel, analysis).
- Theme layer: `CofluiColors`, `CofluiTypography`, `CofluiBreakpoints`.
- Native widget standards: `CofluiText`, `CofluiButton`, `CofluiTextField`,
  `CofluiDropdown`, `CofluiCard`, `CofluiDialog`, `CofluiGrid`,
  `CofluiResponsive`.
- Dynamic UI engine on `ChangeNotifier` + `ValueNotifier` (state-agnostic):
  `UIComponent`, `UIStyle`, `WidgetRegistry`, `StyleResolver`,
  `CofluiFormController`, `DynamicUIWidget`, default builders, bootstrap.
- Responsive `grid` component (breakpoint-driven column count).
- Docs: `README`, `doc/ARCHITECTURE`, `doc/ROADMAP`, `doc/DYNAMIC_UI`.

### Changed (vs e_pg in-tree engine)
- Removed GetX (`get`), `magic_view`, `micropack_core`, `flutter_screenutil`.
- State management → native `ChangeNotifier`.
- All `Magic*` widgets → native Flutter / `Coflui*` wrappers.
- Element sizing → raw logical pixels; responsiveness moved to layout layer.
