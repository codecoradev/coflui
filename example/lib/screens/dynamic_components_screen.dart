import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../samples/components_json.dart';

/// Demonstrates the new dynamic-UI component types rendered entirely from
/// JSON: `gradient_bar`, `detail_row`, `list_tile`, `icon`, and `image`.
///
/// No hand-written widgets here — everything flows through [DynamicUIWidget]
/// + the registered builders. Tap the list tiles / buttons to see the action
/// callback fire.
class DynamicComponentsScreen extends StatefulWidget {
  const DynamicComponentsScreen({super.key});

  @override
  State<DynamicComponentsScreen> createState() =>
      _DynamicComponentsScreenState();
}

class _DynamicComponentsScreenState extends State<DynamicComponentsScreen> {
  late final _ActionController _controller;
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    DynamicUIBootstrap.registerDefaults();
    _controller = _ActionController()
      ..loadFromJson(componentsJson)
      ..onActionTap = (action, id) {
          setState(() => _log.insert(0, '$action("$id")'));
          if (_log.length > 20) _log.removeLast();
        };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic UI — Components')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CofluiText(
                  'Every widget below is rendered from JSON via the dynamic '
                  'engine. New types: gradient_bar, detail_row, list_tile, '
                  'icon, image.',
                  style: TextStyle(
                    fontSize: 12,
                    color: CofluiColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                for (final c in _controller.components)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DynamicUIWidget(c, controller: _controller),
                  ),
              ],
            ),
          ),
          if (_log.isNotEmpty)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 120),
              padding: const EdgeInsets.all(12),
              color: CofluiColors.onSurface.withValues(alpha: 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CofluiText(
                    'Action log',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: CofluiColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final entry in _log)
                          CofluiText(
                            '• $entry',
                            style: TextStyle(
                              fontSize: 11,
                              color: CofluiColors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Controller that records every onAction call via a callback.
class _ActionController extends CofluiFormController {
  /// Invoked with `(action, componentId)` on each button/tile tap.
  void Function(String action, String id)? onActionTap;

  @override
  void onAction(String action, String componentId) {
    onActionTap?.call(action, componentId);
  }
}
