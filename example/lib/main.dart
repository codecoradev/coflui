import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import 'screens/guide_screen.dart';
import 'screens/icon_catalog_screen.dart';
import 'screens/playground_screen.dart';
import 'screens/reference_screen.dart';
import 'screens/showcase_screen.dart';
import 'screens/widget_gallery_screen.dart';

/// Coflui example app entry point.
///
/// Navigation is organized into **6 tabs by learning path**:
/// 1. **Guide** — start here (tutorials, JSON conventions, clone patterns)
/// 2. **Gallery** — native widget showcase
/// 3. **Showcase** — full dynamic-UI pages (Detail, Components, Form, Dashboard)
/// 4. **Playground** — live JSON → UI editor
/// 5. **Icons** — searchable icon catalog (tap to copy)
/// 6. **Reference** — JSON schema reference
///
/// The Responsive demo lives inside Gallery.
void main() {
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

class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _index = 0;

  static const _destinations = [
    (
      label: 'Guide',
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
    ),
    (
      label: 'Gallery',
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
    ),
    (
      label: 'Showcase',
      icon: Icons.view_carousel_outlined,
      selectedIcon: Icons.view_carousel,
    ),
    (
      label: 'Playground',
      icon: Icons.code_outlined,
      selectedIcon: Icons.code,
    ),
    (
      label: 'Icons',
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view,
    ),
    (
      label: 'Reference',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
    ),
  ];

  static const _screens = <Widget>[
    GuideScreen(),
    WidgetGalleryScreen(),
    ShowcaseScreen(),
    PlaygroundScreen(),
    IconCatalogScreen(),
    ReferenceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
