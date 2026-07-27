import '../util/clipboard_util.dart' show copyToClipboard;
import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

/// Getting Started — the FIRST screen users see.
///
/// A concise, copy-paste-ready tutorial covering:
/// 1. What Coflui is
/// 2. Native widgets (hand-written)
/// 3. Dynamic UI (JSON-driven)
/// 4. JSON conventions (props vs style)
/// 5. Clone-ready patterns
///
/// Tap any code block to copy it.
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guide — Getting Started')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Intro(),
          const SizedBox(height: 16),
          const _Section(
            icon: Icons.widgets,
            title: '1. Native Widgets',
            body: 'Coflui provides styled wrappers over Flutter widgets. '
                'Import once, use everywhere. No JSON needed.',
            code: '''import 'package:coflui/coflui.dart';

CofluiCard(
  title: 'My Card',
  child: Column(
    children: [
      CofluiText('Hello, Coflui!'),
      CofluiButton(
        label: 'Tap me',
        icon: Icons.send,
        onPressed: () {},
      ),
    ],
  ),
)''',
          ),
          SizedBox(height: 16),
          _Section(
            icon: Icons.code,
            title: '2. Dynamic UI (JSON-driven)',
            body: 'Render an entire UI tree from JSON. Register builders once, '
                'then feed JSON. Great for server-driven UI, forms, and '
                'detail pages.',
            code: '''DynamicUIBootstrap.registerDefaults();

final ctrl = CofluiFormController()
  ..loadFromJson([
    {'id': 't', 'type': 'text', 'label': 'Hello!'},
    {
      'id': 'btn', 'type': 'button',
      'label': 'Submit',
      'props': {'icon': 'check', 'action': 'submit'},
    },
  ]);

DynamicUIWidget(ctrl.components.first, controller: ctrl)''',
          ),
          SizedBox(height: 16),
          _Section(
            icon: Icons.category,
            title: '3. Component Types',
            body: 'Every type maps to a builder. Use aliases freely '
                '(e.g. "tile" = "list_tile").',
            code: '''// Containers (nestable):
"column", "row", "card", "section", "grid"

// Display:
"text", "heading", "divider", "chip"

// Input:
"textfield", "dropdown", "switch", "datepicker", "checkbox"

// Action:
"button"

// Media:
"icon", "image", "gradient_bar"

// Content:
"list_tile", "detail_row"

// Composite:
"list"   // repeat a child template over items[]''',
          ),
          SizedBox(height: 16),
          _Section(
            icon: Icons.tune,
            title: '4. props vs style (IMPORTANT)',
            body: 'A common gotcha: component-specific config goes in `props`, '
                'visual styling goes in `style`. They are NOT interchangeable.',
            code: '''{
  "type": "card",
  "props": {
    "borderless": true,      // ← config specific to card
    "gradient": "accent",
    "maxWidth": 480
  },
  "style": {
    "padding": 16,            // ← generic visual style
    "bgColor": "#FFFFFF",
    "radius": 14,
    "elevation": 6
  },
  "children": [...]
}''',
          ),
          SizedBox(height: 16),
          _Section(
            icon: Icons.repeat,
            title: '5. list — Repeat Over Arrays',
            body: 'The `list` component clones its first child for each item. '
                'Use {field} placeholders to bind item data. Perfect for '
                'approvers, attachments, line items.',
            code: '''{
  "type": "list",
  "props": {
    "items": [
      {"name": "Andi", "role": "Manager"},
      {"name": "Maya", "role": "Finance"}
    ],
    "direction": "vertical",
    "spacing": 8
  },
  "children": [
    {
      "type": "list_tile",
      "props": {
        "title": "{name}",
        "subtitle": "{role}",
        "leading": "person"
      }
    }
  ]
}''',
          ),
          SizedBox(height: 16),
          _Section(
            icon: Icons.image,
            title: '6. Icons — Any Source',
            body: 'Icon props accept Material names, code-points, SVG assets, '
                'PNG assets, or network URLs. Auto-detected.',
            code: '''// Material icon name (see Icons tab):
{"icon": "home", "size": 24}

// Hex code-point:
{"icon": "0xe318"}

// SVG asset:
{"icon": "assets/logo.svg"}

// Network image (disk-cached):
{"icon": "https://example.com/logo.png"}''',
          ),
          SizedBox(height: 16),
          _Section(
            icon: Icons.content_copy,
            title: '7. Clone-Ready Detail Page',
            body: 'A full detail page is just a JSON template + a data map. '
                'Keep the template, swap the data — the whole page re-renders. '
                'See the "Detail" tab for a live example.',
            code: '''// In your app:
final json = buildDetailJson(apiResponse);
final ctrl = CofluiFormController()..loadFromJson(json);
// → render ctrl.components via DynamicUIWidget''',
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.all(16),
            child: CofluiText(
              '💡 Tip: Open the Playground tab to experiment with JSON in '
              'real-time. Load a template, tweak, and hit Render. Copy JSON '
              'snippets from the Detail and Icons tabs.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: CofluiColors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return CofluiCard(
      gradient: CofluiGradients.accent,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coflui',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'A Flutter UI package combining a JSON-driven dynamic UI engine '
            'with a set of native widgets. State-management agnostic, '
            'responsive across mobile / tablet / desktop.',
            style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String code;

  const _Section({
    required this.icon,
    required this.title,
    required this.body,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return CofluiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: CofluiColors.accentBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              color: CofluiColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _CodeBlock(code: code),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatefulWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  State<_CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<_CodeBlock> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await copyToClipboard(widget.code);
        if (!mounted) return;
        setState(() => _copied = true);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard'),
            duration: Duration(milliseconds: 1200),
          ),
        );
        Future.delayed(const Duration(seconds: 2),
            () => mounted ? setState(() => _copied = false) : null);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectableText(
                widget.code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFFCDD6F4),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _copied ? Icons.check : Icons.copy,
              size: 16,
              color: _copied
                  ? CofluiColors.accentGreen
                  : const Color(0xFF6C7086),
            ),
          ],
        ),
      ),
    );
  }
}
