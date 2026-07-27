import 'dart:convert';

import 'package:flutter/material.dart';

import '../samples/components_json.dart' as comp;
import '../samples/dashboard_json.dart' as dash;
import '../samples/detail_page_json.dart' as detail;
import '../samples/form_json.dart' as form;
import '../util/clipboard_util.dart';
import 'detail_page_screen.dart';
import 'dynamic_components_screen.dart';
import 'dynamic_dashboard_screen.dart';
import 'dynamic_form_screen.dart';

/// A hub for all full-page dynamic-UI demos.
///
/// Each tab renders a complete page from JSON, with a "Copy JSON" action in
/// the AppBar so you can grab the source and paste into the Playground.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  int _index = 0;

  static const _tabs = ['Detail', 'Components', 'Form', 'Dashboard'];

  static const _screens = <Widget>[
    DetailPageScreen(),
    DynamicComponentsScreen(),
    DynamicFormScreen(),
    DynamicDashboardScreen(),
  ];

  /// The raw JSON for each tab — used by the Copy button.
  Object get _currentJson {
    switch (_index) {
      case 0:
        return detail.buildDetailJson(detail.dummyApproval);
      case 1:
        return comp.componentsJson;
      case 2:
        return form.formJson;
      case 3:
        return dash.dashboardJson;
      default:
        return const [];
    }
  }

  Future<void> _copyJson() async {
    final pretty =
        const JsonEncoder.withIndent('  ').convert(_currentJson);
    final ok = await copyToClipboard(pretty);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? '${_tabs[_index]} JSON copied — paste into Playground'
            : 'Copy failed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Showcase — Dynamic UI'),
          actions: [
            IconButton(
              tooltip: 'Copy ${_tabs[_index]} JSON',
              icon: const Icon(Icons.content_copy),
              onPressed: _copyJson,
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            onTap: (i) => setState(() => _index = i),
            tabs: [for (final t in _tabs) Tab(text: t)],
          ),
        ),
        body: TabBarView(
          children: _screens,
        ),
      ),
    );
  }
}
