// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

/// Resolves a JSON icon name (or code-point) into a Flutter [IconData].
///
/// Dynamic-UI JSON can't reference Flutter's [Icons] constants directly, so
/// this maps common Material icon **names** to their [IconData]. It also
/// accepts an integer code-point via `'0xe5c9'` style hex strings.
///
/// Used by the `icon` / `detailRow` builders and available for any builder
/// that needs icon-from-JSON resolution.
class IconResolver {
  const IconResolver._();

  /// Common Material icon names → [IconData].
  static const Map<String, IconData> map = {
    // Actions
    'send': Icons.send,
    'save': Icons.save,
    'delete': Icons.delete,
    'remove': Icons.remove,
    'reset': Icons.refresh,
    'refresh': Icons.refresh,
    'check': Icons.check,
    'check_circle': Icons.check_circle,
    'add': Icons.add,
    'edit': Icons.edit,
    'create': Icons.edit,
    'close': Icons.close,
    'clear': Icons.clear,
    'cancel': Icons.cancel,
    'search': Icons.search,
    'filter': Icons.filter_list,
    'sort': Icons.sort,
    'done': Icons.done,
    'arrow_back': Icons.arrow_back,
    'arrow_forward': Icons.arrow_forward,
    'arrow_upward': Icons.arrow_upward,
    'arrow_downward': Icons.arrow_downward,
    'expand_more': Icons.expand_more,
    'expand_less': Icons.expand_less,
    'chevron_right': Icons.chevron_right,
    'chevron_left': Icons.chevron_left,
    // Navigation
    'home': Icons.home,
    'menu': Icons.menu,
    'dashboard': Icons.dashboard,
    'person': Icons.person,
    'people': Icons.people,
    'settings': Icons.settings,
    'more_vert': Icons.more_vert,
    'more_horiz': Icons.more_horiz,
    // Content
    'description': Icons.description,
    'article': Icons.article,
    'document': Icons.description,
    'folder': Icons.folder,
    'image': Icons.image,
    'photo': Icons.photo,
    'picture': Icons.image,
    'picture_as_pdf': Icons.picture_as_pdf,
    'pdf': Icons.picture_as_pdf,
    'attachment': Icons.attach_file,
    'attach_file': Icons.attach_file,
    'download': Icons.download,
    'upload': Icons.upload,
    'cloud_upload': Icons.cloud_upload,
    'cloud_download': Icons.cloud_download,
    'file_copy': Icons.file_copy,
    'link': Icons.link,
    // Communication
    'email': Icons.email,
    'mail': Icons.mail,
    'phone': Icons.phone,
    'call': Icons.call,
    'message': Icons.message,
    'chat': Icons.chat,
    'notifications': Icons.notifications,
    'bell': Icons.notifications,
    // People / social
    'account': Icons.account_circle,
    'account_circle': Icons.account_circle,
    'group': Icons.group,
    'verified_user': Icons.verified_user,
    'admin': Icons.admin_panel_settings,
    'badge': Icons.badge,
    // Status
    'info': Icons.info,
    'warning': Icons.warning,
    'error': Icons.error,
    'success': Icons.check_circle,
    'pending': Icons.pending,
    'clock': Icons.access_time,
    'time': Icons.access_time,
    'schedule': Icons.schedule,
    'calendar': Icons.calendar_today,
    'calendar_today': Icons.calendar_today,
    'event': Icons.event,
    'history': Icons.history,
    'visibility': Icons.visibility,
    'visibility_off': Icons.visibility_off,
    'lock': Icons.lock,
    'unlock': Icons.lock_open,
    'key': Icons.key,
    'fingerprint': Icons.fingerprint,
    // Commerce
    'shopping_cart': Icons.shopping_cart,
    'cart': Icons.shopping_cart,
    'payment': Icons.payment,
    'receipt': Icons.receipt,
    'money': Icons.attach_money,
    'currency': Icons.attach_money,
    // Misc
    'star': Icons.star,
    'favorite': Icons.favorite,
    'heart': Icons.favorite,
    'share': Icons.share,
    'copy': Icons.copy,
    'print': Icons.print,
    'visibility_on': Icons.visibility,
    'help': Icons.help,
    'help_outline': Icons.help_outline,
    'lightbulb': Icons.lightbulb,
    'flag': Icons.flag,
    'tag': Icons.label,
    'label': Icons.label,
    'location': Icons.location_on,
    'location_on': Icons.location_on,
    'place': Icons.place,
    'gavel': Icons.gavel,
    'shield': Icons.shield,
    'security': Icons.security,
    'verified': Icons.verified,
    'task': Icons.task_alt,
    'task_alt': Icons.task_alt,
  };

  /// Resolves [value] (String name, hex code-point, or int) into [IconData].
  ///
  /// Returns `null` when the value can't be resolved.
  static IconData? resolve(dynamic value) {
    if (value == null) return null;
    if (value is IconData) return value;
    if (value is int) return IconData(value, fontFamily: 'MaterialIcons');
    final s = value.toString().trim();
    if (s.isEmpty) return null;

    // Hex code-point e.g. "0xe5c9" or "#e5c9".
    if (s.startsWith('0x') || s.startsWith('0X')) {
      final cp = int.tryParse(s.substring(2), radix: 16);
      if (cp != null) return IconData(cp, fontFamily: 'MaterialIcons');
    }

    // Named icon (try exact then lowercase).
    final exact = map[s];
    if (exact != null) return exact;
    final lower = map[s.toLowerCase()];
    return lower;
  }
}
