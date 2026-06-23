# Coflui

A standalone Flutter UI package that combines:

- **Dynamic UI engine** — render entire widget trees from JSON (Server-Driven UI), with unlimited nesting, reusable components, input/actionable elements, and a state-agnostic controller.
- **Native Flutter widgets** — `CofluiText`, `CofluiButton`, `CofluiTextField`, `CofluiDropdown`, `CofluiCard`, `CofluiGrid`, … one standard used by both the dynamic renderer and hand-written code.
- **Responsive by breakpoint** — automatic adaptation across **mobile / tablet / desktop** (Material 3 adaptive thresholds).

> **State-management agnostic.** The engine is built on `ChangeNotifier` + `ValueNotifier` (native Flutter reactivity), so it works with GetX, Riverpod, BLoC, Provider, or plain `setState` — no binding required.

## Install

```yaml
dependencies:
  coflui:
    git:
      url: https://github.com/codecoradev/coflui.git
      ref: main
```

```dart
import 'package:coflui/coflui.dart';
```

## Quick start — dynamic UI

```dart
final controller = CofluiFormController();

// 1. register default builders (once, at app boot)
DynamicUIBootstrap.registerDefaults();

// 2. load JSON
controller.loadFromJson([
  {"id": "name", "type": "textfield", "label": "Name", "props": {"hint": "Your name"}},
  {"id": "submit", "type": "button", "label": "Save", "props": {"action": "submit"}},
]);

// 3. render
Column(
  children: controller.components
      .map((c) => DynamicUIWidget(c, controller: controller))
      .toList(),
);
```

## Quick start — native widgets

```dart
CofluiCard(
  title: 'Profile',
  child: CofluiGrid(
    mobileColumns: 1,
    tabletColumns: 2,
    desktopColumns: 3,
    children: [ /* stat tiles */ ],
  ),
);

CofluiButton(
  label: 'Submit',
  variant: CofluiButtonVariant.primary,
  icon: Icons.send,
  fullWidth: true,
  onPressed: submit,
);
```

## Documentation

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — layering, state strategy, design decisions
- [docs/ROADMAP.md](docs/ROADMAP.md) — milestones & phased plan
- [docs/DYNAMIC_UI.md](docs/DYNAMIC_UI.md) — JSON schema reference for all component types

## License

MIT
