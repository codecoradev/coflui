import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: render JSON components via the dynamic engine using a concrete
/// [CofluiFormController] (so loadFromJson/components are directly available).
Future<void> _pumpDynamic(
  WidgetTester tester,
  List<Map<String, dynamic>> json,
) async {
  final ctrl = CofluiFormController()..loadFromJson(json);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            for (final c in ctrl.components)
              DynamicUIWidget(c, controller: ctrl),
          ],
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(DynamicUIBootstrap.registerDefaults);

  group('DynamicUIWidget — media builders', () {
    testWidgets('icon renders named Material icon', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'i', 'type': 'icon', 'props': {'icon': 'home'}},
      ]);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('icon renders asset source via CofluiIcon', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'i',
          'type': 'icon',
          'props': {'source': 'assets/svg/logo.svg'},
        },
      ]);
      // Source path → CofluiIcon widget tree (not the named-icon path).
      expect(find.byIcon(Icons.home), findsNothing);
    });

    testWidgets('image renders with src prop', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'img',
          'type': 'image',
          'props': {'src': 'https://example.com/a.png', 'size': 48},
        },
      ]);
      // Should not crash; a widget subtree is built.
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('gradientBar renders a gradient container', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'g',
          'type': 'gradient_bar',
          'props': {'gradient': 'cool', 'height': 10},
        },
      ]);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });
  });

  group('DynamicUIWidget — content builders', () {
    testWidgets('listTile renders title + subtitle + leading + trailing',
        (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'row1',
          'type': 'list_tile',
          'props': {
            'title': 'Budi',
            'subtitle': 'Manager',
            'leading': 'person',
            'trailing': 'chevron_right',
          },
        },
      ]);
      expect(find.text('Budi'), findsOneWidget);
      expect(find.text('Manager'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('listTile action fires controller.onAction', (tester) async {
      final spy = _ActionSpy();
      const component = UIComponent(
        id: 'row1',
        type: UIType.listTile,
        props: {'title': 'Open', 'action': 'open_item'},
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DynamicUIWidget(component, controller: spy)),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
      expect(spy.actions, ['open_item@row1']);
    });

    testWidgets('detailRow renders icon + label + value', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'd',
          'type': 'detail_row',
          'props': {
            'icon': 'calendar_today',
            'label': 'Date',
            'value': '2026-07-22',
          },
        },
      ]);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('2026-07-22'), findsOneWidget);
    });

    testWidgets('detailRow highlight applies primary color', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'd',
          'type': 'detail',
          'props': {
            'icon': 'check',
            'label': 'Status',
            'value': 'Approved',
            'highlight': true,
          },
        },
      ]);
      final value = tester.widget<Text>(find.text('Approved'));
      expect(value.style?.color, isNot(equals(CofluiColors.onSurface)));
    });

    testWidgets('detailRow accepts iconSize prop', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'd',
          'type': 'detail_row',
          'props': {
            'icon': 'star',
            'iconSize': 32,
            'label': 'Rating',
            'value': '5.0',
          },
        },
      ]);
      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 32);
    });

    testWidgets('detailRow renders without icon when omitted', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'd',
          'type': 'detail_row',
          'props': {'label': 'No Icon', 'value': 'val'},
        },
      ]);
      expect(find.text('No Icon'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('listTile leadingSize controls trailing icon size',
        (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'lt',
          'type': 'list_tile',
          'props': {
            'title': 'T',
            'leading': 'home',
            'trailing': 'star',
            'leadingSize': 30,
            'trailingSize': 18,
          },
        },
      ]);
      expect((tester.widget<Icon>(find.byIcon(Icons.home))).size, 30);
      expect((tester.widget<Icon>(find.byIcon(Icons.star))).size, 18);
    });
  });

  group('DynamicUIWidget — registration', () {
    test('all new types are registered', () {
      for (final type in [
        UIType.icon,
        UIType.image,
        UIType.gradientBar,
        UIType.listTile,
        UIType.detailRow,
      ]) {
        expect(WidgetRegistry.isRegistered(type), isTrue,
            reason: '$type should be registered');
      }
    });
  });
}

/// Records onAction calls as "action@componentId".
class _ActionSpy implements CofluiFormControllerLike {
  final List<String> actions = [];

  @override
  bool get readOnly => false;

  @override
  void onAction(String action, String componentId) =>
      actions.add('$action@$componentId');

  @override
  dynamic getValue(String id) => null;

  @override
  void setValue(String id, dynamic value) {}
}
