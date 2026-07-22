import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Wrap content in a sized box to avoid unbounded layout for full-width widgets.
  Future<void> pump(WidgetTester t, Widget child) => t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 400, child: child),
            ),
          ),
        ),
      );

  group('CofluiButton — isLoading', () {
    testWidgets('shows a spinner when loading and disables press', (tester) async {
      var tapped = 0;
      await pump(
        tester,
        CofluiButton(
          label: 'Submit',
          isLoading: true,
          onPressed: () => tapped++,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(tapped, 0, reason: 'should be disabled while loading');
    });

    testWidgets('shows label and fires press when not loading', (tester) async {
      var tapped = 0;
      await pump(
        tester,
        CofluiButton(
          label: 'Submit',
          onPressed: () => tapped++,
        ),
      );
      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(tapped, 1);
    });
  });

  group('CofluiTextField — new params', () {
    testWidgets('renders label as labelText', (tester) async {
      await pump(
        tester,
        const CofluiTextField(label: 'Email', hint: 'you@x.com'),
      );
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders prefix and suffix icons', (tester) async {
      await pump(
        tester,
        CofluiTextField(
          hint: 'search',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.clear),
        ),
      );
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('reports a validation error', (tester) async {
      final formKey = GlobalKey<FormState>();
      await pump(
        tester,
        Form(
          key: formKey,
          child: CofluiTextField(
            validator: (v) =>
                (v == null || v.isEmpty) ? 'required' : null,
          ),
        ),
      );
      expect(formKey.currentState!.validate(), isFalse);
    });
  });

  group('CofluiListTile', () {
    testWidgets('renders title + subtitle + leading + trailing', (tester) async {
      await pump(
        tester,
        CofluiListTile(
          title: 'Budi',
          subtitle: 'Approved',
          leading: const Icon(Icons.person),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
      expect(find.text('Budi'), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = 0;
      await pump(
        tester,
        CofluiListTile(
          title: 'Tap me',
          onTap: () => tapped++,
        ),
      );
      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(tapped, 1);
    });
  });

  group('CofluiDetailRow', () {
    testWidgets('renders icon + label + value', (tester) async {
      await pump(
        tester,
        CofluiDetailRow(
          icon: const Icon(Icons.calendar_today),
          label: 'Date',
          value: '2026-07-22',
        ),
      );
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('2026-07-22'), findsOneWidget);
    });

    testWidgets('renders without icon when icon is null', (tester) async {
      await pump(
        tester,
        const CofluiDetailRow(label: 'No Icon', value: 'value'),
      );
      expect(find.text('No Icon'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('accepts a CofluiIcon (any source) as icon', (tester) async {
      await pump(
        tester,
        const CofluiDetailRow(
          icon: CofluiIcon.icon(Icons.star, size: 20),
          label: 'Rating',
          value: '5.0',
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('applies valueColor when provided', (tester) async {
      await pump(
        tester,
        const CofluiDetailRow(
          icon: Icon(Icons.check),
          label: 'Status',
          value: 'OK',
          valueColor: Colors.green,
        ),
      );
      final value = tester.widget<Text>(find.text('OK'));
      expect(value.style?.color, Colors.green);
    });
  });

  group('CofluiGradientBar', () {
    testWidgets('renders a container with gradient + height', (tester) async {
      await pump(
        tester,
        const CofluiGradientBar(height: 8, gradient: 'accent'),
      );
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      expect(container.constraints?.maxHeight, 8);
    });
  });

  group('CofluiGradients presets', () {
    test('accent/cool/warm are distinct gradients', () {
      final accentColors =
          (CofluiGradients.accent as LinearGradient).colors;
      final coolColors = (CofluiGradients.cool as LinearGradient).colors;
      final warmColors = (CofluiGradients.warm as LinearGradient).colors;
      expect(accentColors, isNot(equals(coolColors)));
      expect(accentColors, isNot(equals(warmColors)));
      expect(warmColors, isNot(equals(coolColors)));
    });

    test('presetOf resolves names by value', () {
      // Gradients are getters (new instance per call) so compare colors, not
      // identity.
      List<Color> colorsOf(Gradient g) => (g as LinearGradient).colors;
      expect(colorsOf(CofluiGradients.presetOf('accent')),
          equals(colorsOf(CofluiGradients.accent)));
      expect(colorsOf(CofluiGradients.presetOf('cool')),
          equals(colorsOf(CofluiGradients.cool)));
      expect(colorsOf(CofluiGradients.presetOf('warm')),
          equals(colorsOf(CofluiGradients.warm)));
      // Unknown → defaults to accent.
      expect(colorsOf(CofluiGradients.presetOf('nope')),
          equals(colorsOf(CofluiGradients.accent)));
    });
  });
}
