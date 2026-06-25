import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/registry/widget_registry.dart';
import 'package:coflui/src/theme/coflui_colors.dart';
import 'package:coflui/src/theme/coflui_typography.dart';
import 'package:coflui/src/widgets/coflui_dropdown.dart';
import 'package:coflui/src/widgets/coflui_text.dart';
import 'package:coflui/src/widgets/coflui_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builder untuk komponen input (textfield, dropdown, switch, date_picker,
/// checkbox). Semua perubahan nilai di-sync ke [CofluiFormControllerLike].
class InputBuilders {
  InputBuilders._();

  /// Builds a [CofluiTextField] from a JSON `textfield` component.
  /// Value changes are synced to the controller via [setValue].
  static Widget textfield(BuildContext ctx, UIComponent c, controller) =>
      _TextFieldBuilder(component: c, controller: controller);

  /// Builds a [CofluiDropdown] from a JSON `dropdown` component.
  /// Selection changes are synced to the controller.
  static Widget dropdown(BuildContext ctx, UIComponent c, controller) =>
      _DropdownBuilder(component: c, controller: controller);

  /// Builds a toggle [Switch] from a JSON `switch` component.
  static Widget switchField(BuildContext ctx, UIComponent c, controller) =>
      _SwitchBuilder(component: c, controller: controller);

  /// Builds a date-picker field from a JSON `datepicker` component.
  /// Value is stored as `yyyy-MM-dd` string.
  static Widget datePicker(BuildContext ctx, UIComponent c, controller) =>
      _DatePickerBuilder(component: c, controller: controller);

  /// Builds a [Checkbox] from a JSON `checkbox` component.
  static Widget checkbox(BuildContext ctx, UIComponent c, controller) =>
      _SwitchBuilder(
          component: c, controller: controller, useCheckbox: true);
}

// ---------------------------------------------------------------------------
// Label helper
// ---------------------------------------------------------------------------

