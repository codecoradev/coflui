import 'package:cached_network_image/cached_network_image.dart';
import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CofluiIcon — auto-detection', () {
    testWidgets('renders Material [Icon] for IconData', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CofluiIcon(Icons.home))),
      );
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders [SvgPicture] for .svg path', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CofluiIcon('assets/svg/logo.svg')),
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders [Image] for raster asset path', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CofluiIcon('assets/images/avatar.png')),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders [CachedNetworkImage] for http(s) URL', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CofluiIcon('https://example.com/icon.png'),
          ),
        ),
      );
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('named constructor .icon renders Material icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CofluiIcon.icon(Icons.star, size: 32)),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.star);
      expect(icon.size, 32);
    });

    testWidgets('extension .toCofluiIcon wraps a source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Icons.send.toCofluiIcon(color: Colors.red)),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.send);
      expect(icon.color, Colors.red);
    });
  });

  group('CofluiIcon — assertions', () {
    test('asserts source is IconData or String', () {
      expect(
        () => CofluiIcon(42),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
