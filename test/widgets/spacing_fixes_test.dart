import 'dart:ui';

import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester t, List<Map<String, dynamic>> json) async {
  final ctrl = CofluiFormController()..loadFromJson(json);
  await t.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (final c in ctrl.components)
                DynamicUIWidget(c, controller: ctrl),
            ],
          ),
        ),
      ),
    ),
  );
}

Map<String, dynamic> _text(String id, String label,
        [Map<String, dynamic>? style]) =>
    {
      'id': id,
      'type': 'text',
      'label': label,
      if (style != null) 'style': style
    };

void main() {
  setUpAll(DynamicUIBootstrap.registerDefaults);

  group('card padding', () {
    testWidgets('default padding stays 14 (+1 border)', (t) async {
      await _pump(t, [
        {
          'id': 'c',
          'type': 'card',
          'children': [_text('x', 'hello')]
        },
      ]);
      expect(t.getRect(find.text('hello')).left, 15);
    });

    testWidgets('style.padding is honored', (t) async {
      await _pump(t, [
        {
          'id': 'c',
          'type': 'card',
          'style': {'padding': 40},
          'children': [_text('x', 'hello')],
        },
      ]);
      expect(t.getRect(find.text('hello')).left, 41);
    });

    testWidgets('paddingHorizontal wins over padding', (t) async {
      await _pump(t, [
        {
          'id': 'c',
          'type': 'card',
          'style': {'padding': 40, 'paddingHorizontal': 4},
          'children': [_text('x', 'hello')],
        },
      ]);
      expect(t.getRect(find.text('hello')).left, 5);
    });
  });

  group('card titleGap', () {
    Future<double> titleToBody(
        WidgetTester t, Map<String, dynamic> extra) async {
      await _pump(t, [
        {
          'id': 'c',
          'type': 'card',
          'label': 'Title',
          ...extra,
          'children': [_text('x', 'Body')],
        },
      ]);
      return t.getRect(find.text('Body')).top -
          t.getRect(find.text('Title')).bottom;
    }

    testWidgets('defaults to 10', (t) async {
      expect(await titleToBody(t, {}), 10);
    });

    testWidgets('style.gap still drives it (backwards compatible)', (t) async {
      expect(
          await titleToBody(t, {
            'style': {'gap': 4}
          }),
          4);
    });

    testWidgets('props.titleGap decouples it from gap', (t) async {
      expect(
        await titleToBody(t, {
          'style': {'gap': 4},
          'props': {'titleGap': 20},
        }),
        20,
      );
    });
  });

  group('blank text children', () {
    double aToB(WidgetTester t) =>
        t.getRect(find.text('B')).top - t.getRect(find.text('A')).top;

    testWidgets('empty text is skipped in column', (t) async {
      await _pump(t, [
        {
          'id': 'c',
          'type': 'column',
          'style': {'gap': 10},
          'children': [_text('a', 'A'), _text('e', ''), _text('b', 'B')],
        },
      ]);
      final withBlank = aToB(t);
      await _pump(t, [
        {
          'id': 'c',
          'type': 'column',
          'style': {'gap': 10},
          'children': [_text('a', 'A'), _text('b', 'B')],
        },
      ]);
      expect(withBlank, aToB(t));
    });

    testWidgets('empty text is skipped in card', (t) async {
      await _pump(t, [
        {
          'id': 'c',
          'type': 'card',
          'children': [_text('a', 'A'), _text('e', ''), _text('b', 'B')],
        },
      ]);
      expect(aToB(t), 30); // 20 line + 10 gap, no phantom 30px
    });

    testWidgets('blank text with paddingVertical is kept as a spacer',
        (t) async {
      await _pump(t, [
        {
          'id': 'c',
          'type': 'column',
          'children': [
            _text('a', 'A'),
            _text('e', '', {'paddingVertical': 12}),
            _text('b', 'B'),
          ],
        },
      ]);
      // Kept (not skipped): A→B spans two lines (40), not one (20).
      expect(aToB(t), 40);
    });
  });

  group('heading paddingTop', () {
    Future<double> top(WidgetTester t, Map<String, dynamic> props) async {
      await _pump(t, [
        {'id': 'h', 'type': 'heading', 'label': 'Head', 'props': props},
      ]);
      return t.getRect(find.text('Head')).top;
    }

    testWidgets('defaults to 4', (t) async => expect(await top(t, {}), 4));
    testWidgets('props.paddingTop overrides', (t) async {
      expect(await top(t, {'paddingTop': 0}), 0);
      expect(await top(t, {'paddingTop': 12}), 12);
    });
  });

  group('accessibility', () {
    testWidgets('checkbox exposes its label', (t) async {
      final h = t.ensureSemantics();
      await _pump(t, [
        {'id': 'k', 'type': 'checkbox', 'label': 'Setuju'},
      ]);
      final data = t.getSemantics(find.byType(Checkbox)).getSemanticsData();
      expect(data.label, 'Setuju');
      h.dispose();
    });

    testWidgets('tappable chip is a labelled button', (t) async {
      final h = t.ensureSemantics();
      await _pump(t, [
        {
          'id': 'ch',
          'type': 'chip',
          'props': {'label': 'Tap', 'action': 'go'},
        },
      ]);
      final data = t.getSemantics(find.byType(CofluiChip)).getSemanticsData();
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.label, 'Tap');
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      h.dispose();
    });
  });
}
