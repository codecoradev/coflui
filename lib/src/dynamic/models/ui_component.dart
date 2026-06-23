// ignore_for_file: avoid_dynamic_calls

import 'ui_style.dart';

/// Semua tipe komponen yang didukung oleh Dynamic UI renderer.
///
/// Tipe container (`column`, `row`, `card`, `section`, `grid`) punya `children`
/// sehingga bisa bersarang tak terhingga. Tipe leaf (`text`, `textfield`,
/// `button`, dst) dirender apa adanya.
enum UIType {
  // Container / layout
  column,
  row,
  grid,
  card,
  section,

  // Display
  text,
  heading,
  divider,

  // Input
  textfield,
  dropdown,
  switchField,
  datePicker,
  checkbox,

  // Action
  button;

  static UIType fromString(String? v) {
    if (v == null) return UIType.text;
    switch (v.toLowerCase()) {
      case 'column':
        return UIType.column;
      case 'row':
        return UIType.row;
      case 'grid':
        return UIType.grid;
      case 'card':
        return UIType.card;
      case 'section':
        return UIType.section;
      case 'text':
        return UIType.text;
      case 'heading':
      case 'title':
        return UIType.heading;
      case 'divider':
        return UIType.divider;
      case 'textfield':
      case 'input':
      case 'textarea':
        return UIType.textfield;
      case 'dropdown':
      case 'select':
        return UIType.dropdown;
      case 'switch':
        return UIType.switchField;
      case 'datepicker':
      case 'date_picker':
      case 'date':
        return UIType.datePicker;
      case 'checkbox':
        return UIType.checkbox;
      case 'button':
      case 'btn':
        return UIType.button;
      default:
        return UIType.text;
    }
  }
}

/// Model node UI yang dirender dari JSON.
///
/// Struktur dasar (reusable & nestable):
/// ```json
/// {
///   "id": "nama_karyawan",
///   "type": "text",
///   "label": "Nama Karyawan",
///   "value": "Budi",
///   "props": {},     // config khusus per type
///   "style": {},     // lihat [UIStyle]
///   "children": []   // hanya untuk type container
/// }
/// ```
class UIComponent {
  /// Identifier unik. Dipakai sebagai key state value di controller.
  final String id;

  final UIType type;
  final String? label;

  /// Nilai awal / nilai display. Bisa String, int, double, bool, List, Map, null.
  final dynamic value;

  /// Config khusus per type (maxLength, options, variant, action, dst).
  final Map<String, dynamic> props;
  final UIStyle style;

  /// Anak komponen (hanya untuk container: column/row/grid/card/section).
  final List<UIComponent> children;

  const UIComponent({
    required this.id,
    required this.type,
    this.label,
    this.value,
    this.props = const {},
    this.style = UIStyle.empty,
    this.children = const [],
  });

  factory UIComponent.fromJson(Map<String, dynamic> j) {
    final rawChildren = j['children'];
    return UIComponent(
      id: (j['id'] ??
              j['key'] ??
              '_${DateTime.now().microsecondsSinceEpoch}')
          .toString(),
      type: UIType.fromString(j['type'] as String?),
      label: j['label'] as String?,
      value: j['value'],
      props:
          j['props'] is Map ? Map<String, dynamic>.from(j['props'] as Map) : const {},
      style: UIStyle.fromJson(j['style']),
      children: rawChildren is List
          ? rawChildren
              .map((e) =>
                  UIComponent.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : const [],
    );
  }

  /// Parse list JSON (root tree biasanya berupa array of component).
  static List<UIComponent> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .map((e) =>
              UIComponent.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    if (json is Map) {
      // Single root object → bungkus sebagai list satu elemen.
      return [UIComponent.fromJson(Map<String, dynamic>.from(json))];
    }
    return const [];
  }

  /// Cari komponen berdasarkan id (BFS ke seluruh subtree).
  UIComponent? findById(String targetId) {
    if (id == targetId) return this;
    for (final c in children) {
      final found = c.findById(targetId);
      if (found != null) return found;
    }
    return null;
  }

  /// Telusuri seluruh node (termasuk anak) dan panggil [callback].
  void traverse(void Function(UIComponent c) callback) {
    callback(this);
    for (final c in children) {
      c.traverse(callback);
    }
  }
}

/// Helper akses props yang aman untuk berbagai tipe data.
extension UIComponentProps on UIComponent {
  String? get stringProp =>
      props['value']?.toString() ?? value?.toString();
  bool? get boolProp => props['value'] is bool
      ? props['value'] as bool?
      : (value is bool ? value as bool? : null);
}
