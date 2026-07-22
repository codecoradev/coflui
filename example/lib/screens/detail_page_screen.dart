import 'dart:convert';

import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';

import '../samples/detail_page_json.dart';
import '../util/clipboard_util.dart';

/// A FULL document-detail page rendered entirely from JSON via the dynamic
/// UI engine — no hand-written widgets in the body.
///
/// Clone-ready pattern:
///   1. [buildDetailJson] produces the layout from a plain data map.
///   2. [dummyApproval] is the sample data (swap for an API response).
///   3. The controller loads the JSON; [DynamicUIWidget] renders it.
///
/// Interactive features:
///   - Tap an attachment chip → preview dialog (image or PDF name).
///   - Tap Approve/Reject → action logged.
///   - "Copy JSON" button → clipboard for instant reuse.
class DetailPageScreen extends StatefulWidget {
  const DetailPageScreen({super.key});

  @override
  State<DetailPageScreen> createState() => _DetailPageScreenState();
}

class _DetailPageScreenState extends State<DetailPageScreen> {
  late final _ActionController _controller;
  late final FocusNode _selectionFocus;
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    DynamicUIBootstrap.registerDefaults();
    _selectionFocus = FocusNode();
    _controller = _ActionController()
      ..loadFromJson(buildDetailJson(dummyApproval))
      ..onActionTap = _handleAction;
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectionFocus.dispose();
    super.dispose();
  }

  /// Routes an action to the right handler.
  void _handleAction(String action, String id) {
    setState(() => _log.insert(0, '$action("$id")'));
    if (_log.length > 12) _log.removeLast();

    switch (action) {
      case 'view_attachment':
        _showAttachmentPreview(id);
        break;
      // approve / reject / view_approver → logged only.
    }
  }

  /// Finds an attachment by name in the dummy data and shows a preview.
  void _showAttachmentPreview(String name) {
    final atts = (dummyApproval['attachments'] as List).cast<Map<String, dynamic>>();
    final match = atts.firstWhere(
      (a) => a['name'] == name,
      orElse: () => <String, dynamic>{},
    );
    final url = match['url'] as String?;
    final kind = match['kind'] as String? ?? 'file';

    showDialog<void>(
      context: context,
      builder: (_) => _AttachmentPreview(name: name, kind: kind, url: url),
    );
  }

  /// Copies the full detail-page JSON to the clipboard.
  Future<void> _copyJson() async {
    final json = const JsonEncoder.withIndent('  ')
        .convert(buildDetailJson(dummyApproval));
    final ok = await copyToClipboard(json);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'JSON copied to clipboard' : 'Copy failed — select & copy manually'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic UI — Detail Page'),
        actions: [
          IconButton(
            tooltip: 'Copy JSON',
            icon: const Icon(Icons.copy),
            onPressed: _copyJson,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final c in _controller.components)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: DynamicUIWidget(c, controller: _controller),
                  ),
                const SizedBox(height: 24),
                // How-to-clone hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CofluiColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                child: SelectableRegion(
                  focusNode: _selectionFocus,
                  selectionControls: materialTextSelectionControls,
                  child: CofluiText(
                      'This entire page is JSON → DynamicUIWidget. Tap the '
                      'attachment chips to preview. Tap "Copy JSON" (top-right) '
                      'to reuse the layout. To clone into another project: '
                      'keep buildDetailJson(), swap dummyApproval with your '
                      'API data.',
                      style: TextStyle(
                        fontSize: 11,
                        color: CofluiColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_log.isNotEmpty)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 110),
              padding: const EdgeInsets.all(12),
              color: CofluiColors.onSurface.withValues(alpha: 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CofluiText(
                    'Action log',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: CofluiColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final entry in _log)
                          CofluiText(
                            '• $entry',
                            style: TextStyle(
                              fontSize: 11,
                              color: CofluiColors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Attachment preview dialog. Shows the image if it's an image kind, or a
/// file placeholder for PDFs (no full PDF viewer in the example).
class _AttachmentPreview extends StatelessWidget {
  final String name;
  final String kind;
  final String? url;

  const _AttachmentPreview({
    required this.name,
    required this.kind,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = kind == 'image' || name.toLowerCase().endsWith(('.jpg')) ||
        name.toLowerCase().endsWith('.png') ||
        name.toLowerCase().endsWith('.jpeg');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    isImage ? Icons.image : Icons.picture_as_pdf,
                    color: isImage ? CofluiColors.accentBlue : CofluiColors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isImage && url != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CofluiIcon.url(url!, fit: BoxFit.contain),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: CofluiColors.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        size: 56,
                        color: CofluiColors.error,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PDF preview',
                        style: TextStyle(
                          color: CofluiColors.onSurfaceVariant,
                        ),
                      ),
                      if (url != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            url!,
                            style: TextStyle(
                              fontSize: 10,
                              color: CofluiColors.disabled,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Controller that records every onAction call via a callback.
class _ActionController extends CofluiFormController {
  void Function(String action, String id)? onActionTap;

  @override
  void onAction(String action, String componentId) {
    onActionTap?.call(action, componentId);
  }
}
