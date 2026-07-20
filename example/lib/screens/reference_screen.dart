import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../samples/doc_content.dart';

/// In-app documentation / reference for the Coflui dynamic UI engine.
///
/// Renders the same schema reference as `doc/DYNAMIC_UI.md`, but self-contained
/// inside the app so a user can learn the JSON format without leaving the demo.
/// Each section is a collapsible card; code blocks have a copy-to-clipboard
/// button.
class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reference — JSON Schema')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          // Intro card.
          CofluiCard(
            title: 'Coflui Dynamic UI',
            child: CofluiText(
              'Setiap screen adalah JSON array (atau object tunggal) dari '
              'komponen. Container bersarang → kedalaman tak terbatas. '
              'Buka tiap section di bawah untuk detail per tipe.',
              style: TextStyle(color: CofluiColors.onSurfaceVariant, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          for (final s in allSections) ...[
            _DocSectionCard(section: s),
            const SizedBox(height: 12),
          ],
          Center(
            child: CofluiText(
              '15 component types • state-management agnostic',
              style: TextStyle(
                fontSize: 11,
                color: CofluiColors.disabled,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single expandable documentation section.
class _DocSectionCard extends StatefulWidget {
  final DocSection section;
  const _DocSectionCard({required this.section});

  @override
  State<_DocSectionCard> createState() => _DocSectionCardState();
}

class _DocSectionCardState extends State<_DocSectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.section;
    return CofluiCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tappable header.
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CofluiText(
                          s.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CofluiText(
                          s.summary,
                          style: TextStyle(
                            fontSize: 12,
                            color: CofluiColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.chevron_right,
                      color: CofluiColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable body.
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  for (final b in s.blocks) ...[
                    if (b.text != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CofluiText(
                          b.text!,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: b.text!.startsWith('•') ||
                                    b.text!.startsWith('▸')
                                ? CofluiColors.onSurface
                                : CofluiColors.onSurfaceVariant,
                            fontWeight: b.text!.startsWith('▸')
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    if (b.code != null) ...[
                      _CodeBlock(code: b.code!, language: b.language ?? 'json'),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A monospace code block with a copy-to-clipboard button.
class _CodeBlock extends StatelessWidget {
  final String code;
  final String language;
  const _CodeBlock({required this.code, required this.language});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 36),
            color: const Color(0xFF1E1E2E),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.5,
                height: 1.5,
                color: Color(0xFFE0E0F0),
              ),
            ),
          ),
          // Language tag (top-right).
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                language,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          // Copy button (bottom-right).
          Positioned(
            bottom: 4,
            right: 4,
            child: _CopyButton(text: code),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String text;
  const _CopyButton({required this.text});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.text));
        setState(() => _copied = true);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _copied = false);
        });
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check : Icons.copy,
              size: 13,
              color: _copied ? CofluiColors.puraGreen : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              _copied ? 'Tersalin' : 'Salin',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
