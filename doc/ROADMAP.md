# Roadmap

Living document. Each milestone is tracked as a GitHub issue set labeled by
phase. ✅ = done in the initial extraction, 🚧 = in progress / next, ⬜ planned.

## Milestone 1 — Standalone package foundation ✅

Extract the dynamic UI engine out of the e_pg project into a dependency-free
package, removing GetX / magic_view / micropack_core / screenutil.

- ✅ Package scaffold (`pubspec.yaml`, barrel, analysis)
- ✅ Theme layer: `CofluiColors`, `CofluiTypography`, `CofluiBreakpoints`
- ✅ Native widget set (thin wrappers): `CofluiText`, `CofluiButton`,
  `CofluiTextField`, `CofluiDropdown`, `CofluiCard`, `CofluiDialog`,
  `CofluiGrid`, `CofluiResponsive`
- ✅ Dynamic engine migrated to `ChangeNotifier` + native widgets
- ✅ Responsive `grid` component (breakpoint-driven column count)
- ✅ Docs: README, ARCHITECTURE, DYNAMIC_UI schema, ROADMAP

## Milestone 2 — Prove in-host ⬜

Integrate coflui back into e_pg as the live consumer (gallery + samples).
This is the dogfood milestone — keep e_pg's GetX at the *module* layer while
coflui runs native underneath.

- 🚧 e_pg `pubspec` depends on `coflui` (path)
- 🚧 `SampleRendererController` extends `CofluiFormController`
- 🚧 Gallery views use `ListenableBuilder`
- 🚧 New sample demonstrating responsive `grid` (mobile/tablet/desktop)
- ⬜ All existing samples (FTKP document, form izin, data-passing) render green

## Milestone 3 — Responsive depth ⬜

- ⬜ `maxWidth` / content-centering for cards & body on desktop
- ⬜ `row` `wrap` mode (auto-flow children to next line when cramped)
- ⬜ Navigation-shell guidance sample (master-detail on desktop)
- ⬜ Breakpoint-driven `grid` hints documented + tested

## Milestone 4 — Richer dynamic components ⬜

- ⬜ `image` component (network + asset)
- ⬜ `list` component (bind an array → repeat a child template)
- ⬜ Conditional visibility (`visibleWhen` expression on a node)
- ⬜ Dynamic option sources (fetch dropdown options from an endpoint)
- ⬜ `icon` / `avatar` components

## Milestone 5 — Full native widget set ⬜

Grow `src/widgets` so it can **fully replace magic_view** project-wide:

- ⬜ `CofluiAutoComplete`
- ⬜ `CofluiDatePicker` / `CofluiMonthPicker` (styled dialogs)
- ⬜ `CofluiDialog` rich variants (confirm with input, bottom-sheet)
- ⬜ `CofluiLayout` (scaffold helpers: app bar, section headers)
- ⬜ Theming polish: dark mode tokens, typography presets

## Milestone 6 — Remote / Server-Driven UI ⬜

- ⬜ `CofluiRemoteView` — fetch layout JSON from a URL, render, cache
- ⬜ Validation contract (shape-check before render, graceful error card)
- ⬜ Action routing (button `actionUrl` → POST snapshot back)
- ⬜ Hot-reload / versioning of layouts

## Milestone 7 — Quality & distribution ⬜

- ⬜ Unit tests for models, registry, resolver, controller
- ⬜ Golden tests for responsive grid breakpoints
- ⬜ Example app (`example/`) showcasing everything
- ⬜ Publish to pub.dev (or internal versioned tag releases)
- ⬜ Changelog automation / semantic versioning

## Decisions log

| Topic          | Decision                                                    |
|----------------|-------------------------------------------------------------|
| State mgmt     | `ChangeNotifier`-based; interface for adapters              |
| Sizing         | raw logical px (no screenutil)                              |
| Responsive     | breakpoint-driven layout, not element scaling               |
| Deps           | `flutter` + `gap` only                                      |
| Replacing MV   | grow `Coflui*` widgets first, deprecate magic_view later    |
