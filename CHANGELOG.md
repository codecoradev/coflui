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
