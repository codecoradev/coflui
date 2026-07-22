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

          // ── Icon ──────────────────────────────────────────
          const _SectionTitle('CofluiIcon (auto-detect)'),
          CofluiText(
            'One widget, four sources: IconData, .svg asset, .png asset, '
            'and network URL (disk-cached).',
            style: TextStyle(fontSize: 12, color: CofluiColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 20,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _IconSample('Material\nIconData', CofluiIcon(Icons.home, size: 40)),
              _IconSample('SVG asset', CofluiIcon('assets/logo.svg', size: 40)),
              _IconSample(
                'Network URL\n(cached)',
                CofluiIcon(
                  'https://flutter.dev/assets/images/shared/brand/flutter/logo/logo-mono-61.png',
                  size: 40,
                ),
              ),
              _IconSample(
                'Tinted',
                CofluiIcon(Icons.star, size: 40, color: Color(0xFFFEA72C)),
              ),
            ],
          ),

          _Divider(),

          // ── Gradients ──────────────────────────────────────
          const _SectionTitle('CofluiGradients / CofluiGradientBar'),
          CofluiText(
            'Brand gradient presets (accent / cool / warm) built on overridable '
            'CofluiColors tokens. Override at boot to rebrand.',
            style: TextStyle(fontSize: 12, color: CofluiColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          const CofluiGradientBar(gradient: 'accent', height: 8),
          const SizedBox(height: 8),
          const CofluiGradientBar(gradient: 'cool', height: 8),
          const SizedBox(height: 8),
          const CofluiGradientBar(gradient: 'warm', height: 8),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: CofluiGradients.box(preset: 'accent', radius: 12),
            child: const CofluiText(
              'Gradient BoxDecoration helper',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),

          _Divider(),

          // ── ListTile ───────────────────────────────────────
          const _SectionTitle('CofluiListTile'),
          CofluiListTile(
            title: 'Budi Santoso',
            subtitle: 'Senior Developer',
            leading: const CofluiIcon(Icons.person, size: 24),
            trailing: const CofluiIcon(Icons.chevron_right, size: 24),
            onTap: () {},
          ),
          CofluiListTile(
            title: 'Siti Rahma',
            subtitle: 'Product Manager',
            leading: const CofluiIcon(Icons.person, size: 24),
            trailing: const CofluiIcon(Icons.chevron_right, size: 24),
            onTap: () {},
          ),

          _Divider(),

          // ── DetailRow ──────────────────────────────────────
          const _SectionTitle('CofluiDetailRow'),
          const CofluiCard(
            child: Column(
              children: [
                CofluiDetailRow(
                  icon: Icon(Icons.person),
                  label: 'Name',
                  value: 'Budi Santoso',
                ),
                SizedBox(height: 12),
                CofluiDetailRow(
                  icon: Icon(Icons.email),
                  label: 'Email',
                  value: 'budi@example.com',
                ),
                SizedBox(height: 12),
                CofluiDetailRow(
                  icon: Icon(Icons.check_circle),
                  label: 'Status',
                  value: 'Approved',
                  valueColor: Color(0xFF8EC302),
                ),
              ],
            ),
          ),

          _Divider(),

          // ── Loading button + enhanced TextField ────────────
          const _SectionTitle('CofluiButton (loading) + CofluiTextField (rich)'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CofluiButton(
                label: 'Loading',
                isLoading: true,
                onPressed: () {},
              ),
              CofluiButton(
                label: 'Loading',
                variant: CofluiButtonVariant.outline,
                isLoading: true,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          const CofluiTextField(
            label: 'Email',
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email),
          ),
          const SizedBox(height: 8),
          const CofluiTextField(
            label: 'Search',
            hint: 'Type to search…',
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.clear),
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

/// Labeled icon sample cell for the gallery.
class _IconSample extends StatelessWidget {
  final String caption;
  final Widget icon;
  const _IconSample(this.caption, this.icon);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CofluiColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CofluiColors.border),
            ),
            child: icon,
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: CofluiColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
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
