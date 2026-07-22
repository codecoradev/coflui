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
  final String? label;
  final String? hint;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? initialValue;

  const CofluiTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
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
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: CofluiTypography.body,
          color: CofluiColors.onSurfaceVariant,
        ),
        labelStyle: TextStyle(
          fontSize: CofluiTypography.caption,
          fontWeight: FontWeight.w600,
          color: CofluiColors.onSurfaceVariant,
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CofluiColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CofluiColors.error, width: 1.5),
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
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
