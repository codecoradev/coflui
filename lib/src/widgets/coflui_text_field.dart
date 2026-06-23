import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A thin wrapper over [TextFormField] with Coflui styling.
///
/// Used by the dynamic `textfield` builder and by hand-written forms. Keeps a
/// managed internal [TextEditingController] when none is supplied.
class CofluiTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  const CofluiTextField({
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.enabled = true,
    this.obscureText = false,
    this.inputFormatters,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<CofluiTextField> createState() => _CofluiTextFieldState();
}

class _CofluiTextFieldState extends State<CofluiTextField> {
  TextEditingController? _owned;

  @override
  void initState() {
    super.initState();
    _owned = widget.controller == null
        ? TextEditingController(text: widget.initialValue)
        : null;
  }

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller ?? _owned!;
    final maxLines = widget.maxLines;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: CofluiTypography.body,
          color: CofluiColors.onSurfaceVariant,
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CofluiColors.inputBorder),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CofluiColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      style: TextStyle(
        fontSize: CofluiTypography.body,
        color: CofluiColors.onSurface,
      ),
      keyboardType: widget.keyboardType,
      maxLines: maxLines,
      minLines: widget.minLines ?? maxLines,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
    );
  }
}
