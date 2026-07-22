import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import 'screens/dynamic_components_screen.dart';
import 'screens/dynamic_dashboard_screen.dart';
import 'screens/dynamic_form_screen.dart';
import 'screens/playground_screen.dart';
import 'screens/reference_screen.dart';
import 'screens/responsive_screen.dart';
import 'screens/widget_gallery_screen.dart';

/// Coflui example app entry point.
///
/// A simple shell with a NavigationRail (desktop/tablet) or BottomNavigationBar
/// (mobile) — itself demonstrating responsive layout.
void main() {
  // Register the dynamic UI engine's default builders once at app boot.
  DynamicUIBootstrap.registerDefaults();
  runApp(const CofluiExampleApp());
}

class CofluiExampleApp extends StatelessWidget {
  const CofluiExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coflui Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: CofluiColors.colorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: CofluiColors.surface,
          foregroundColor: CofluiColors.onSurface,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
        ),
        scaffoldBackgroundColor: CofluiColors.background,
      ),
      home: const _Shell(),
    );
  }
}

/// Responsive shell: NavigationRail on tablet/desktop, BottomNav on mobile.
class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _index = 0;

  static const _destinations = [
    (
      label: 'Gallery',
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
    ),
    (
      label: 'Components',
      icon: Icons.extension_outlined,
      selectedIcon: Icons.extension,
    ),
    (
      label: 'Form',
      icon: Icons.description_outlined,
      selectedIcon: Icons.description,
    ),
    (
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
    (
      label: 'Playground',
      icon: Icons.code_outlined,
      selectedIcon: Icons.code,
    ),
    (
      label: 'Reference',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
    ),
    (
      label: 'Responsive',
      icon: Icons.devices_outlined,
      selectedIcon: Icons.devices,
    ),
  ];

  static const _screens = <Widget>[
    WidgetGalleryScreen(),
    DynamicComponentsScreen(),
    DynamicFormScreen(),
    DynamicDashboardScreen(),
    PlaygroundScreen(),
    ReferenceScreen(),
    ResponsiveScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Use Coflui's own breakpoint to switch nav style.
    final useRail = !CofluiBreakpoints.isMobile(context);

    if (useRail) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              extended: CofluiBreakpoints.isDesktop(context),
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: _screens[_index]),
          ],
        ),
      );
    }

    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}
