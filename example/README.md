# Coflui — Example App

A runnable Flutter app demonstrating everything **Coflui** has to offer:

| Screen | What it shows |
|--------|---------------|
| **Widget Gallery** | Every native `Coflui*` widget (text, button, card, grid, dropdown, text field, dialog) |
| **Dynamic UI — Form** | A complete form rendered entirely from JSON (textfield, dropdown, switch, datepicker, button) |
| **Dynamic UI — Dashboard** | A responsive dashboard layout from JSON (grid of cards, headings, responsive columns) |
| **Responsive Demo** | `CofluiResponsive` & `CofluiGrid` adapting live across mobile / tablet / desktop breakpoints |

## Run

```bash
cd example
flutter pub get
```

### Web

```bash
# Build a production bundle
flutter build web
# → open build/web/index.html, or serve it:

dart run dhttpd --path build/web   # optional: local server

# Or run directly in Chrome (if Chrome is installed)
flutter run -d chrome
```

### iOS simulator

```bash
# List available simulators
flutter devices

# Run on a simulator (Flutter auto-selects, or target by ID/name)
flutter run -d ios
# or explicitly:
flutter run -d "iPhone 15 Pro"
```

> **No CocoaPods setup needed.** Coflui is pure Dart (no native plugins),
> so the iOS app builds directly without a Podfile.

### Tip

Resize the simulator/browser window to see the responsive breakpoints adapt
in real time (mobile < 600 → tablet 600–1023 → desktop ≥ 1024).

## Project structure

```
example/
  lib/
    main.dart                    # entry point + shell (navigation)
    screens/
      widget_gallery_screen.dart # native Coflui* widgets catalog
      dynamic_form_screen.dart   # JSON → form (inputs + submit)
      dynamic_dashboard_screen.dart  # JSON → responsive dashboard
      responsive_screen.dart     # breakpoint demo
    samples/
      form_json.dart             # raw JSON for the form screen
      dashboard_json.dart        # raw JSON for the dashboard screen
```

## What you'll learn

1. **How to bootstrap the dynamic engine** (`DynamicUIBootstrap.registerDefaults()`)
2. **How to load JSON and render** (`controller.loadFromJson()` + `DynamicUIWidget`)
3. **How to read values** (`controller.snapshot()`, `controller.getValue(id)`)
4. **How to handle button actions** (override `onAction` in a custom controller)
5. **How to use native widgets** in hand-written code
6. **How responsive layout works** (breakpoint-driven, not scaling)
