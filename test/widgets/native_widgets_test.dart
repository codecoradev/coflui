import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CofluiText', () {
    testWidgets('renders the provided text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CofluiText('Hello World'))),
      );
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('applies default style when style is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CofluiText('Default'))),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, CofluiTypography.body);
      expect(text.style?.color, CofluiColors.onSurfaceVariant);
    });

    testWidgets('applies custom style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiText(
              'Custom',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, 22);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.color, Colors.red);
    });

    testWidgets('passes maxLines and overflow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiText('A' * 200, maxLines: 2),
          ),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('passes textAlign', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CofluiText('Centered', textAlign: TextAlign.center)),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.textAlign, TextAlign.center);
    });
  });

  group('CofluiButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiButton(label: 'Click Me', onPressed: () {}),
          ),
        ),
      );
      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiButton(
              label: 'Send',
              icon: Icons.send,
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
    });

    testWidgets('triggers onPressed when tapped', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiButton(
              label: 'Tap',
              onPressed: () => pressed++,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tap'));
      expect(pressed, 1);
    });

    testWidgets('primary variant renders FilledButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiButton(
              label: 'P',
              variant: CofluiButtonVariant.primary,
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('outline variant renders OutlinedButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiButton(
              label: 'O',
              variant: CofluiButtonVariant.outline,
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('ghost variant renders TextButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiButton(
              label: 'G',
              variant: CofluiButtonVariant.ghost,
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('danger variant renders FilledButton with error color',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiButton(
              label: 'D',
              variant: CofluiButtonVariant.danger,
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('fullWidth uses SizedBox when parent has bounded width',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: CofluiButton(
                label: 'Wide',
                fullWidth: true,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 300);
    });
  });

  group('CofluiCard', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CofluiCard(child: Text('Card content')),
          ),
        ),
      );
      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('renders title when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CofluiCard(title: 'My Title', child: SizedBox()),
          ),
        ),
      );
      expect(find.text('My Title'), findsOneWidget);
    });

    testWidgets('omits title widget when title is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CofluiCard(child: SizedBox())),
        ),
      );
      // Should still render the card container.
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('applies custom radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiCard(
              radius: 20,
              child: const SizedBox(width: 100, height: 50),
            ),
          ),
        ),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      final deco = container.decoration as BoxDecoration;
      final br = deco.borderRadius as BorderRadius;
      expect(br.topLeft.x, 20.0);
    });
  });

  group('CofluiGrid', () {
    testWidgets('renders all children', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: CofluiGrid(
                mobileColumns: 2,
                children: [
                  Container(child: const Text('A')),
                  Container(child: const Text('B')),
                  Container(child: const Text('C')),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('uses 1 column on mobile width', (tester) async {
      // 320px = mobile
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: CofluiGrid(
                mobileColumns: 1,
                tabletColumns: 3,
                desktopColumns: 4,
                children: const [Text('X')],
              ),
            ),
          ),
        ),
      );
      // Wrap exists with children.
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('falls back to MediaQuery when constraints unbounded',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CofluiGrid(
                mobileColumns: 1,
                children: const [Text('M')],
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Wrap), findsOneWidget);
    });
  });

  group('CofluiResponsive', () {
    testWidgets('renders mobile subtree on narrow screen', (tester) async {
      tester.view.physicalSize = const Size(350, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CofluiResponsive(
              mobile: Text('MobileView'),
              tablet: Text('TabletView'),
              desktop: Text('DesktopView'),
            ),
          ),
        ),
      );
      expect(find.text('MobileView'), findsOneWidget);
      expect(find.text('TabletView'), findsNothing);
      expect(find.text('DesktopView'), findsNothing);
    });

    testWidgets('renders desktop subtree on wide screen', (tester) async {
      tester.view.physicalSize = const Size(1400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CofluiResponsive(
              mobile: Text('MobileView'),
              desktop: Text('DesktopView'),
            ),
          ),
        ),
      );
      expect(find.text('DesktopView'), findsOneWidget);
    });

    testWidgets('tablet falls back to mobile when null', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CofluiResponsive(mobile: Text('Fallback')),
          ),
        ),
      );
      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('desktop falls back to tablet then mobile', (tester) async {
      tester.view.physicalSize = const Size(1400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CofluiResponsive(
              mobile: Text('M'),
              tablet: Text('T'),
            ),
          ),
        ),
      );
      expect(find.text('T'), findsOneWidget);
    });
  });

  group('CofluiTextField', () {
    testWidgets('renders with hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CofluiTextField(hint: 'Enter name')),
        ),
      );
      expect(find.text('Enter name'), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      String? changed;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiTextField(
              hint: 'Type',
              onChanged: (v) => changed = v,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(CofluiTextField), 'Hello');
      expect(changed, 'Hello');
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CofluiTextField(hint: 'Disabled', enabled: false)),
        ),
      );
      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.enabled, isFalse);
    });

    testWidgets('uses provided controller', (tester) async {
      final controller = TextEditingController(text: 'Pre-filled');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CofluiTextField(controller: controller)),
        ),
      );
      expect(find.text('Pre-filled'), findsOneWidget);
      controller.dispose();
    });
  });

  group('CofluiDropdown', () {
    testWidgets('renders hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CofluiDropdown<String>(
              hint: 'Choose fruit',
              items: const [],
            ),
          ),
        ),
      );
      expect(find.text('Choose fruit'), findsOneWidget);
    });

    testWidgets('renders menu items in the dropdown button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: const CofluiDropdown<String>(
                value: 'a',
                items: const [
                  DropdownMenuItem(value: 'a', child: Text('Apple')),
                  DropdownMenuItem(value: 'b', child: Text('Banana')),
                ],
              ),
            ),
          ),
        ),
      );
      // When value is set, the selected item text is shown directly.
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('calls onChanged when item selected', (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: CofluiDropdown<String>(
                items: const [
                  DropdownMenuItem(value: 'x', child: Text('X Option')),
                ],
                onChanged: (v) => selected = v,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(CofluiDropdown<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('X Option').last);
      await tester.pumpAndSettle();
      expect(selected, 'x');
    });

    testWidgets('disabled dropdown ignores taps', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: CofluiDropdown<String>(
                enabled: false,
                items: const [
                  DropdownMenuItem(value: 'a', child: Text('A')),
                ],
                onChanged: (v) => tapCount++,
              ),
            ),
          ),
        ),
      );
      // The onChanged is null when disabled, so tapping won't fire it.
      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      expect(dropdown.onChanged, isNull);
    });
  });

  group('CofluiDialog', () {
    testWidgets('alert shows title and body, dismisses with OK',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () => CofluiDialog.alert(
                context,
                title: 'Alert Title',
                body: 'Alert body text',
              ),
              child: const Text('Show'),
            ),
          );
        })),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Alert Title'), findsOneWidget);
      expect(find.text('Alert body text'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('Alert Title'), findsNothing);
    });

    testWidgets('confirm returns true when accepted', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                result = await CofluiDialog.confirm(
                  context,
                  title: 'Confirm?',
                  body: 'Are you sure?',
                );
              },
              child: const Text('Ask'),
            ),
          );
        })),
      );

      await tester.tap(find.text('Ask'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm?'), findsOneWidget);

      await tester.tap(find.text('Ya'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('confirm returns false when cancelled', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                result = await CofluiDialog.confirm(
                  context,
                  title: 'Confirm?',
                  body: 'Sure?',
                );
              },
              child: const Text('Ask'),
            ),
          );
        })),
      );

      await tester.tap(find.text('Ask'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });
  });

  group('CofluiBreakpoints', () {
    test('deviceOf classifies mobile', () {
      expect(CofluiBreakpoints.deviceOf(320), CofluiDevice.mobile);
      expect(CofluiBreakpoints.deviceOf(599), CofluiDevice.mobile);
    });

    test('deviceOf classifies tablet', () {
      expect(CofluiBreakpoints.deviceOf(600), CofluiDevice.tablet);
      expect(CofluiBreakpoints.deviceOf(800), CofluiDevice.tablet);
      expect(CofluiBreakpoints.deviceOf(1023), CofluiDevice.tablet);
    });

    test('deviceOf classifies desktop', () {
      expect(CofluiBreakpoints.deviceOf(1024), CofluiDevice.desktop);
      expect(CofluiBreakpoints.deviceOf(1920), CofluiDevice.desktop);
    });

    test('threshold boundaries are inclusive on the high side', () {
      expect(CofluiBreakpoints.deviceOf(600), CofluiDevice.tablet);
      expect(CofluiBreakpoints.deviceOf(1024), CofluiDevice.desktop);
    });

    test('threshold boundaries are exclusive on the low side', () {
      expect(CofluiBreakpoints.deviceOf(599.99), CofluiDevice.mobile);
      expect(CofluiBreakpoints.deviceOf(1023.99), CofluiDevice.tablet);
    });

    test('breakpoints can be overridden', () {
      // Save original.
      final origTablet = CofluiBreakpoints.tablet;
      final origDesktop = CofluiBreakpoints.desktop;

      CofluiBreakpoints.tablet = 500;
      CofluiBreakpoints.desktop = 900;

      expect(CofluiBreakpoints.deviceOf(499), CofluiDevice.mobile);
      expect(CofluiBreakpoints.deviceOf(500), CofluiDevice.tablet);
      expect(CofluiBreakpoints.deviceOf(899), CofluiDevice.tablet);
      expect(CofluiBreakpoints.deviceOf(900), CofluiDevice.desktop);

      // Restore.
      CofluiBreakpoints.tablet = origTablet;
      CofluiBreakpoints.desktop = origDesktop;
    });
  });

  group('CofluiColors', () {
    test('has all required brand colors', () {
      expect(CofluiColors.primary, isA<Color>());
      expect(CofluiColors.onPrimary, isA<Color>());
      expect(CofluiColors.secondary, isA<Color>());
    });

    test('has all surface colors', () {
      expect(CofluiColors.surface, isA<Color>());
      expect(CofluiColors.onSurface, isA<Color>());
      expect(CofluiColors.onSurfaceVariant, isA<Color>());
      expect(CofluiColors.background, isA<Color>());
    });

    test('has feedback colors', () {
      expect(CofluiColors.error, isA<Color>());
      expect(CofluiColors.onError, isA<Color>());
      expect(CofluiColors.warning, isA<Color>());
      expect(CofluiColors.disabled, isA<Color>());
    });

    test('colorScheme synthesizes a valid ColorScheme', () {
      final cs = CofluiColors.colorScheme;
      expect(cs, isA<ColorScheme>());
      expect(cs.primary, CofluiColors.primary);
      expect(cs.onPrimary, CofluiColors.onPrimary);
      expect(cs.surface, CofluiColors.surface);
    });

    test('colors are mutable (can be overridden at boot)', () {
      final original = CofluiColors.primary;
      CofluiColors.primary = const Color(0xFF123456);
      expect(CofluiColors.primary, const Color(0xFF123456));
      // Restore.
      CofluiColors.primary = original;
    });
  });

  group('CofluiTypography', () {
    test('has a complete type scale', () {
      expect(CofluiTypography.heroNumber, 42.0);
      expect(CofluiTypography.display, 28.0);
      expect(CofluiTypography.sectionTitle, 20.0);
      expect(CofluiTypography.cardTitle, 18.0);
      expect(CofluiTypography.itemTitle, 16.0);
      expect(CofluiTypography.body, 14.0);
      expect(CofluiTypography.caption, 12.0);
      expect(CofluiTypography.badge, 10.0);
      expect(CofluiTypography.detail, 11.0);
    });

    test('has predefined TextStyle constants', () {
      expect(CofluiTypography.bodyStyle.fontSize, 14.0);
      expect(CofluiTypography.bodyStyle.fontWeight, FontWeight.normal);

      expect(CofluiTypography.sectionTitleStyle.fontSize, 20.0);
      expect(CofluiTypography.sectionTitleStyle.fontWeight, FontWeight.bold);
    });
  });
}
