/// Coflui — standalone Flutter UI package.
///
/// One import gives you everything:
///   - Dynamic UI engine (JSON-driven widget renderer)
///   - Native Flutter widgets (CofluiText, CofluiButton, …)
///   - Theme tokens + responsive breakpoints
///
/// ```dart
/// import 'package:coflui/coflui.dart';
/// ```
library coflui;

// Theme
export 'src/theme/coflui_colors.dart';
export 'src/theme/coflui_typography.dart';
export 'src/theme/coflui_breakpoints.dart';

// Widgets (native standards)
export 'src/widgets/coflui_text.dart';
export 'src/widgets/coflui_button.dart';
export 'src/widgets/coflui_text_field.dart';
export 'src/widgets/coflui_dropdown.dart';
export 'src/widgets/coflui_card.dart';
export 'src/widgets/coflui_dialog.dart';
export 'src/widgets/coflui_grid.dart';
export 'src/widgets/coflui_responsive.dart';

// Dynamic UI engine
export 'src/dynamic/bootstrap.dart';
export 'src/dynamic/models/ui_component.dart';
export 'src/dynamic/models/ui_style.dart';
export 'src/dynamic/registry/widget_registry.dart';
export 'src/dynamic/resolvers/style_resolver.dart';
export 'src/dynamic/controllers/coflui_form_controller.dart';
export 'src/dynamic/widgets/dynamic_ui_widget.dart';
