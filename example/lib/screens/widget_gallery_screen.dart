import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../samples/gallery_json.dart';
import '../widgets/demo_block.dart';

/// A scrollable gallery of every native Coflui widget, **with a "Copy JSON"
/// button per demo**. Tap copy → paste into the Playground to render the
/// same widget from JSON instantly.
class WidgetGalleryScreen extends StatelessWidget {
  const WidgetGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Intro hint ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: CofluiColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 18, color: CofluiColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: CofluiText(
                    'Every demo below has a copy icon (📋) — tap to copy the '
                    'equivalent JSON, then paste into the Playground tab.',
                    style: TextStyle(
                      fontSize: 11,
                      color: CofluiColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Text ────────────────────────────────────────────
          DemoBlock(
            title: 'CofluiText',
            json: textJson,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CofluiText('Body text with default style (14px).'),
                const SizedBox(height: 4),
                CofluiText(
                  'Custom style — bold 18px primary color.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CofluiColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Button ──────────────────────────────────────────
          DemoBlock(
            title: 'CofluiButton',
            json: buttonJson,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CofluiButton(label: 'Primary', icon: Icons.send, onPressed: () {}),
                CofluiButton(label: 'Outline',
                    variant: CofluiButtonVariant.outline,
                    icon: Icons.download, onPressed: () {}),
                CofluiButton(label: 'Danger',
                    variant: CofluiButtonVariant.danger,
                    icon: Icons.delete, onPressed: () {}),
                CofluiButton(label: 'Ghost',
                    variant: CofluiButtonVariant.ghost,
                    icon: Icons.info, onPressed: () {}),
                CofluiButton(label: 'Loading', isLoading: true, onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── TextField ───────────────────────────────────────
          DemoBlock(
            title: 'CofluiTextField',
            json: textFieldJson,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CofluiTextField(label: 'Name', hint: 'Enter your name'),
                SizedBox(height: 8),
                CofluiTextField(
                    label: 'Phone', hint: 'Phone number',
                    keyboardType: TextInputType.phone),
                SizedBox(height: 8),
                CofluiTextField(
                    label: 'Email', hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Dropdown ────────────────────────────────────────
          DemoBlock(
            title: 'CofluiDropdown',
            json: dropdownJson,
            child: const _DropdownDemo(),
          ),
          const SizedBox(height: 16),

          // ── Card ────────────────────────────────────────────
          DemoBlock(
            title: 'CofluiCard (default / borderless / gradient)',
            json: cardJson,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CofluiCard(
                  title: 'Default',
                  child: CofluiText(
                      'Default — white surface, soft border, subtle shadow.'),
                ),
                const SizedBox(height: 8),
                const CofluiCard(
                  title: 'Borderless',
                  borderless: true,
                  child: CofluiText('borderless: true — flat, embeddable.'),
                ),
                const SizedBox(height: 8),
                CofluiCard(
                  gradient: CofluiGradients.accent,
                  child: const CofluiText(
                    'gradient: CofluiGradients.accent',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Grid ────────────────────────────────────────────
          DemoBlock(
            title: 'CofluiGrid (responsive)',
            description: 'Resize the window: 1 col (mobile) → 2 (tablet) → 3 (desktop).',
            json: gridJson,
            child: CofluiGrid(
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 3,
              children: List.generate(3, (i) {
                return CofluiCard(
                  title: 'Stat ${i + 1}',
                  child: CofluiText(
                    ['1.2k', '89%', '+24'][i],
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: CofluiColors.primary,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // ── Icon ────────────────────────────────────────────
          DemoBlock(
            title: 'CofluiIcon (auto-detect: IconData / SVG / URL / tinted)',
            json: iconJson,
            child: const Wrap(
              spacing: 20,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _IconCell('Material', CofluiIcon(Icons.home, size: 40)),
                _IconCell('SVG asset', CofluiIcon('assets/logo.svg', size: 40)),
                _IconCell(
                  'Network (cached)',
                  CofluiIcon(
                    'https://flutter.dev/assets/images/shared/brand/flutter/logo/logo-mono-61.png',
                    size: 40,
                  ),
                ),
                _IconCell(
                  'Tinted',
                  CofluiIcon(Icons.star, size: 40, color: Color(0xFFFEA72C)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Gradients ───────────────────────────────────────
          DemoBlock(
            title: 'CofluiGradients / CofluiGradientBar',
            json: gradientsJson,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CofluiGradientBar(gradient: 'accent', height: 8),
                SizedBox(height: 8),
                CofluiGradientBar(gradient: 'cool', height: 8),
                SizedBox(height: 8),
                CofluiGradientBar(gradient: 'warm', height: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── ListTile ────────────────────────────────────────
          DemoBlock(
            title: 'CofluiListTile',
            json: listTileJson,
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── DetailRow ───────────────────────────────────────
          DemoBlock(
            title: 'CofluiDetailRow (with value styling)',
            json: detailRowJson,
            child: const CofluiCard(
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
                    valueFontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Chip ────────────────────────────────────────────
          DemoBlock(
            title: 'CofluiChip (5 variants)',
            json: chipJson,
            child: const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CofluiChip('Approved', variant: CofluiChipVariant.success),
                CofluiChip('Pending', variant: CofluiChipVariant.warning),
                CofluiChip('Rejected', variant: CofluiChipVariant.danger),
                CofluiChip('Info', variant: CofluiChipVariant.info),
                CofluiChip('3', variant: CofluiChipVariant.info, icon: Icons.attach_file),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Dialog ──────────────────────────────────────────
          DemoBlock(
            title: 'CofluiDialog',
            json: dialogJson,
            child: Wrap(
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
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────────────

class _IconCell extends StatelessWidget {
  final String caption;
  final Widget icon;
  const _IconCell(this.caption, this.icon);

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

class _DropdownDemo extends StatefulWidget {
  const _DropdownDemo();

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
          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
          .toList(),
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
