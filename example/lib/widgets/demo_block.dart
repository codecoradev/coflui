import 'dart:convert';

import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../util/clipboard_util.dart';

/// A demo card that shows a widget live + a "Copy JSON" button.
///
/// Used in the Gallery to showcase each native widget alongside the JSON
/// snippet that produces the same result via the dynamic-UI engine. Tap the
/// copy icon → JSON goes to clipboard → paste into Playground to render.
class DemoBlock extends StatelessWidget {
  final String title;
  final Widget child;

  /// The JSON snippet (will be pretty-printed before copying).
  final Object json;

  /// Optional longer description shown under the title.
  final String? description;

  const DemoBlock({
    super.key,
    required this.title,
    required this.child,
    required this.json,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return CofluiCard(
      borderless: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: CofluiColors.onSurface,
                  ),
                ),
              ),
              _CopyJsonButton(json: json),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: TextStyle(
                fontSize: 11,
                color: CofluiColors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _CopyJsonButton extends StatefulWidget {
  final Object json;
  const _CopyJsonButton({required this.json});

  @override
  State<_CopyJsonButton> createState() => _CopyJsonButtonState();
}

class _CopyJsonButtonState extends State<_CopyJsonButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Copy JSON',
      visualDensity: VisualDensity.compact,
      iconSize: 16,
      color: _copied
          ? CofluiColors.accentGreen
          : CofluiColors.onSurfaceVariant,
      icon: Icon(_copied ? Icons.check : Icons.content_copy),
      onPressed: () async {
        final pretty =
            const JsonEncoder.withIndent('  ').convert(widget.json);
        await copyToClipboard(pretty);
        if (!mounted) return;
        setState(() => _copied = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('JSON copied — paste into Playground'),
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 2),
            () => mounted ? setState(() => _copied = false) : null);
      },
    );
  }
}
