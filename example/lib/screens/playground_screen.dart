import 'dart:convert';

import 'package:coflui/coflui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../samples/playground_templates.dart';

/// A live JSON → UI playground.
///
/// Edit JSON on the left (or top on mobile), tap **Render**, and the result
/// appears instantly on the right (or below). Invalid JSON shows a friendly
/// error instead of crashing. Load a preset from the template chooser to get
/// started fast.
///
/// The JSON editor has a built-in **find** bar (toggle with the 🔍 icon or
/// Ctrl/Cmd+F) that highlights matches and navigates between them.
///
/// This screen demonstrates the core promise of Coflui's dynamic engine:
/// the *entire* UI on the right is built from the JSON string on the left —
/// no hand-written widgets.
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  late final TextEditingController _jsonCtrl;
  late final TextEditingController _searchCtrl;
  late final FocusNode _editorFocus;
  late final FocusNode _searchFocus;
  late final _PlaygroundController _uiController;

  /// Components currently rendered in the preview pane.
  List<UIComponent> _components = const [];

  /// Last parse error, or null when JSON is valid.
  String? _error;

  // ── Find bar state ────────────────────────────────────────────────────
  bool _searchOpen = false;
  String _query = '';
  bool _caseSensitive = false;
  List<int> _matchStarts = const [];
  int _matchIndex = -1; // current highlighted match (0-based); -1 = none
  String _lastText = ''; // guards the controller listener against loops

  // ── Line-number gutter ──────────────────────────────────────────────
  late final ScrollController _scrollCtrl;
  int _lineCount = 1;
  // True while WE are writing a selection (to highlight a match) so the
  // controller listener doesn't recurse / rebuild mid-build.
  bool _applyingSelection = false;

  // ── Resizable split (desktop) ────────────────────────────────────────
  /// Editor pane width fraction (0.2 – 0.8). Drag the divider to resize.
  double _splitRatio = 0.5;

  /// Focus node for the preview's selectable region (copy text).
  late final FocusNode _previewFocus;

  @override
  void initState() {
    super.initState();
    DynamicUIBootstrap.registerDefaults();
    _uiController = _PlaygroundController();
    _previewFocus = FocusNode();
    _jsonCtrl = TextEditingController(text: playgroundTemplates.first.json);
    _searchCtrl = TextEditingController();
    _scrollCtrl = ScrollController();
    // The editor's FocusNode intercepts Enter *while the find bar is open*.
    // After the first Enter moves focus here (to paint the match highlight +
    // scroll to it), subsequent Enters keep cycling matches — and no newline
    // is inserted while searching.
    _editorFocus = FocusNode(onKeyEvent: _onEditorKeyEvent);
    // The search box's FocusNode also intercepts Enter / Shift+Enter.
    _searchFocus = FocusNode(onKeyEvent: _onSearchKeyEvent);
    _lastText = _jsonCtrl.text;
    _lineCount = '\n'.allMatches(_lastText).length + 1;
    _jsonCtrl.addListener(_onControllerChanged);
    _render(); // render the default template immediately.
  }

  @override
  void dispose() {
    _jsonCtrl.removeListener(_onControllerChanged);
    _jsonCtrl.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _editorFocus.dispose();
    _searchFocus.dispose();
    _previewFocus.dispose();
    _uiController.dispose();
    super.dispose();
  }

  // ── JSON render / beautify ────────────────────────────────────────────

  void _render() {
    final source = _jsonCtrl.text;
    try {
      final parsed = jsonDecode(source);
      final components = UIComponent.fromJsonList(parsed);
      // Pretty-print the JSON back into the editor so the rendered source is
      // always tidy (2-space indent, stable key order from jsonDecode).
      _jsonCtrl.text = _beautify(parsed);
      setState(() {
        _components = components;
        _error = null;
      });
      _uiController.loadFromJson(parsed);
    } on FormatException catch (e) {
      setState(() => _error = 'JSON tidak valid: ${e.message}');
    } catch (e) {
      setState(() => _error = 'Gagal parse: $e');
    }
  }

  void _loadTemplate(PlaygroundTemplate t) {
    _jsonCtrl.text = t.json;
    _render();
  }

  void _formatJson() {
    try {
      final decoded = jsonDecode(_jsonCtrl.text);
      _jsonCtrl.text = _beautify(decoded);
      setState(() => _error = null);
    } catch (e) {
      setState(() => _error = 'Tidak bisa format: $e');
    }
  }

  /// Re-encode any decoded JSON value with a stable 2-space indent.
  String _beautify(dynamic decoded) =>
      const JsonEncoder.withIndent('  ').convert(decoded);

  // ── Find bar logic ────────────────────────────────────────────────────

  /// Listens to the editor's controller so matches stay in sync when the text
  /// changes (typing, beautify, template load). Guarded by [_lastText] so the
  /// selection we set here doesn't recurse.
  /// Controller listener: keeps the line-number gutter and (while the find
  /// bar is open) the search matches in sync. Guarded by
  /// [_applyingSelection] so the selections WE write (to highlight a match)
  /// don't recurse or trigger a "setState during build".
  void _onControllerChanged() {
    if (_applyingSelection) return;
    final t = _jsonCtrl.text;
    if (t == _lastText) {
      // Selection-only change (user moved the caret) → refresh the
      // current-line highlight in the gutter.
      if (mounted) setState(() {});
      return;
    }
    _lastText = t;
    _lineCount = '\n'.allMatches(t).length + 1;
    if (_searchOpen) _recomputeMatches();
    if (mounted) setState(() {});
  }

  void _toggleSearch() {
    setState(() {
      _searchOpen = !_searchOpen;
      if (_searchOpen) {
        _searchFocus.requestFocus();
      } else {
        _searchCtrl.clear();
        _query = '';
        _matchStarts = const [];
        _matchIndex = -1;
        // Drop the highlight (collapse selection to end without jumping much).
        _jsonCtrl.selection =
            TextSelection.collapsed(offset: _jsonCtrl.text.length);
      }
    });
  }

  void _onSearchChanged(String q) {
    _query = q;
    _recomputeMatches();
    setState(() {});
  }

  /// Key handler attached to the find box's [FocusNode].
  ///   Enter       → next match
  ///   Shift+Enter → previous match
  /// Cmd/Ctrl+Enter is ignored here so it bubbles up to the Render shortcut.
  /// We call the match navigation WITHOUT `scroll:false`, i.e. the editor is
  /// focused so the match highlight PAINTS and the view scrolls to it — that's
  /// what makes Enter behave exactly like clicking the ↓ button.
  KeyEventResult _onSearchKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey != LogicalKeyboardKey.enter) {
      return KeyEventResult.ignored;
    }
    final kb = HardwareKeyboard.instance;
    if (kb.isControlPressed || kb.isMetaPressed) {
      return KeyEventResult.ignored;
    }
    if (kb.isShiftPressed) {
      _prevMatch();
    } else {
      _nextMatch();
    }
    return KeyEventResult.handled;
  }

  /// Same Enter-cycling behavior as the search box, but attached to the
  /// editor's own [FocusNode]. After the first Enter moves focus to the
  /// editor (to paint the highlight), subsequent Enters are caught here so
  /// the user can keep cycling without re-focusing the find box — and
  /// (importantly) no newline is inserted while the find bar is open.
  KeyEventResult _onEditorKeyEvent(FocusNode node, KeyEvent event) {
    if (!_searchOpen) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey != LogicalKeyboardKey.enter) {
      return KeyEventResult.ignored;
    }
    final kb = HardwareKeyboard.instance;
    if (kb.isControlPressed || kb.isMetaPressed) {
      return KeyEventResult.ignored;
    }
    if (kb.isShiftPressed) {
      _prevMatch();
    } else {
      _nextMatch();
    }
    return KeyEventResult.handled;
  }

  void _recomputeMatches() {
    if (_query.isEmpty) {
      _matchStarts = const [];
      _matchIndex = -1;
      return;
    }
    final text = _jsonCtrl.text;
    final hay = _caseSensitive ? text : text.toLowerCase();
    final needle = _caseSensitive ? _query : _query.toLowerCase();
    final starts = <int>[];
    int from = 0;
    while (from <= text.length) {
      final i = hay.indexOf(needle, from);
      if (i == -1) break;
      starts.add(i);
      from = i + needle.length;
    }
    _matchStarts = starts;
    _matchIndex = starts.isEmpty ? -1 : 0;
    _applyCurrentSelection(scroll: false);
  }

  /// Highlights the current match by setting the editor's selection. When
  /// [scroll] is true, focus the editor so Flutter scrolls the selection into
  /// view. We don't steal focus on every keystroke (so the user can keep
  /// typing in the find box).
  void _applyCurrentSelection({required bool scroll}) {
    if (_matchIndex < 0 || _matchIndex >= _matchStarts.length) return;
    final start = _matchStarts[_matchIndex];
    final end = start + _query.length;
    // Guard our own selection write so the controller listener
    // ([_onControllerChanged]) doesn't recurse / rebuild mid-build.
    _applyingSelection = true;
    _jsonCtrl.selection = TextSelection(baseOffset: start, extentOffset: end);
    _applyingSelection = false;
    if (scroll) _editorFocus.requestFocus();
  }

  void _nextMatch({bool scroll = true}) {
    if (_matchStarts.isEmpty) return;
    setState(() {
      _matchIndex = (_matchIndex + 1) % _matchStarts.length;
      _applyCurrentSelection(scroll: scroll);
    });
  }

  void _prevMatch({bool scroll = true}) {
    if (_matchStarts.isEmpty) return;
    setState(() {
      _matchIndex =
          (_matchIndex - 1 + _matchStarts.length) % _matchStarts.length;
      _applyCurrentSelection(scroll: scroll);
    });
  }

  String get _matchLabel => _query.isEmpty
      ? ''
      : _matchStarts.isEmpty
          ? '0/0'
          : '${_matchIndex + 1}/${_matchStarts.length}';

  @override
  Widget build(BuildContext context) {
    final wide = !CofluiBreakpoints.isMobile(context);

    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          _FindIntent: CallbackAction<_FindIntent>(
            onInvoke: (_) => _toggleSearch(),
          ),
          _CloseSearchIntent: CallbackAction<_CloseSearchIntent>(
            onInvoke: (_) {
              if (_searchOpen) _toggleSearch();
              return null;
            },
          ),
          _RenderIntent: CallbackAction<_RenderIntent>(
            onInvoke: (_) => _render(),
          ),
        },
        child: Focus(
          autofocus: true,
          child: _scaffold(context, wide),
        ),
      ),
    );
  }

  Widget _scaffold(BuildContext context, bool wide) => Scaffold(
        appBar: AppBar(
          title: const Text('Playground — JSON → UI'),
          actions: [
            IconButton(
              tooltip: 'Format JSON',
              icon: const Icon(Icons.format_align_left),
              onPressed: _formatJson,
            ),
            PopupMenuButton<PlaygroundTemplate>(
              tooltip: 'Muat template',
              icon: const Icon(Icons.collections_bookmark_outlined),
              onSelected: _loadTemplate,
              itemBuilder: (_) => [
                for (final t in playgroundTemplates)
                  PopupMenuItem(
                    value: t,
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(t.name),
                      subtitle: Text(
                        t.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: wide ? _split(context) : _stacked(context),
      );

  // ── Layouts ─────────────────────────────────────────────────────────

  Widget _split(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final editorWidth = (totalWidth * _splitRatio).clamp(200.0, totalWidth - 200.0);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: editorWidth,
                child: _editorPane(context),
              ),
              _dragHandle(context, totalWidth),
              Expanded(child: _previewPane(context)),
            ],
          );
        },
      );

  /// The draggable divider between editor and preview. Drag left/right to
  /// resize the split. Cursor shows a resize shape on hover.
  Widget _dragHandle(BuildContext context, double totalWidth) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          final local = box.globalToLocal(details.globalPosition);
          setState(() {
            _splitRatio = (local.dx / totalWidth).clamp(0.2, 0.8);
          });
        },
        onDoubleTap: () => setState(() => _splitRatio = 0.5),
        child: Container(
          width: 8,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: 1,
            color: CofluiColors.divider,
          ),
        ),
      ),
    );
  }

  Widget _stacked(BuildContext context) => Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.42,
            child: _editorPane(context),
          ),
          const Divider(height: 1),
          Expanded(child: _previewPane(context)),
        ],
      );

  // ── Editor pane (with find bar) ──────────────────────────────────────

  Widget _editorPane(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: label + find toggle.
            Row(
              children: [
                const _PaneLabel('JSON Editor'),
                const Spacer(),
                IconButton(
                  tooltip: 'Cari (Ctrl/Cmd+F)',
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  isSelected: _searchOpen,
                  selectedIcon: const Icon(Icons.search_off),
                  icon: const Icon(Icons.search),
                  onPressed: _toggleSearch,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 150),
              child: _searchOpen
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _findBar(),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: _editorField(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CofluiColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: CofluiColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: CofluiColors.error,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            CofluiButton(
              label: 'Render ▶',
              icon: Icons.play_arrow,
              variant: CofluiButtonVariant.primary,
              fullWidth: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onPressed: _render,
            ),
          ],
        ),
      );

  Widget _findBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: CofluiColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CofluiColors.inputBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.search,
                size: 16, color: CofluiColors.onSurfaceVariant),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                focusNode: _searchFocus,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Cari...',
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                _matchLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: _matchStarts.isEmpty
                      ? CofluiColors.disabled
                      : CofluiColors.onSurfaceVariant,
                ),
              ),
            ),
            _iconBtn(
              tooltip: 'Case sensitive',
              icon: Icons.text_fields,
              toggled: _caseSensitive,
              onTap: () {
                setState(() {
                  _caseSensitive = !_caseSensitive;
                  _recomputeMatches();
                });
              },
            ),
            _iconBtn(
              tooltip: 'Sebelumnya (↑)',
              icon: Icons.keyboard_arrow_up,
              enabled: _matchStarts.isNotEmpty,
              onTap: () => _prevMatch(),
            ),
            _iconBtn(
              tooltip: 'Berikutnya (↓)',
              icon: Icons.keyboard_arrow_down,
              enabled: _matchStarts.isNotEmpty,
              onTap: () => _nextMatch(),
            ),
            _iconBtn(
              tooltip: 'Tutup (Esc)',
              icon: Icons.close,
              onTap: _toggleSearch,
            ),
          ],
        ),
      );

  Widget _iconBtn({
    required String tooltip,
    required IconData icon,
    bool toggled = false,
    bool enabled = true,
    required VoidCallback onTap,
  }) => IconButton(
    tooltip: tooltip,
    iconSize: 18,
    visualDensity: VisualDensity.compact,
    color: toggled
        ? CofluiColors.primary
        : (enabled ? CofluiColors.onSurfaceVariant : CofluiColors.disabled),
    icon: Icon(icon),
    onPressed: enabled ? onTap : null,
  );

  // ── Preview pane ────────────────────────────────────────────────────

  Widget _previewPane(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const _PaneLabel('Preview'),
                const Spacer(),
                ValueListenableBuilder<String>(
                  valueListenable: _uiController._actionLog,
                  builder: (_, log, __) => Text(
                    log,
                    style: TextStyle(
                      fontSize: 11,
                      color: CofluiColors.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _components.isEmpty
                    ? _empty(context)
                    : SelectableRegion(
                        focusNode: _previewFocus,
                        selectionControls: materialTextSelectionControls,
                        child: ListView(
                          key: ValueKey(_components.length),
                          padding: const EdgeInsets.only(bottom: 12),
                          children: [
                            for (final c in _components)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DynamicUIWidget(c, controller: _uiController),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      );

  // ── Editor field + line-number gutter ───────────────────────────────

  /// The monospace JSON editor wrapped with a synchronized line-number
  /// gutter on the left. The gutter scrolls in lockstep with the editor
  /// (same [ScrollController]) and highlights the caret's current line.
  Widget _editorField() {
    // Must match the editor TextStyle (fontSize 13 * height 1.4) so each
    // gutter line advances exactly one text line. No cumulative drift.
    const lineHeight = 18.2;
    const topPad = 12.0;
    return ListenableBuilder(
      listenable: _editorFocus,
      builder: (context, _) {
        final focused = _editorFocus.hasFocus;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: CofluiColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  focused ? CofluiColors.primary : CofluiColors.inputBorder,
              width: focused ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _lineNumberGutter(lineHeight: lineHeight, topPad: topPad),
              Container(width: 1, color: CofluiColors.divider),
              Expanded(
                child: TextField(
                  controller: _jsonCtrl,
                  focusNode: _editorFocus,
                  scrollController: _scrollCtrl,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.4,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Tulis JSON di sini...',
                    hintStyle: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                    isCollapsed: false,
                    contentPadding:
                        EdgeInsets.fromLTRB(8, topPad, 12, 12),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// The line-number column. It translates its content up by the editor's
  /// scroll offset (so it stays in sync) and clips to the visible area.
  Widget _lineNumberGutter({
    required double lineHeight,
    required double topPad,
  }) {
    final count = _lineCount;
    final current = _currentLine;
    return SizedBox(
      width: 38,
      child: ClipRect(
        child: ListenableBuilder(
          listenable: _scrollCtrl,
          builder: (_, __) {
            final offset = _scrollCtrl.hasClients ? _scrollCtrl.offset : 0.0;
            return OverflowBox(
              minHeight: 0,
              maxHeight: double.infinity,
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: Offset(0, -offset),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: topPad, bottom: lineHeight * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 1; i <= count; i++)
                        SizedBox(
                          height: lineHeight,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                '$i',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  height: 1.4,
                                  color: i == current
                                      ? CofluiColors.primary
                                      : CofluiColors.disabled,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// The 1-based line number under the caret (for the gutter highlight).
  int get _currentLine {
    final text = _jsonCtrl.text;
    final sel = _jsonCtrl.selection;
    if (!sel.isValid) return 1;
    final offset = sel.extentOffset.clamp(0, text.length);
    return '\n'.allMatches(text.substring(0, offset)).length + 1;
  }

  Widget _empty(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_outlined,
                size: 40, color: CofluiColors.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              'Komponen yang valid akan tampil di sini',
              style: TextStyle(color: CofluiColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

/// Shortcuts handled at the playground level: Ctrl/Cmd+F to open find,
/// Escape to close it, and Ctrl/Cmd+Enter to render the JSON.
const _shortcuts = <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.keyF, control: true): _FindIntent(),
  SingleActivator(LogicalKeyboardKey.keyF, meta: true): _FindIntent(),
  SingleActivator(LogicalKeyboardKey.enter, control: true): _RenderIntent(),
  SingleActivator(LogicalKeyboardKey.enter, meta: true): _RenderIntent(),
  SingleActivator(LogicalKeyboardKey.escape): _CloseSearchIntent(),
};

class _FindIntent extends Intent {
  const _FindIntent();
}

class _CloseSearchIntent extends Intent {
  const _CloseSearchIntent();
}

class _RenderIntent extends Intent {
  const _RenderIntent();
}

/// Tiny label with an accent dot for each pane header.
class _PaneLabel extends StatelessWidget {
  final String text;
  const _PaneLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: CofluiColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: CofluiColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Controller for the playground preview. Logs button actions so the user
/// can see them fire (proves the dynamic widgets are interactive).
class _PlaygroundController extends CofluiFormController {
  final ValueNotifier<String> _actionLog = ValueNotifier('Siap.');

  @override
  void onAction(String action, String componentId) {
    _actionLog.value = 'action: "$action" • id: "$componentId"';
  }
}
