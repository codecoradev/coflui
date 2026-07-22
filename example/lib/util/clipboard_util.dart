// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

/// Cross-platform clipboard writer.
///
/// Flutter's stock `Clipboard.setData` sometimes fails silently on web
/// (secure-context / focus / permission quirks). This helper uses the
/// browser's native `navigator.clipboard.writeText` on web with a hidden
/// textarea + `execCommand('copy')` fallback, and `Clipboard.setData` on
/// native platforms.
///
/// Returns `true` when the write was confirmed.
Future<bool> copyToClipboard(String text) async {
  if (kIsWeb) {
    return _copyWeb(text);
  }
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  } catch (_) {
    return false;
  }
}

// ── Web implementation ─────────────────────────────────────────────────────

Future<bool> _copyWeb(String text) async {
  // 1. Preferred: async Clipboard API (secure context — localhost / https).
  //    navigator.clipboard is null outside a secure context, so guard.
  final clipboard = html.window.navigator.clipboard;
  if (clipboard != null) {
    try {
      await clipboard.writeText(text);
      return true;
    } catch (_) {
      // Fall through to legacy fallback (blocked, permission denied, etc.).
    }
  }

  // 2. Legacy fallback: hidden textarea + execCommand('copy'). Works in
  //    non-secure contexts and older browsers.
  return _legacyCopy(text);
}

bool _legacyCopy(String text) {
  final doc = html.document;
  final textarea = html.TextAreaElement()..value = text;
  // Place off-screen so it's invisible but selectable.
  textarea.style
    ..position = 'fixed'
    ..top = '-9999px'
    ..left = '-9999px';
  doc.body?.append(textarea);
  textarea.focus();
  textarea.select();

  var ok = false;
  try {
    ok = doc.execCommand('copy');
  } catch (_) {
    ok = false;
  }
  textarea.remove();
  return ok;
}
