import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../samples/detail_page_json.dart';

/// A FULL document-detail page rendered entirely from JSON via the dynamic
/// UI engine — no hand-written widgets in the body.
///
/// Clone-ready pattern:
///   1. [buildDetailJson] produces the layout from a plain data map.
///   2. [dummyApproval] is the sample data (swap for an API response).
///   3. The controller loads the JSON; [DynamicUIWidget] renders it.
///
/// Tap the action buttons / approver rows → the onAction callback fires and
/// is shown in the bottom log panel.
class DetailPageScreen extends StatefulWidget {
  const DetailPageScreen({super.key});

  @override
  State<DetailPageScreen> createState() => _DetailPageScreenState();
}

class _DetailPageScreenState extends State<DetailPageScreen> {
  late final _ActionController _controller;
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    DynamicUIBootstrap.registerDefaults();
    _controller = _ActionController()
      ..loadFromJson(buildDetailJson(dummyApproval))
      ..onActionTap = (action, id) {
        setState(() => _log.insert(0, '$action("$id")'));
        if (_log.length > 12) _log.removeLast();
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
      appBar: AppBar(title: const Text('Dynamic UI — Detail Page')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final c in _controller.components)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: DynamicUIWidget(c, controller: _controller),
                  ),
                const SizedBox(height: 24),
                // How-to-clone hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CofluiColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CofluiText(
                    'This entire page is JSON → DynamicUIWidget. To clone: '
                    'keep buildDetailJson(), swap dummyApproval with your API '
                    'data. Lists (approvers / items / attachments) repeat a '
                    'template over {field} placeholders.',
                    style: TextStyle(
                      fontSize: 11,
                      color: CofluiColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_log.isNotEmpty)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 110),
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
  void Function(String action, String id)? onActionTap;

  @override
  void onAction(String action, String componentId) {
    onActionTap?.call(action, componentId);
  }
}
