import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

/// Interactive responsive demo.
///
/// Shows a live readout of the current device class and width, plus a grid
/// that re-flows as you resize the window.
class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Demo')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final device = CofluiBreakpoints.deviceOf(width);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Live device readout ───────────────────────
              CofluiCard(
                title: 'Active Breakpoint',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CofluiText(
                      'Device: ${_deviceLabel(device)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _deviceColor(device),
                      ),
                    ),
                    const SizedBox(height: 4),
                    CofluiText(
                      'Width: ${width.round()} px',
                      style: TextStyle(
                        fontSize: 14,
                        color: CofluiColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CofluiText(
                      'Breakpoints → mobile < ${CofluiBreakpoints.tablet.round()} '
                      '/ tablet ${CofluiBreakpoints.tablet.round()}–${CofluiBreakpoints.desktop.round()} '
                      '/ desktop ≥ ${CofluiBreakpoints.desktop.round()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: CofluiColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Responsive grid ───────────────────────────
              CofluiText(
                'Grid re-flows automatically:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CofluiColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              CofluiGrid(
                mobileColumns: 1,
                tabletColumns: 2,
                desktopColumns: 3,
                children: List.generate(9, (i) {
                  return CofluiCard(
                    title: 'Cell ${i + 1}',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CofluiText(
                          'Columns now: ${_colsFor(device)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: CofluiColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // ── Responsive subtree swap ───────────────────
              CofluiText(
                'CofluiResponsive subtree swap:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CofluiColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _deviceColor(device).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _deviceColor(device).withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: CofluiResponsive(
                    mobile: CofluiText(
                      '📱 Mobile — single column flow',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _deviceColor(device),
                      ),
                    ),
                    tablet: CofluiText(
                      '💻 Tablet — two-column adaptive',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _deviceColor(device),
                      ),
                    ),
                    desktop: CofluiText(
                      '🖥️ Desktop — multi-column wide layout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _deviceColor(device),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _deviceLabel(CofluiDevice d) => switch (d) {
        CofluiDevice.mobile => 'Mobile',
        CofluiDevice.tablet => 'Tablet',
        CofluiDevice.desktop => 'Desktop',
      };

  Color _deviceColor(CofluiDevice d) => switch (d) {
        CofluiDevice.mobile => CofluiColors.secondary,
        CofluiDevice.tablet => CofluiColors.primary,
        CofluiDevice.desktop => CofluiColors.puraGreen,
      };

  int _colsFor(CofluiDevice d) => switch (d) {
        CofluiDevice.mobile => 1,
        CofluiDevice.tablet => 2,
        CofluiDevice.desktop => 3,
      };
}
