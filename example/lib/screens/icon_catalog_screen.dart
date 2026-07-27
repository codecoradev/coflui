import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../samples/icon_catalog.dart';
import '../util/clipboard_util.dart';

/// A searchable catalog of icon names supported by [IconResolver].
///
/// Tap any icon card → copies a JSON snippet ready to paste into the
/// Playground or detail page. Search bar filters by name.
///
/// This screen is a **live reference** for which Material icon names can be
/// used in `props.icon` (detail_row), `props.leading` / `props.trailing`
/// (list_tile), and `props.icon` (chip / button).
class IconCatalogScreen extends StatefulWidget {
  const IconCatalogScreen({super.key});

  @override
  State<IconCatalogScreen> createState() => _IconCatalogScreenState();
}

class _IconCatalogScreenState extends State<IconCatalogScreen> {
  String _query = '';
  String? _lastCopied;

  @override
  Widget build(BuildContext context) {
    final filtered = cofluiIconCatalog
        .where((n) => n.contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Icon Catalog')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search icons (e.g. check, arrow, person)…',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (q) => setState(() => _query = q),
            ),
          ),
          // Helper text
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CofluiText(
                'Tap an icon to copy a JSON snippet → paste into Playground. '
                '${filtered.length} of ${cofluiIconCatalog.length} icons.',
                style: TextStyle(
                  fontSize: 11,
                  color: CofluiColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 110,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final name = filtered[i];
                final icon = IconResolver.resolve(name) ?? Icons.help_outline;
                final isCopied = _lastCopied == name;
                return _IconCard(
                  name: name,
                  icon: icon,
                  isCopied: isCopied,
                  onTap: () => _copy(name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Copies a ready-to-paste JSON snippet using this icon name.
  Future<void> _copy(String name) async {
    final snippet = '''{
  "type": "icon",
  "props": { "icon": "$name", "size": 24, "color": "#088ECE" }
}''';
    final ok = await copyToClipboard(snippet);
    if (!mounted) return;
    setState(() => _lastCopied = name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Copied: icon "$name" — paste into Playground'
            : 'Copy failed — select manually'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _IconCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isCopied;
  final VoidCallback onTap;

  const _IconCard({
    required this.name,
    required this.icon,
    required this.isCopied,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isCopied
          ? CofluiColors.accentGreen.withValues(alpha: 0.15)
          : CofluiColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCopied
                  ? CofluiColors.accentGreen
                  : CofluiColors.border,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: isCopied
                    ? CofluiColors.accentGreen
                    : CofluiColors.onSurface,
              ),
              const SizedBox(height: 6),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: CofluiColors.onSurfaceVariant,
                ),
              ),
              if (isCopied) ...[
                const SizedBox(height: 2),
                Icon(Icons.check, size: 12, color: CofluiColors.accentGreen),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
