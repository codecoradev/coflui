# Architecture

This document explains how Coflui is layered, why it is state-agnostic, and the
design decisions behind the responsive strategy.

## Layers

```
┌─────────────────────────────────────────────────────────────┐
│  Consumer app (GetX / Riverpod / BLoC / Provider / setState) │
├─────────────────────────────────────────────────────────────┤
│  coflui public API  (lib/coflui.dart — single barrel)        │
├─────────────────────────┬───────────────────────────────────┤
│   src/dynamic (engine)  │   src/widgets (native standards)   │
│  models / registry /    │  CofluiText / CofluiButton /        │
│  resolvers / builders / │  CofluiTextField / CofluiDropdown / │
│  controllers / widgets  │  CofluiCard / CofluiGrid / ...      │
├─────────────────────────┴───────────────────────────────────┤
│   src/theme                                              │
│   CofluiColors / CofluiTypography / CofluiBreakpoints       │
├─────────────────────────────────────────────────────────────┤
│   flutter SDK + gap   (the ONLY runtime dependencies)        │
└─────────────────────────────────────────────────────────────┘
```

### Why the dynamic engine consumes `src/widgets`

A defining goal of Coflui: **one standard**. The dynamic renderer does not hand
back raw `Text`/`ElevatedButton`; it returns `CofluiText`/`CofluiButton` — the
exact same widgets you would use in hand-written code. This means:

- A JSON-driven screen and a coded screen are visually & behaviorally identical.
- Improving `CofluiButton` automatically improves every dynamically-rendered
  button — no parallel implementation to keep in sync.
- The engine is the first consumer of the widget set, dogfooding it from day one.

### Why no GetX / magic_view / micropack_core

Earlier prototypes lived inside an e_pg project that used GetX + `magic_view` +
`micropack_core`. Extracting into a reusable package required removing every
hard dependency:

| Removed          | Replaced with                                          |
|------------------|--------------------------------------------------------|
| GetX (`get`)     | `ChangeNotifier` + `ValueNotifier` (native Flutter)    |
| `magic_view`     | thin native Flutter wrappers (`CofluiText`, …)         |
| `micropack_core` | `debugPrint` (via the consuming app's logger if wanted) |
| `screenutil`     | raw logical pixels + breakpoint-driven layout           |

Result: Coflui has exactly **one** runtime dependency (`gap`) plus the Flutter
SDK. It can be dropped into any Flutter project regardless of its state
management, networking, or design-system choices.

## State strategy

The controller hierarchy:

```
CofluiFormControllerLike  (abstract — the engine's only contract)
        ▲
        │ implements
CofluiFormController extends ChangeNotifier
```

- The engine's builders depend only on `CofluiFormControllerLike` (4 methods:
  `readOnly`, `getValue`, `setValue`, `onAction`). Any state-management
  solution can implement this interface.
- `CofluiFormController` provides a ready-to-use native implementation:
  - `ChangeNotifier` for **structural** changes (`loadFromJson`, `resetValues`).
  - A `ValueNotifier` per field for **granular** reactivity
    (`fieldListenable(id)`).
- `setValue()` intentionally does **not** call `notifyListeners()`. Input
  widgets self-manage via their own `StatefulWidget`, so a full tree rebuild on
  every keystroke is avoided. `DynamicUIWidget` uses `ListenableBuilder` to
  rebuild only when structure changes (efficient).

### Adapters (future)

| Consumer SM      | Adapter sketch                                                |
|------------------|---------------------------------------------------------------|
| GetX             | `class GetxCofluiController extends GetxController implements CofluiFormControllerLike` |
| Riverpod         | `Notifier` impl + `ValueNotifier` cache                       |
| BLoC             | `Bloc<CofluiEvent, CofluiState>` implementing the interface   |
| Provider         | use `CofluiFormController` directly (already a `ChangeNotifier`) |

## Responsive strategy

Coflui adapts by **breakpoint**, not by stretching element sizes:

| Device  | Width          |
|---------|----------------|
| mobile  | `< 600`        |
| tablet  | `600 – 1023`   |
| desktop | `≥ 1024`       |

(thresholds configurable via `CofluiBreakpoints.tablet` / `.desktop`.)

- **Element sizing stays raw** — `fontSize: 14` is 14 logical px on every
  device. Predictable, testable, dependency-free.
- **Layout adapts** — `CofluiGrid` derives column count from the breakpoint;
  `CofluiResponsive` swaps subtrees; the dynamic `grid` component mirrors this.
- **Max-width & centering** (planned) — cap content width on desktop so line
  lengths stay readable (like articles on the web).

This separation keeps individual widgets simple while the *composition* responds
to the form factor.

## Custom builders

```dart
WidgetRegistry.register(UIType.fromString('chart'), (ctx, component, ctrl) {
  return MyChart(data: component.props['data']);
});
```

The registry is static and global. Register once at boot, then any JSON node
with `"type": "chart"` renders through your builder. The default set is
registered via `DynamicUIBootstrap.registerDefaults()`.
