import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../samples/form_json.dart';

/// Demonstrates a complete form rendered entirely from JSON via the dynamic
/// UI engine. Values are collected via [CofluiFormController.snapshot()].
///
/// Key concepts shown:
/// 1. `DynamicUIBootstrap.registerDefaults()` — register builders once.
/// 2. `_FormController extends CofluiFormController` — override `onAction`
///    to handle submit/reset.
/// 3. `controller.loadFromJson(json)` — parse and render.
/// 4. `controller.snapshot()` — read all input values.
class DynamicFormScreen extends StatefulWidget {
  const DynamicFormScreen({super.key});

  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  late final _FormController _controller;

  @override
  void initState() {
    super.initState();
    DynamicUIBootstrap.registerDefaults();
    _controller = _FormController()..loadFromJson(formJson);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic UI — Form')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CofluiText(
            'This entire form is rendered from JSON. Resize the window to '
            'see responsive behavior.',
            style: TextStyle(
              fontSize: 12,
              color: CofluiColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          // Render every root component through the dynamic engine.
          for (final c in _controller.components)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DynamicUIWidget(c, controller: _controller),
            ),
        ],
      ),
    );
  }
}

/// Custom controller that intercepts button actions (submit / reset).
///
/// In a real app you'd call your API, show a snackbar, navigate, etc.
class _FormController extends CofluiFormController {
  @override
  void onAction(String action, String componentId) {
    switch (action) {
      case 'submit':
        debugPrint('Form submitted! snapshot: ${snapshot()}');
      case 'reset':
        debugPrint('Form reset.');
        resetValues();
      default:
        debugPrint('Unknown action: $action');
    }
  }
}
