import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/registry/widget_registry.dart';
import 'package:coflui/src/widgets/coflui_button.dart';
import 'package:flutter/material.dart';

/// Builder untuk komponen action (`button`).
///
/// `props`:
/// - `variant`: `"primary" | "outline" | "danger" | "ghost"`
/// - `action`:  id aksi (dipass ke [CofluiFormControllerLike.onAction]).
///   Konvensi bawaan: `"submit"` | `"reset"` | custom.
/// - `widthInfinity`: bool (default true untuk primary)
/// - `icon`: nama IconData (material) — opsional
class ActionBuilders {
  ActionBuilders._();

  static Widget button(BuildContext ctx, UIComponent c, controller) {
    final props = c.props;
    final variant = _variantOf(props['variant']);
    final action = (props['action'] ?? 'submit').toString();
    final wantFullWidth = props['widthInfinity'] is bool
        ? props['widthInfinity'] as bool
        : (variant == CofluiButtonVariant.primary ||
            variant == CofluiButtonVariant.danger);

    final btn = CofluiButton(
      onPressed: () => controller.onAction(action, c.id),
      label: c.label ?? c.value?.toString() ?? 'Button',
      variant: variant,
      icon: _iconData(c.props['icon']?.toString()),
      fullWidth: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    if (!wantFullWidth) return btn;

    // Full-width HANYA bila parent memberi constraint lebar terbatas
    // (mis. di dalam Column). Di dalam Row constraint-nya unbounded
    // (maxWidth = infinity) → fallback ke ukuran intrinsik.
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth.isFinite && wantFullWidth
              ? SizedBox(width: constraints.maxWidth, child: btn)
              : btn,
    );
  }

  static CofluiButtonVariant _variantOf(dynamic v) {
    switch ((v ?? 'primary').toString().toLowerCase()) {
      case 'outline':
        return CofluiButtonVariant.outline;
      case 'danger':
        return CofluiButtonVariant.danger;
      case 'ghost':
        return CofluiButtonVariant.ghost;
      case 'primary':
      default:
        return CofluiButtonVariant.primary;
    }
  }

  static IconData? _iconData(String? name) {
    if (name == null) return null;
    const map = <String, IconData>{
      'send': Icons.send,
      'save': Icons.save,
      'delete': Icons.delete,
      'reset': Icons.refresh,
      'check': Icons.check,
      'add': Icons.add,
      'edit': Icons.edit,
      'close': Icons.close,
    };
    return map[name] ?? map[name.toLowerCase()];
  }
}
