import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../samples/dashboard_json.dart';

/// Demonstrates a responsive dashboard rendered entirely from JSON.
///
/// The `grid` component derives its column count from [CofluiBreakpoints]:
///   mobile = 1 column, tablet = 2, desktop = 4.
///
/// Resize the window / run on desktop to see the layout adapt.
class DynamicDashboardScreen extends StatefulWidget {
  const DynamicDashboardScreen({super.key});

  @override
  State<DynamicDashboardScreen> createState() => _DynamicDashboardScreenState();
}

class _DynamicDashboardScreenState extends State<DynamicDashboardScreen> {
  late final CofluiFormController _controller;

  @override
  void initState() {
    super.initState();
    DynamicUIBootstrap.registerDefaults();
    _controller = CofluiFormController()..loadFromJson(dashboardJson);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic UI — Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CofluiText(
            'Responsive grid rendered from JSON. '
            'Resize to see: 1 col (mobile) → 2 col (tablet) → 4 col (desktop).',
            style: TextStyle(
              fontSize: 12,
              color: CofluiColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
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