Widget _buildLabel(UIComponent c) {
  if (c.label?.isEmpty != false) return const SizedBox.shrink();
  final required = c.props['required'] == true;
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: CofluiText(
      required ? '${c.label} *' : (c.label ?? ''),
      style: TextStyle(
        fontSize: CofluiTypography.caption,
        fontWeight: FontWeight.w600,
        color: CofluiColors.onSurfaceVariant,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// TextField
// ---------------------------------------------------------------------------

class _TextFieldBuilder extends StatefulWidget {
  final UIComponent component;
  final CofluiFormControllerLike controller;
  const _TextFieldBuilder({required this.component, required this.controller});

  @override
  State<_TextFieldBuilder> createState() => _TextFieldBuilderState();
}

class _TextFieldBuilderState extends State<_TextFieldBuilder> {
  late final TextEditingController _tc;

  @override
  void initState() {
    super.initState();
    final initial = widget.controller.getValue(widget.component.id) ??
        widget.component.value ??
        '';
    _tc = TextEditingController(text: initial.toString());
    // Sinkronkan nilai awal ke controller supaya ikut ke-snapshot.
    widget.controller.setValue(widget.component.id, _tc.text);
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.component;
    final props = c.props;
    final maxLines =
        props['maxLines'] is int ? props['maxLines'] as int : null;
    final keyboardType = _keyboardOf(props['keyboard']);
    final disabled = widget.controller.readOnly ||
        (props['enabled'] is bool ? !(props['enabled'] as bool) : false);

    final formatters = <TextInputFormatter>[
      if (keyboardType == TextInputType.number)
        FilteringTextInputFormatter.digitsOnly,
      if (props['maxLength'] is int)
        LengthLimitingTextInputFormatter(props['maxLength'] as int),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel(c),
        CofluiTextField(
          controller: _tc,
          hint: props['hint'] as String?,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: props['multiline'] == true ? maxLines : null,
          enabled: !disabled,
          inputFormatters: formatters,
          onChanged: (v) => widget.controller.setValue(c.id, v),
        ),
      ],
    );
  }

  TextInputType _keyboardOf(dynamic k) {
    switch ((k ?? '').toString().toLowerCase()) {
      case 'number':
      case 'numeric':
        return TextInputType.number;
      case 'phone':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      case 'url':
        return TextInputType.url;
      case 'multiline':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }
}

// ---------------------------------------------------------------------------
// Dropdown
// ---------------------------------------------------------------------------

class _DropdownBuilder extends StatefulWidget {
  final UIComponent component;
  final CofluiFormControllerLike controller;
  const _DropdownBuilder({required this.component, required this.controller});

  @override
  State<_DropdownBuilder> createState() => _DropdownBuilderState();
}

class _DropdownBuilderState extends State<_DropdownBuilder> {
  dynamic _value;

  @override
  void initState() {
    super.initState();
    _value = widget.controller.getValue(widget.component.id) ??
        widget.component.value;
    widget.controller.setValue(widget.component.id, _value);
  }

  List<Map<String, dynamic>> get _options {
    final raw = widget.component.props['options'];
    if (raw is! List) return const [];
    return raw
        .map((e) =>
            e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.component;
    final options = _options;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel(c),
        CofluiDropdown<dynamic>(
          value: _value,
          hint: (c.props['hint'] as String?) ?? 'Pilih ${c.label ?? ''}',
          enabled: !(c.props['enabled'] == false ||
              widget.controller.readOnly),
          items: options
              .map((o) => DropdownMenuItem<dynamic>(
                    value: o['value'],
                    child: Text(
                      (o['label'] ?? o['value']).toString(),
                      style: TextStyle(
                        fontSize: CofluiTypography.body,
                        color: CofluiColors.onSurface,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (v) {
            setState(() => _value = v);
            widget.controller.setValue(c.id, v);
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Switch / Checkbox
// ---------------------------------------------------------------------------

class _SwitchBuilder extends StatefulWidget {
  final UIComponent component;
  final CofluiFormControllerLike controller;
  final bool useCheckbox;
  const _SwitchBuilder({
    required this.component,
    required this.controller,
    this.useCheckbox = false,
  });

  @override
  State<_SwitchBuilder> createState() => _SwitchBuilderState();
}

class _SwitchBuilderState extends State<_SwitchBuilder> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.controller.getValue(widget.component.id) is bool
        ? widget.controller.getValue(widget.component.id) as bool
        : (widget.component.value is bool
            ? widget.component.value as bool
            : false);
    widget.controller.setValue(widget.component.id, _value);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.component;
    final disabled = widget.controller.readOnly;
    return InkWell(
      onTap: disabled ? null : _toggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            widget.useCheckbox
                ? Checkbox(
                    value: _value,
                    onChanged: disabled ? null : (_) => _toggle(),
                  )
                : Switch(
                    value: _value,
                    onChanged: disabled ? null : (_) => _toggle(),
                  ),
            Expanded(
              child: CofluiText(
                c.label ?? '',
                style: TextStyle(
                  fontSize: CofluiTypography.body,
                  color: CofluiColors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle() {
    setState(() => _value = !_value);
    widget.controller.setValue(widget.component.id, _value);
  }
}

// ---------------------------------------------------------------------------
// Date Picker
// ---------------------------------------------------------------------------

class _DatePickerBuilder extends StatefulWidget {
  final UIComponent component;
  final CofluiFormControllerLike controller;
  const _DatePickerBuilder({required this.component, required this.controller});

  @override
  State<_DatePickerBuilder> createState() => _DatePickerBuilderState();
}

class _DatePickerBuilderState extends State<_DatePickerBuilder> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    final raw =
        widget.controller.getValue(widget.component.id) ?? widget.component.value;
    _value = _parseDate(raw);
    if (_value != null) {
      widget.controller.setValue(widget.component.id, _format(_value));
    }
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }

  static String _format(DateTime? d) {
    if (d == null) return '';
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.component;
    final disabled = widget.controller.readOnly;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel(c),
        InkWell(
          onTap: disabled ? null : () => _pick(context),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CofluiColors.inputBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _value != null
                        ? _format(_value)
                        : (c.props['hint'] ?? 'Pilih tanggal'),
                    style: TextStyle(
                      fontSize: CofluiTypography.body,
                      color: _value != null
                          ? CofluiColors.onSurface
                          : CofluiColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pick(BuildContext ctx) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: ctx,
      initialDate: _value ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() => _value = picked);
      widget.controller.setValue(widget.component.id, _format(picked));
    }
  }
}
