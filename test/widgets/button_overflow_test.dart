// Regression test for the dynamic-form button row overflow
// (see: "RenderFlex overflowed by N pixels on the right").
//
// The submit button label "Kirim Pengajuan" + icon used to overflow its
// half-width allocation. Two fixes prevent it:
//   1. CofluiButton now ellipsizes its label (overflow-safe).
//   2. The form JSON gives the buttons explicit flex weights (Reset 1,
//      Submit 2) so the submit button has enough horizontal room.
//
// This test pumps the exact row layout and asserts the submit button renders
// WITHOUT any RenderFlex overflow.
import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('form button row does not overflow (flex 1:2)', (tester) async {
    final overflowErrors = <String>[];
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final msg = details.toString();
      if (msg.contains('overflowed')) overflowErrors.add(msg);
      originalOnError?.call(details);
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 370, // typical phone content width
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  // Reset — Expanded(flex: 1), same as the row builder produces
                  // for `props.flex: 1`.
                  Expanded(
                    flex: 1,
                    child: CofluiButton(
                      label: 'Reset',
                      variant: CofluiButtonVariant.outline,
                      icon: Icons.refresh,
                      fullWidth: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  // Submit — Expanded(flex: 2) + forced to allocation width,
                  // mirroring `props.flex: 2` + `widthInfinity: true`.
                  Expanded(
                    flex: 2,
                    child: LayoutBuilder(
                      builder: (context, c) => SizedBox(
                        width: c.maxWidth,
                        child: CofluiButton(
                          label: 'Kirim Pengajuan',
                          variant: CofluiButtonVariant.primary,
                          icon: Icons.send,
                          fullWidth: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      overflowErrors,
      isEmpty,
      reason: 'Button row must not overflow. Got: $overflowErrors',
    );
  });
}
