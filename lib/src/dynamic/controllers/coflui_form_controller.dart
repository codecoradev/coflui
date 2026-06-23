import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/registry/widget_registry.dart';
import 'package:flutter/foundation.dart';

/// Base controller (native [ChangeNotifier]) yang menyimpan state value
/// seluruh komponen Dynamic UI.
///
/// Karena dibangun di atas [ChangeNotifier] + [ValueNotifier] (reaktif native
/// Flutter), controller ini **bebas dipakai dengan state management apapun**:
/// GetX, Riverpod, BLoC, Provider — semuanya bisa interop.
///
/// Subclass tinggal meng-override [onAction] untuk menangani aksi tombol
/// (submit/reset/custom).
///
/// Setiap field value disimpan sebagai [ValueNotifier] per-`id`, sehingga
/// widget dapat mendengarkan perubahan granular via [fieldListenable].
class CofluiFormController extends ChangeNotifier
    implements CofluiFormControllerLike {
  /// Root tree komponen (setelah [loadFromJson]).
  List<UIComponent> _components;

  /// Mode read-only. Set `true` untuk menonaktifkan seluruh input.
  @override
  bool readOnly;

  final Map<String, ValueNotifier<dynamic>> _fields = {};

  CofluiFormController({
    List<UIComponent>? components,
    this.readOnly = false,
  }) : _components = components ?? const [];

  List<UIComponent> get components => _components;

  /// Parse JSON (List atau Map) menjadi tree komponen & inisialisasi state.
  void loadFromJson(dynamic json) {
    _components = UIComponent.fromJsonList(json);
    _seedFromComponents();
    notifyListeners();
  }

  /// Inject nilai awal (mis. dari halaman pengirim data-passing A→B).
  void seedValues(Map<String, dynamic> values) {
    values.forEach((id, v) {
      _fields.putIfAbsent(id, () => ValueNotifier<dynamic>(null)).value = v;
    });
    notifyListeners();
  }

  /// Kembalikan tree komponen ke nilai awal (dari JSON).
  void resetValues() {
    for (final c in _components) {
      c.traverse((node) {
        _fields[node.id]?.value = node.value;
      });
    }
    notifyListeners();
  }

  void _seedFromComponents() {
    for (final c in _components) {
      c.traverse((node) {
        _fields.putIfAbsent(node.id, () => ValueNotifier<dynamic>(node.value));
      });
    }
  }

  @override
  dynamic getValue(String id) => _fields[id]?.value;

  @override
  void setValue(String id, dynamic value) {
    // Update notifier per-field tanpa notifyListeners() global — input
    // self-manage via StatefulWidget-nya sendiri, jadi tidak perlu rebuild
    // seluruh tree pada setiap ketikan.
    _fields.putIfAbsent(id, () => ValueNotifier<dynamic>(null)).value = value;
  }

  /// Dengarkan perubahan satu field secara granular (native ValueListenable).
  ValueListenable<dynamic>? fieldListenable(String id) => _fields[id];

  /// Snapshot seluruh value (id → value).
  Map<String, dynamic> snapshot() {
    return {for (final e in _fields.entries) e.key: e.value.value};
  }

  /// Hook untuk aksi tombol. Override di subclass.
  @override
  void onAction(String action, String componentId) {}

  @override
  void dispose() {
    for (final n in _fields.values) {
      n.dispose();
    }
    super.dispose();
  }
}
