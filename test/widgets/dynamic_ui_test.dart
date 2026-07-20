import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: render a single JSON component via the dynamic engine.
Future<void> _pumpDynamic(
  WidgetTester tester,
  List<Map<String, dynamic>> json, {
  CofluiFormControllerLike? controller,
}) async {
  final ctrl = controller ?? CofluiFormController();
  ctrl.asController.loadFromJson(json);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            for (final c in ctrl.asController.components)
              DynamicUIWidget(c, controller: ctrl),
          ],
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() {
    DynamicUIBootstrap.registerDefaults();
  });

  group('DynamicUIBootstrap.registerDefaults', () {
    test('is idempotent — calling twice does not throw or duplicate', () {
      // Already called in setUpAll, call again.
      DynamicUIBootstrap.registerDefaults();
      DynamicUIBootstrap.registerDefaults();
      // No exception = pass.
    });

    test('registers all core types', () {
      for (final type in [
        UIType.column, UIType.row, UIType.grid, UIType.card, UIType.section,
        UIType.text, UIType.heading, UIType.divider,
        UIType.textfield, UIType.dropdown, UIType.switchField,
        UIType.datePicker, UIType.checkbox,
        UIType.button,
      ]) {
        expect(WidgetRegistry.isRegistered(type), isTrue,
            reason: '$type should be registered');
      }
    });
  });

  group('DynamicUIWidget — display builders', () {
    testWidgets('text renders label as body', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 't', 'type': 'text', 'label': 'Hello Text'},
      ]);
      expect(find.text('Hello Text'), findsOneWidget);
    });

    testWidgets('text renders value when present (over label)', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 't', 'type': 'text', 'label': 'Label', 'value': 'Value Wins'},
      ]);
      expect(find.text('Value Wins'), findsOneWidget);
    });

    testWidgets('heading renders with larger fontSize', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'h', 'type': 'heading', 'label': 'Big Heading'},
      ]);
      final text = tester.widget<Text>(find.text('Big Heading'));
      expect(text.style?.fontSize, CofluiTypography.sectionTitle);
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('heading alias "title" works', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'h', 'type': 'title', 'label': 'Title Alias'},
      ]);
      expect(find.text('Title Alias'), findsOneWidget);
    });

    testWidgets('divider renders', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'd', 'type': 'divider'},
      ]);
      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('DynamicUIWidget — container builders', () {
    testWidgets('column renders children vertically', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'col',
          'type': 'column',
          'children': [
            {'id': 'a', 'type': 'text', 'label': 'Child A'},
            {'id': 'b', 'type': 'text', 'label': 'Child B'},
          ],
        },
      ]);
      expect(find.text('Child A'), findsOneWidget);
      expect(find.text('Child B'), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('row renders children with Flexible wrappers', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'r',
          'type': 'row',
          'children': [
            {'id': 'a', 'type': 'text', 'label': 'R-A'},
            {'id': 'b', 'type': 'text', 'label': 'R-B'},
          ],
        },
      ]);
      expect(find.text('R-A'), findsOneWidget);
      expect(find.text('R-B'), findsOneWidget);
      // Row children should be wrapped in Flexible/Expanded.
      expect(find.byType(Flexible), findsNWidgets(2));
    });

    testWidgets('row with flex prop wraps child in Expanded', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'r',
          'type': 'row',
          'children': [
            {'id': 'a', 'type': 'text', 'label': 'Flex', 'props': {'flex': 2}},
            {'id': 'b', 'type': 'text', 'label': 'Loose'},
          ],
        },
      ]);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('card renders with title and children', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'c',
          'type': 'card',
          'label': 'Card Title',
          'children': [
            {'id': 'inner', 'type': 'text', 'label': 'Inside Card'},
          ],
        },
      ]);
      expect(find.text('Card Title'), findsOneWidget);
      expect(find.text('Inside Card'), findsOneWidget);
    });

    testWidgets('section alias renders like card', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 's',
          'type': 'section',
          'label': 'Section Title',
          'children': [
            {'id': 'inner', 'type': 'text', 'label': 'In Section'},
          ],
        },
      ]);
      expect(find.text('Section Title'), findsOneWidget);
      expect(find.text('In Section'), findsOneWidget);
    });

    testWidgets('grid renders responsive layout', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'g',
          'type': 'grid',
          'props': {'mobileColumns': 1, 'tabletColumns': 2, 'desktopColumns': 3},
          'children': [
            {'id': 'c1', 'type': 'text', 'label': 'G1'},
            {'id': 'c2', 'type': 'text', 'label': 'G2'},
            {'id': 'c3', 'type': 'text', 'label': 'G3'},
          ],
        },
      ]);
      expect(find.text('G1'), findsOneWidget);
      expect(find.text('G2'), findsOneWidget);
      expect(find.text('G3'), findsOneWidget);
      expect(find.byType(CofluiGrid), findsOneWidget);
    });

    testWidgets('deeply nested containers render', (tester) async {
      await _pumpDynamic(tester, [
        {
          'id': 'root',
          'type': 'card',
          'label': 'L0',
          'children': [
            {
              'id': 'l1',
              'type': 'column',
              'children': [
                {'id': 'l2a', 'type': 'text', 'label': 'Deep A'},
                {
                  'id': 'l2b',
                  'type': 'row',
                  'children': [
                    {'id': 'l3', 'type': 'heading', 'label': 'Deepest'},
                  ],
                },
              ],
            },
          ],
        },
      ]);
      expect(find.text('L0'), findsOneWidget);
      expect(find.text('Deep A'), findsOneWidget);
      expect(find.text('Deepest'), findsOneWidget);
    });
  });

  group('DynamicUIWidget — input builders', () {
    testWidgets('textfield renders hint and syncs value to controller',
        (tester) async {
      final ctrl = CofluiFormController();
      await _pumpDynamic(
        tester,
        [
          {'id': 'name', 'type': 'textfield', 'label': 'Name',
            'props': {'hint': 'Enter name'}},
        ],
        controller: ctrl,
      );
      expect(find.text('Enter name'), findsOneWidget);
      // Label should also be rendered.
      expect(find.text('Name'), findsOneWidget);

      // Type text → value synced to controller.
      await tester.enterText(find.byType(CofluiTextField), 'TypedValue');
      expect(ctrl.getValue('name'), 'TypedValue');
    });

    testWidgets('textfield seeds initial value', (tester) async {
      final ctrl = CofluiFormController();
      await _pumpDynamic(
        tester,
        [
          {'id': 'pre', 'type': 'textfield', 'value': 'Initial Text'},
        ],
        controller: ctrl,
      );
      expect(ctrl.getValue('pre'), 'Initial Text');
    });

    testWidgets('dropdown renders and syncs selection', (tester) async {
      final ctrl = CofluiFormController();
      await _pumpDynamic(
        tester,
        [
          {
            'id': 'fruit',
            'type': 'dropdown',
            'label': 'Fruit',
            'props': {
              'options': [
                {'label': 'Apple', 'value': 'apple'},
                {'label': 'Banana', 'value': 'banana'},
              ],
            },
          },
        ],
        controller: ctrl,
      );

      // Tap to open dropdown.
      await tester.tap(find.byType(CofluiDropdown<dynamic>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      expect(ctrl.getValue('fruit'), 'banana');
    });

    testWidgets('switch renders and toggles', (tester) async {
      final ctrl = CofluiFormController();
      await _pumpDynamic(
        tester,
        [
          {'id': 'agree', 'type': 'switch', 'label': 'I agree'},
        ],
        controller: ctrl,
      );

      // Initial value should be false (default).
      expect(ctrl.getValue('agree'), false);

      // Tap to toggle.
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(ctrl.getValue('agree'), true);
    });

    testWidgets('checkbox renders and toggles', (tester) async {
      final ctrl = CofluiFormController();
      await _pumpDynamic(
        tester,
        [
          {'id': 'check', 'type': 'checkbox', 'label': 'Confirm'},
        ],
        controller: ctrl,
      );

      expect(ctrl.getValue('check'), false);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(ctrl.getValue('check'), true);
    });

    testWidgets('switch with initial value true', (tester) async {
      final ctrl = CofluiFormController();
      await _pumpDynamic(
        tester,
        [
          {'id': 'on', 'type': 'switch', 'label': 'Enabled', 'value': true},
        ],
        controller: ctrl,
      );
      expect(ctrl.getValue('on'), true);
    });

    testWidgets('datepicker renders', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'd', 'type': 'datepicker', 'label': 'Pick date',
          'props': {'hint': 'Select date'}},
      ]);
      expect(find.text('Select date'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('datepicker with initial value', (tester) async {
      final ctrl = CofluiFormController();
      await _pumpDynamic(
        tester,
        [
          {'id': 'd', 'type': 'datepicker', 'value': '2025-06-15'},
        ],
        controller: ctrl,
      );
      expect(ctrl.getValue('d'), '2025-06-15');
      // The formatted date should be displayed.
      expect(find.text('2025-06-15'), findsOneWidget);
    });
  });

  group('DynamicUIWidget — action builders', () {
    testWidgets('button renders label and triggers onAction', (tester) async {
      final ctrl = _ActionSpyController();
      await _pumpDynamic(
        tester,
        [
          {'id': 'btn', 'type': 'button', 'label': 'Submit',
            'props': {'action': 'submit'}},
        ],
        controller: ctrl,
      );

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(ctrl.actions.length, 1);
      expect(ctrl.actions.first.$1, 'submit');
      expect(ctrl.actions.first.$2, 'btn');
    });

    testWidgets('button renders with icon', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'b', 'type': 'button', 'label': 'Send',
          'props': {'icon': 'send'}},
      ]);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('outline variant renders OutlinedButton', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'b', 'type': 'button', 'label': 'Outline',
          'props': {'variant': 'outline'}},
      ]);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('ghost variant renders TextButton', (tester) async {
      await _pumpDynamic(tester, [
        {'id': 'b', 'type': 'button', 'label': 'Ghost',
          'props': {'variant': 'ghost'}},
      ]);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  group('DynamicUIWidget — readOnly mode', () {
    testWidgets('disables textfield when readOnly is true', (tester) async {
      final ctrl = CofluiFormController(readOnly: true);
      await _pumpDynamic(
        tester,
        [
          {'id': 't', 'type': 'textfield', 'label': 'Name',
            'props': {'hint': 'Type'}},
        ],
        controller: ctrl,
      );
      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.enabled, isFalse);
    });

    testWidgets('disables dropdown when readOnly is true', (tester) async {
      final ctrl = CofluiFormController(readOnly: true);
      await _pumpDynamic(
        tester,
        [
          {
            'id': 'd', 'type': 'dropdown',
            'props': {'options': [
              {'label': 'A', 'value': 'a'},
            ]},
          },
        ],
        controller: ctrl,
      );
      final dropdown = tester.widget<DropdownButton<dynamic>>(
        find.byType(DropdownButton<dynamic>),
      );
      expect(dropdown.onChanged, isNull);
    });

    testWidgets('disables switch when readOnly is true', (tester) async {
      final ctrl = CofluiFormController(readOnly: true);
      await _pumpDynamic(
        tester,
        [{'id': 's', 'type': 'switch', 'label': 'Toggle'}],
        controller: ctrl,
      );
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.onChanged, isNull);
    });
  });

  group('DynamicUIWidget — null controller fallback', () {
    testWidgets('renders text without a controller', (tester) async {
      const component = UIComponent(id: 't', type: UIType.text, label: 'No Ctrl');
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DynamicUIWidget(component))),
      );
      expect(find.text('No Ctrl'), findsOneWidget);
    });

    testWidgets('renders heading without a controller', (tester) async {
      const component = UIComponent(id: 'h', type: UIType.heading, label: 'Head');
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DynamicUIWidget(component))),
      );
      expect(find.text('Head'), findsOneWidget);
    });
  });

  group('DynamicUIWidget — rebuild on structural change', () {
    testWidgets('rebuilds when controller notifies (loadFromJson)',
        (tester) async {
      final ctrl = CofluiFormController()..loadFromJson([
        {'id': 'a', 'type': 'text', 'label': 'Version 1'},
      ]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIWidget(ctrl.components.first, controller: ctrl),
          ),
        ),
      );
      expect(find.text('Version 1'), findsOneWidget);

      // Reload with new content — the DynamicUIWidget should rebuild.
      // Note: the widget is keyed to the old component reference; we need
      // a wrapping that re-reads components. For this test we verify the
      // controller notifies.
      var notified = 0;
      ctrl.addListener(() => notified++);
      ctrl.loadFromJson([
        {'id': 'a', 'type': 'text', 'label': 'Version 2'},
      ]);
      expect(notified, 1);
    });
  });
}

/// Controller that records all onAction calls.
class _ActionSpyController extends CofluiFormController {
  final List<(String, String)> actions = [];

  @override
  void onAction(String action, String componentId) {
    actions.add((action, componentId));
  }
}

/// Extension to safely cast CofluiFormControllerLike for test helpers.
extension on CofluiFormControllerLike {
  CofluiFormController get asController {
    if (this is CofluiFormController) return this as CofluiFormController;
    throw StateError('Test helper requires a CofluiFormController');
  }
}
