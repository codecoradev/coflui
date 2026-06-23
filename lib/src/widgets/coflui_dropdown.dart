import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:flutter/material.dart';

/// A thin wrapper over [DropdownButtonFormField] with Coflui styling.
class CofluiDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  const CofluiDropdown({
    super.key,
    this.value,
    this.hint,
    required this.items,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CofluiColors.inputBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hint ?? '',
            style: TextStyle(
              fontSize: CofluiTypography.body,
              color: CofluiColors.onSurfaceVariant,
            ),
          ),
          isExpanded: true,
          items: items,
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}
