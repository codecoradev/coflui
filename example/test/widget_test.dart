// Smoke test — verifies the example app boots and renders its first screen.
//
// This replaces the default counter-app test scaffolded by `flutter create`.

import 'package:coflui_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots and shows the gallery screen', (tester) async {
    await tester.pumpWidget(const CofluiExampleApp());
    await tester.pumpAndSettle();

    // The default screen is the Widget Gallery.
    expect(find.text('Widget Gallery'), findsWidgets);
  });
}
