import 'package:coflui/src/dynamic/builders/action_builders.dart';
import 'package:coflui/src/dynamic/builders/container_builders.dart';
import 'package:coflui/src/dynamic/builders/content_builders.dart';
import 'package:coflui/src/dynamic/builders/display_builders.dart';
import 'package:coflui/src/dynamic/builders/input_builders.dart';
import 'package:coflui/src/dynamic/builders/media_builders.dart';
import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/registry/widget_registry.dart';

/// Helper untuk mendaftarkan seluruh builder bawaan ke [WidgetRegistry].
///
/// Idempotent: aman dipanggil berkali-kali. Panggil sekali saat app boot
/// (atau sebelum render pertama).
class DynamicUIBootstrap {
  DynamicUIBootstrap._();

  static bool _initialized = false;

  static void registerDefaults() {
    if (_initialized) return;
    _initialized = true;

    WidgetRegistry.registerAll({
      // Container
      UIType.column: ContainerBuilders.column,
      UIType.row: ContainerBuilders.row,
      UIType.grid: ContainerBuilders.grid,
      UIType.card: ContainerBuilders.card,
      UIType.section: ContainerBuilders.section,

      // Display
      UIType.text: DisplayBuilders.text,
      UIType.heading: DisplayBuilders.heading,
      UIType.divider: DisplayBuilders.divider,

      // Input
      UIType.textfield: InputBuilders.textfield,
      UIType.dropdown: InputBuilders.dropdown,
      UIType.switchField: InputBuilders.switchField,
      UIType.datePicker: InputBuilders.datePicker,
      UIType.checkbox: InputBuilders.checkbox,

      // Action
      UIType.button: ActionBuilders.button,

      // Media
      UIType.icon: MediaBuilders.icon,
      UIType.image: MediaBuilders.image,
      UIType.gradientBar: MediaBuilders.gradientBar,

      // Content
      UIType.listTile: ContentBuilders.listTile,
      UIType.detailRow: ContentBuilders.detailRow,
    });
  }
}
