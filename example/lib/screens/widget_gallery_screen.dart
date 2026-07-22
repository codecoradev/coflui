import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

/// A scrollable gallery of every native Coflui widget.
///
/// This screen uses hand-written code (not the dynamic engine) to showcase
/// each `Coflui*` widget in isolation.
class WidgetGalleryScreen extends StatelessWidget {
  const WidgetGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Text ──────────────────────────────────────────
          const _SectionTitle('CofluiText'),
          const CofluiText(
            'Body text with default style (14px, onSurfaceVariant).',
          ),
          const SizedBox(height: 4),
          CofluiText(
            'Custom style — bold 18px primary color.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CofluiColors.primary,
            ),
          ),

          _Divider(),

          // ── Button ────────────────────────────────────────
          const _SectionTitle('CofluiButton'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CofluiButton(
                label: 'Primary',
                icon: Icons.send,
                onPressed: () {},
              ),
              CofluiButton(
                label: 'Outline',
                variant: CofluiButtonVariant.outline,
                icon: Icons.download,
                onPressed: () {},
              ),
              CofluiButton(
                label: 'Danger',
                variant: CofluiButtonVariant.danger,
                icon: Icons.delete,
                onPressed: () {},
              ),
              CofluiButton(
                label: 'Ghost',
                variant: CofluiButtonVariant.ghost,
                icon: Icons.info,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          CofluiButton(
            label: 'Full Width Primary',
            fullWidth: true,
            onPressed: () {},
          ),

          _Divider(),

          // ── TextField ─────────────────────────────────────
          const _SectionTitle('CofluiTextField'),
          const CofluiTextField(
            hint: 'Enter your name',
          ),
          const SizedBox(height: 8),
          const CofluiTextField(
            hint: 'Phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          const CofluiTextField(
            hint: 'Disabled field',
            enabled: false,
          ),

          _Divider(),

          // ── Dropdown ──────────────────────────────────────
          const _SectionTitle('CofluiDropdown'),
          _DropdownDemo(),

          _Divider(),

          // ── Card ──────────────────────────────────────────
          const _SectionTitle('CofluiCard'),
          const CofluiCard(
            title: 'Card Title',
            child: CofluiText(
              'Card content goes here. This is a styled surface with a '
              'title, soft shadow, and rounded corners.',
            ),
          ),

          _Divider(),

          // ── Grid ──────────────────────────────────────────
          const _SectionTitle('CofluiGrid (responsive)'),
          CofluiText(
            'Resize the window to see column count change: '
            'mobile=1, tablet=2, desktop=3.',
            style: TextStyle(fontSize: 12, color: CofluiColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          CofluiGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            children: List.generate(6, (i) {
              return CofluiCard(
                title: 'Item ${i + 1}',
                child: CofluiText(
                  'Grid cell #${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: CofluiColors.onSurfaceVariant,
                  ),
                ),
              );
            }),
          ),

          _Divider(),

          // ── Responsive ────────────────────────────────────
          const _SectionTitle('CofluiResponsive'),
          CofluiText(
            'Swaps subtree per device. Resize to see it change.',
            style: TextStyle(fontSize: 12, color: CofluiColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CofluiColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CofluiResponsive(
              mobile: CofluiText(
                '📱 Mobile layout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CofluiColors.primary,
                ),
              ),
              tablet: CofluiText(
                '📱💻 Tablet layout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CofluiColors.secondary,
                ),
              ),
              desktop: CofluiText(
                '🖥️ Desktop layout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CofluiColors.accentGreen,
                ),
              ),
            ),
          ),

          _Divider(),

          // ── Dialog ────────────────────────────────────────
          const _SectionTitle('CofluiDialog'),
          Wrap(
            spacing: 12,
            children: [
              CofluiButton(
                label: 'Show Alert',
                variant: CofluiButtonVariant.outline,
                onPressed: () => CofluiDialog.alert(
                  context,
                  title: 'Information',
                  body: 'This is a CofluiDialog.alert() call.',
                ),
              ),
              CofluiButton(
                label: 'Show Confirm',
                variant: CofluiButtonVariant.outline,
                onPressed: () async {
                  final ok = await CofluiDialog.confirm(
                    context,
                    title: 'Confirm Action',
                    body: 'Are you sure you want to proceed?',
                  );
                  if (!context.mounted) return;
                  CofluiDialog.alert(
                    context,
                    title: 'Result',
                    body: ok ? 'You confirmed.' : 'You cancelled.',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: CofluiText(
        text,
        style: TextStyle(
          fontSize: CofluiTypography.sectionTitle,
          fontWeight: FontWeight.bold,
          color: CofluiColors.onSurface,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: CofluiColors.divider),
    );
  }
}

/// Dropdown demo needs local state.
class _DropdownDemo extends StatefulWidget {
  @override
  State<_DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<_DropdownDemo> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return CofluiDropdown<String>(
      value: _value,
      hint: 'Select a fruit',
      items: ['Apple', 'Banana', 'Cherry', 'Durian']
          .map((f) => DropdownMenuItem(
                value: f,
                child: Text(f),
              ))
          .toList(),
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
