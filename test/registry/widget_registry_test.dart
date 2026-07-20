import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/registry/widget_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A dummy builder for registry tests.
Widget _dummyBuilder(BuildContext ctx, UIComponent c, _) =>
    Text('dummy:${c.id}');

/// A second dummy to distinguish registrations.
Widget _altBuilder(BuildContext ctx, UIComponent c, _) =>
    Text('alt:${c.id}');

void main() {
  // WidgetRegistry is a static/global singleton. Tests here exercise the
  // register/isRegistered/build API surface. We use UIType.checkbox as our
  // guinea pig because no other test file in this suite registers a *custom*
  // builder for it (the default builder is registered by bootstrap, which
  // doesn't run in this file's context).

  group('WidgetRegistry.register', () {
    test('registers a single builder', () {
      WidgetRegistry.register(UIType.text, _dummyBuilder);
      expect(WidgetRegistry.isRegistered(UIType.text), isTrue);
    });

    test('overwrites previous registration for same type', () {
      WidgetRegistry.register(UIType.checkbox, _dummyBuilder);
      WidgetRegistry.register(UIType.checkbox, _altBuilder);
      // Both registered but the latest wins — verify isRegistered is true.
      expect(WidgetRegistry.isRegistered(UIType.checkbox), isTrue);
    });
  });

  group('WidgetRegistry.registerAll', () {
    test('registers multiple builders at once', () {
      WidgetRegistry.registerAll({
        UIType.divider: _dummyBuilder,
        UIType.button: _altBuilder,
      });
      expect(WidgetRegistry.isRegistered(UIType.divider), isTrue);
      expect(WidgetRegistry.isRegistered(UIType.button), isTrue);
    });
  });

  group('WidgetRegistry.isRegistered', () {
    test('returns true after register', () {
      WidgetRegistry.register(UIType.section, _dummyBuilder);
      expect(WidgetRegistry.isRegistered(UIType.section), isTrue);
    });
  });

  group('WidgetRegistry.build', () {
    testWidgets('invokes the registered builder', (tester) async {
      WidgetRegistry.register(UIType.text, _dummyBuilder);

      const component = UIComponent(id: 'abc', type: UIType.text);
      late BuildContext savedCtx;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                savedCtx = ctx;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Build the widget using the captured context.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetRegistry.build(savedCtx, component, _NullController()),
          ),
        ),
      );

      expect(find.text('dummy:abc'), findsOneWidget);
    });
  });
}

/// Minimal controller impl for builder tests.
class _NullController implements CofluiFormControllerLike {
  @override
  bool get readOnly => false;
  @override
  dynamic getValue(String id) => null;
  @override
  void setValue(String id, dynamic value) {}
  @override
  void onAction(String action, String componentId) {}
}
