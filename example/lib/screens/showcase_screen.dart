import 'package:flutter/material.dart';

import 'detail_page_screen.dart';
import 'dynamic_components_screen.dart';
import 'dynamic_dashboard_screen.dart';
import 'dynamic_form_screen.dart';

/// A hub for all full-page dynamic-UI demos.
///
/// Instead of cluttering the main nav with 4 separate tabs, this screen
/// uses an internal TabBar to switch between the dynamic demos:
/// Detail Page, Components, Form, and Dashboard.
class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  static const _tabs = [
    ('Detail', DetailPageScreen()),
    ('Components', DynamicComponentsScreen()),
    ('Form', DynamicFormScreen()),
    ('Dashboard', DynamicDashboardScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Showcase — Dynamic UI'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              for (final t in _tabs) Tab(text: t.$1),
            ],
          ),
        ),
        body: TabBarView(
          children: [for (final t in _tabs) t.$2],
        ),
      ),
    );
  }
}
