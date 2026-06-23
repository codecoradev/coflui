import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/registry/widget_registry.dart';
import 'package:flutter/material.dart';

/// Widget entry point untuk merender sebuah [UIComponent] (beserta seluruh
/// subtree-nya) menggunakan [WidgetRegistry].
///
/// Penggunaan:
/// ```dart
/// DynamicUIWidget(component, controller: myController)
/// ```
///
/// `controller` wajib di-pass untuk komponen input & button agar value/action
/// bisa di-bind. Komponen display (text/heading/divider) tetap jalan walau
/// controller null.
///
/// Bila controller adalah [Listenable] (mis. [CofluiFormController]), widget
/// otomatis rebuild ketika struktur komponen berubah (loadFromJson/reset).
/// Perubahan value field individual TIDAK memicu rebuild penuh — input
/// self-manage via StatefulWidget, sehingga efisien.
class DynamicUIWidget extends StatelessWidget {
  final UIComponent component;
  final CofluiFormControllerLike? controller;

  const DynamicUIWidget(
    this.component, {
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    Widget buildTree(BuildContext ctx, CofluiFormControllerLike c) =>
        WidgetRegistry.build(ctx, component, c);

    if (ctrl == null) {
      return buildTree(context, _NullController());
    }
    if (ctrl is Listenable) {
      return ListenableBuilder(
        listenable: ctrl as Listenable,
        builder: (ctx, _) => buildTree(ctx, ctrl),
      );
    }
    return buildTree(context, ctrl);
  }
}

/// Fallback controller yang tidak melakukan apa-apa. Dipakai saat
/// [DynamicUIWidget.controller] null agar widget tetap bisa dirender.
class _NullController implements CofluiFormControllerLike {
  @override
  bool get readOnly => false;

  @override
  void onAction(String action, String componentId) {}

  @override
  dynamic getValue(String id) => null;

  @override
  void setValue(String id, dynamic value) {}
}
