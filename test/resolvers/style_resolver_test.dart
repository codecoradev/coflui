import 'package:coflui/src/dynamic/models/ui_style.dart';
import 'package:coflui/src/dynamic/resolvers/style_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StyleResolver.padding', () {
    test('uniform padding', () {
      const s = UIStyle(padding: 16);
      expect(StyleResolver.padding(s), const EdgeInsets.symmetric(
        horizontal: 16, vertical: 16,
      ));
    });

    test('axis-specific overrides uniform', () {
      const s = UIStyle(padding: 10, paddingHorizontal: 20, paddingVertical: 5);
      expect(StyleResolver.padding(s), const EdgeInsets.symmetric(
        horizontal: 20, vertical: 5,
      ));
    });

    test('null padding returns zero', () {
      const s = UIStyle.empty;
      expect(StyleResolver.padding(s), EdgeInsets.zero);
    });
  });

  group('StyleResolver.radius', () {
    test('returns style radius when present', () {
      const s = UIStyle(radius: 12);
      expect(StyleResolver.radius(s), 12.0);
    });

    test('returns fallback when null', () {
      const s = UIStyle.empty;
      expect(StyleResolver.radius(s, 8), 8.0);
      expect(StyleResolver.radius(s), 0.0);
    });
  });

  group('StyleResolver.align', () {
    test('left / start → centerLeft', () {
      expect(StyleResolver.align(const UIStyle(align: 'left')),
          Alignment.centerLeft);
      expect(StyleResolver.align(const UIStyle(align: 'start')),
          Alignment.centerLeft);
    });

    test('right / end → centerRight', () {
      expect(StyleResolver.align(const UIStyle(align: 'right')),
          Alignment.centerRight);
      expect(StyleResolver.align(const UIStyle(align: 'end')),
          Alignment.centerRight);
    });

    test('center → center', () {
      expect(StyleResolver.align(const UIStyle(align: 'center')),
          Alignment.center);
    });

    test('justify → centerLeft', () {
      expect(StyleResolver.align(const UIStyle(align: 'justify')),
          Alignment.centerLeft);
    });

    test('falls back to provided default', () {
      expect(StyleResolver.align(UIStyle.empty, Alignment.center),
          Alignment.center);
    });

    test('default is centerLeft', () {
      expect(StyleResolver.align(UIStyle.empty),
          Alignment.centerLeft);
    });
  });

  group('StyleResolver.textAlign', () {
    test('left/start → TextAlign.start', () {
      expect(StyleResolver.textAlign(const UIStyle(align: 'left')),
          TextAlign.start);
    });

    test('right/end → TextAlign.end', () {
      expect(StyleResolver.textAlign(const UIStyle(align: 'right')),
          TextAlign.end);
    });

    test('center → TextAlign.center', () {
      expect(StyleResolver.textAlign(const UIStyle(align: 'center')),
          TextAlign.center);
    });

    test('justify → TextAlign.justify', () {
      expect(StyleResolver.textAlign(const UIStyle(align: 'justify')),
          TextAlign.justify);
    });

    test('default fallback', () {
      expect(StyleResolver.textAlign(UIStyle.empty),
          TextAlign.start);
      expect(StyleResolver.textAlign(UIStyle.empty, TextAlign.center),
          TextAlign.center);
    });
  });

  group('StyleResolver.crossAxis', () {
    test('maps all named values', () {
      expect(StyleResolver.crossAxis(const UIStyle(crossAxis: 'start')),
          CrossAxisAlignment.start);
      expect(StyleResolver.crossAxis(const UIStyle(crossAxis: 'center')),
          CrossAxisAlignment.center);
      expect(StyleResolver.crossAxis(const UIStyle(crossAxis: 'end')),
          CrossAxisAlignment.end);
      expect(StyleResolver.crossAxis(const UIStyle(crossAxis: 'stretch')),
          CrossAxisAlignment.stretch);
    });

    test('default is stretch', () {
      expect(StyleResolver.crossAxis(UIStyle.empty),
          CrossAxisAlignment.stretch);
    });
  });

  group('StyleResolver.mainAxis', () {
    test('maps all named values', () {
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'start')),
          MainAxisAlignment.start);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'center')),
          MainAxisAlignment.center);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'end')),
          MainAxisAlignment.end);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'spaceBetween')),
          MainAxisAlignment.spaceBetween);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'space_between')),
          MainAxisAlignment.spaceBetween);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'spaceAround')),
          MainAxisAlignment.spaceAround);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'space_around')),
          MainAxisAlignment.spaceAround);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'spaceEvenly')),
          MainAxisAlignment.spaceEvenly);
      expect(StyleResolver.mainAxis(const UIStyle(mainAxis: 'space_evenly')),
          MainAxisAlignment.spaceEvenly);
    });

    test('default is start', () {
      expect(StyleResolver.mainAxis(UIStyle.empty),
          MainAxisAlignment.start);
    });

    test('falls back to provided default', () {
      expect(StyleResolver.mainAxis(UIStyle.empty, MainAxisAlignment.center),
          MainAxisAlignment.center);
    });
  });

  group('StyleResolver.box', () {
    test('returns null when no box-related style', () {
      expect(StyleResolver.box(UIStyle.empty), isNull);
    });

    test('builds decoration with bgColor only', () {
      const s = UIStyle(bgColor: Colors.red, radius: 8);
      final box = StyleResolver.box(s);
      expect(box, isNotNull);
      expect(box!.color, Colors.red);
      expect(box.border, isNull);
    });

    test('builds decoration with border only', () {
      const s = UIStyle(borderColor: Colors.blue, borderWidth: 2);
      final box = StyleResolver.box(s);
      expect(box, isNotNull);
      expect(box!.border, isNotNull);
    });

    test('zero borderWidth → no border', () {
      const s = UIStyle(borderColor: Colors.blue, borderWidth: 0);
      final box = StyleResolver.box(s);
      expect(box, isNull); // no bgColor, no radius → null
    });

    test('builds decoration with radius only', () {
      const s = UIStyle(radius: 12);
      final box = StyleResolver.box(s);
      expect(box, isNotNull);
    });

    test('full decoration', () {
      const s = UIStyle(
        bgColor: Colors.white,
        borderColor: Colors.grey,
        borderWidth: 1,
        radius: 14,
      );
      final box = StyleResolver.box(s);
      expect(box, isNotNull);
      expect(box!.color, Colors.white);
      expect(box.border!.top.width, 1);
    });
  });

  group('StyleResolver.textStyle', () {
    testBuilderWidget('merges style into base text theme', (tester) async {
      late TextStyle captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              captured = StyleResolver.textStyle(
                const UIStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ctx,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured.fontSize, 20);
      expect(captured.fontWeight, FontWeight.bold);
    });

    testBuilderWidget('uses provided base style', (tester) async {
      late TextStyle captured;
      const base = TextStyle(color: Colors.red, fontSize: 10);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              captured = StyleResolver.textStyle(
                const UIStyle(fontSize: 22),
                ctx,
                base: base,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured.fontSize, 22);
      expect(captured.color, Colors.red); // from base
    });

    testBuilderWidget('italic fontStyle', (tester) async {
      late TextStyle captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              captured = StyleResolver.textStyle(
                const UIStyle(fontStyle: 'italic'),
                ctx,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured.fontStyle, FontStyle.italic);
    });
  });
}

/// Helper: wrap a test in a widget pump so we have a BuildContext.
void testBuilderWidget(
  String description,
  Future<void> Function(WidgetTester) body,
) {
  testWidgets(description, body);
}
