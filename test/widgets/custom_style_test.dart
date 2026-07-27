import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester t, Widget child) => t.pumpWidget(
        MaterialApp(home: Scaffold(body: Center(child: child))),
      );

  group('CofluiCard — borderless & custom', () {
    testWidgets('default card has a border', (tester) async {
      await pump(tester, const CofluiCard(child: SizedBox(width: 10, height: 10)));
      final container = tester.widget<Container>(find.byType(Container).first);
      final deco = container.decoration as BoxDecoration;
      expect(deco.border, isNotNull, reason: 'default card should have a border');
    });

    testWidgets('borderless card has no border', (tester) async {
      await pump(tester,
          const CofluiCard(borderless: true, child: SizedBox(width: 10, height: 10)));
      final container = tester.widget<Container>(find.byType(Container).first);
      final deco = container.decoration as BoxDecoration;
      expect(deco.border, isNull, reason: 'borderless card should have no border');
    });

    testWidgets('borderWidth 0 also removes border', (tester) async {
      await pump(tester,
          const CofluiCard(borderWidth: 0, child: SizedBox(width: 10, height: 10)));
      final container = tester.widget<Container>(find.byType(Container).first);
      final deco = container.decoration as BoxDecoration;
      expect(deco.border, isNull);
    });

    testWidgets('gradient prop paints background with gradient', (tester) async {
      await pump(
        tester,
        CofluiCard(
          gradient: CofluiGradients.accent,
          child: const SizedBox(width: 10, height: 10),
        ),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      final deco = container.decoration as BoxDecoration;
      expect(deco.gradient, isA<LinearGradient>());
      expect(deco.color, isNull, reason: 'color must yield to gradient');
    });

    testWidgets('maxWidth prop is accepted without throw', (tester) async {
      await pump(
        tester,
        const CofluiCard(
          maxWidth: 200,
          child: SizedBox(width: 10, height: 10),
        ),
      );
      // Just verify it renders with maxWidth set (no assert / layout error).
      expect(find.byType(CofluiCard), findsOneWidget);
    });
  });

  group('CofluiButton — custom style overrides', () {
    testWidgets('backgroundColor override takes precedence', (tester) async {
      await pump(
        tester,
        CofluiButton(
          label: 'Custom',
          backgroundColor: Colors.purple,
          foregroundColor: Colors.yellow,
          onPressed: () {},
        ),
      );
      // Find the FilledButton and inspect its style.
      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      final bg = btn.style?.backgroundColor?.resolve({})!;
      expect(bg, Colors.purple);
    });

    testWidgets('outline border color + width honored', (tester) async {
      await pump(
        tester,
        CofluiButton(
          label: 'Outline',
          variant: CofluiButtonVariant.outline,
          borderColor: Colors.red,
          borderWidth: 2.5,
          onPressed: () {},
        ),
      );
      final btn = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final side = btn.style?.side?.resolve({});
      expect(side?.color, Colors.red);
      expect(side?.width, 2.5);
    });

    testWidgets('minWidth + fixedHeight applied', (tester) async {
      await pump(
        tester,
        CofluiButton(
          label: 'X',
          minWidth: 120,
          fixedHeight: 56,
          onPressed: () {},
        ),
      );
      final btn = tester.getSize(find.byType(FilledButton));
      expect(btn.width, greaterThanOrEqualTo(120));
      expect(btn.height, greaterThanOrEqualTo(56));
    });
  });

  group('CofluiListTile — elevation + border', () {
    testWidgets('elevation prop is accepted (no throw)', (tester) async {
      await pump(
        tester,
        const CofluiListTile(title: 'T', elevation: 4),
      );
      expect(find.text('T'), findsOneWidget);
      // Use the LAST Material in the tree (the first is Scaffold's).
      final material = tester.widget<Material>(find.byType(Material).last);
      expect(material.elevation, 4);
    });

    testWidgets('border renders when borderWidth > 0', (tester) async {
      await pump(
        tester,
        const CofluiListTile(
          title: 'T',
          borderWidth: 2,
          borderColor: Color(0xFFFF0000),
        ),
      );
      final containers = tester.widgetList<Container>(find.byType(Container));
      // Find the innermost container with a decoration.
      final withDeco = containers.where((c) => c.decoration is BoxDecoration);
      expect(withDeco, isNotEmpty);
      final deco = (withDeco.last.decoration) as BoxDecoration;
      expect(deco.border, isNotNull);
    });
  });

  group('CofluiChip — style overrides', () {
    testWidgets('fontSize + iconSize honored', (tester) async {
      await pump(
        tester,
        const CofluiChip(
          'Big',
          icon: Icons.star,
          fontSize: 20,
          iconSize: 24,
        ),
      );
      final text = tester.widget<Text>(find.text('Big'));
      expect(text.style?.fontSize, 20);
      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 24);
    });
  });
}
