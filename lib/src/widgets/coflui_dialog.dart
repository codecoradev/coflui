import 'package:flutter/material.dart';

/// Convenience helpers for showing simple dialogs/alerts.
///
/// Built on plain `showDialog` + [AlertDialog] so the package stays
/// dependency-free. Used by the dynamic renderer and directly in app code.
class CofluiDialog {
  CofluiDialog._();

  /// Show a simple alert dialog with an OK button.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String body,
    String okLabel = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(okLabel),
          ),
        ],
      ),
    );
  }

  /// Show a confirm dialog returning `true` when the user accepts.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String body,
    String okLabel = 'Ya',
    String cancelLabel = 'Batal',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(okLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
