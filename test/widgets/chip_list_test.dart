import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester t, Widget child) => t.pumpWidget(
        MaterialApp(home: Scaffold(body: Center(child: child))),
      );

  group('CofluiChip — variants', () {
    testWidgets('neutral renders label', (tester) async {
      await pump(tester, const CofluiChip('Draft'));
      expect(find.text('Draft'), findsOneWidget);
    });

    testWidgets('success variant has green-tinted background', (tester) async {
      await pump(tester, const CofluiChip('Approved', variant: CofluiChipVariant.success));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      // Green tint → hue near accentGreen
      expect(decoration.color, isNotNull);
      expect(decoration.color!.green, greaterThan(decoration.color!.red));
    });

    testWidgets('renders leading icon when provided', (tester) async {
      await pump(
        tester,
        const CofluiChip('3', variant: CofluiChipVariant.info, icon: Icons.attach_file),
      );
      expect(find.byIcon(Icons.attach_file), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('CofluiChip — builder (dynamic UI)', () {
    setUpAll(DynamicUIBootstrap.registerDefaults);

    testWidgets('chip type renders from JSON', (tester) async {
      final ctrl = CofluiFormController()..loadFromJson([
        {'id': 'c', 'type': 'chip', 'props': {'label': 'Pending', 'variant': 'warning'}},
      ]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIWidget(ctrl.components.first, controller: ctrl),
          ),
        ),
      );
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('list type repeats child template over items', (tester) async {
      final ctrl = CofluiFormController()..loadFromJson([
        {
          'id': 'people',
          'type': 'list',
          'props': {
            'items': [
              {'name': 'Andi', 'role': 'Manager'},
              {'name': 'Maya', 'role': 'Finance'},
              {'name': 'Rian', 'role': 'Director'},
            ],
          },
          'children': [
            {'type': 'text', 'value': '{name} — {role}'},
          ],
        },
      ]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicUIWidget(ctrl.components.first, controller: ctrl),
            ),
          ),
        ),
      );
      expect(find.text('Andi — Manager'), findsOneWidget);
      expect(find.text('Maya — Finance'), findsOneWidget);
      expect(find.text('Rian — Director'), findsOneWidget);
    });

    testWidgets('list renders emptyText when items is empty', (tester) async {
      final ctrl = CofluiFormController()..loadFromJson([
        {
          'id': 'empty',
          'type': 'list',
          'props': {'items': [], 'emptyText': 'No approvers yet'},
          'children': [
            {'type': 'text', 'value': '{name}'},
          ],
        },
      ]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicUIWidget(ctrl.components.first, controller: ctrl),
          ),
        ),
      );
      expect(find.text('No approvers yet'), findsOneWidget);
    });

    testWidgets('list binds nested props (list_tile title from item)', (tester) async {
      final ctrl = CofluiFormController()..loadFromJson([
        {
          'id': 'rows',
          'type': 'list',
          'props': {
            'items': [
              {'title': 'First', 'subtitle': 'A'},
              {'title': 'Second', 'subtitle': 'B'},
            ],
          },
          'children': [
            {
              'type': 'list_tile',
              'props': {'title': '{title}', 'subtitle': '{subtitle}'},
            },
          ],
        },
      ]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicUIWidget(ctrl.components.first, controller: ctrl),
            ),
          ),
        ),
      );
      expect(find.text('First'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    test('registration: chip + list types are registered', () {
      for (final type in [UIType.chip, UIType.list]) {
        expect(WidgetRegistry.isRegistered(type), isTrue,
            reason: '$type should be registered');
      }
    });
  });
}
