import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:flutter/material.dart';

/// Fungsi builder yang mengubah [UIComponent] menjadi [Widget].
///
/// [controller] adalah [CofluiFormControllerLike] — di-pass sebagai abstract
/// interface agar core engine tidak terikat state management apapun.
typedef UIBuilder = Widget Function(
  BuildContext context,
  UIComponent component,
  CofluiFormControllerLike controller,
);

/// Abstraksi minimal controller yang dibutuhkan builder input/action.
///
/// Core engine hanya bergantung pada interface ini, sehingga setiap project
/// bebas mengimplementasikan state management-nya sendiri — pakai bawaan
/// [CofluiFormController] (ChangeNotifier), atau GetX/Riverpod/BLoC dengan
/// adapter yang mengimplementasikan interface ini.
abstract class CofluiFormControllerLike {
  /// Mode read-only: bila `true`, seluruh input di-render non-aktif.
  bool get readOnly;

  /// Ambil value terakhir untuk id.
  dynamic getValue(String id);

  /// Set value untuk id tertentu.
  void setValue(String id, dynamic value);

  /// Dipanggil saat tombol dengan `props.action` di-tap.
  void onAction(String action, String componentId);
}

/// Registri builder per [UIType]. Static & global (di-register sekali saat
/// boot). Builder bawaan didaftarkan lewat [DynamicUIBootstrap.registerDefaults].
class WidgetRegistry {
  WidgetRegistry._();

  static final Map<UIType, UIBuilder> _builders = {};

  /// Daftarkan builder untuk sebuah [type].
  static void register(UIType type, UIBuilder builder) {
    _builders[type] = builder;
  }

  /// Daftarkan banyak builder sekaligus.
  static void registerAll(Map<UIType, UIBuilder> builders) {
    _builders.addAll(builders);
  }

  /// Build widget untuk sebuah component.
  /// Jika belum terdaftar, kembalikan placeholder agar tidak crash.
  static Widget build(
    BuildContext context,
    UIComponent component,
    CofluiFormControllerLike controller,
  ) {
    final builder = _builders[component.type];
    if (builder == null) {
      return _UnsupportedComponent(component: component);
    }
    return builder(context, component, controller);
  }

  /// Cek apakah builder untuk type sudah didaftarkan.
  static bool isRegistered(UIType type) => _builders.containsKey(type);
}

class _UnsupportedComponent extends StatelessWidget {
  final UIComponent component;
  const _UnsupportedComponent({required this.component});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Unsupported type: "${component.type.name}"\n'
        'Register a builder via WidgetRegistry.register().',
        style: const TextStyle(fontSize: 12, color: Colors.red),
      ),
    );
  }
}
