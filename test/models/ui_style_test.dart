import 'package:coflui/src/dynamic/models/ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UIStyle.fromJson — color parsing', () {
    test('parses 6-digit hex #RRGGBB', () {
      final s = UIStyle.fromJson({'color': '#1A1A1A'});
      expect(s.color, const Color(0xFF1A1A1A));
    });

    test('parses hex without # prefix', () {
      final s = UIStyle.fromJson({'color': 'FF0000'});
      expect(s.color, const Color(0xFFFF0000));
    });

    test('parses 8-digit hex #AARRGGBB', () {
      final s = UIStyle.fromJson({'color': '#80FF0000'});
      expect(s.color, const Color(0x80FF0000));
    });

    test('expands 3-digit shorthand #RGB', () {
      final s = UIStyle.fromJson({'color': '#F00'});
      expect(s.color, const Color(0xFFFF0000));
    });

    test('expands 4-digit shorthand #RGBA', () {
      final s = UIStyle.fromJson({'color': '#8F00'});
      // #8F00 → hex chars: 8,F,0,0 → r=88, g=FF, b=00, a=00
      // reordered to ARGB: 00 88 FF 00 = 0x0088FF00
      expect(s.color, const Color(0x0088FF00));
    });

    test('parses bgColor alias backgroundColor', () {
      final s1 = UIStyle.fromJson({'bgColor': '#FFFFFF'});
      final s2 = UIStyle.fromJson({'backgroundColor': '#FFFFFF'});
      expect(s1.bgColor, s2.bgColor);
      expect(s1.bgColor, const Color(0xFFFFFFFF));
    });

    test('null color returns null', () {
      final s = UIStyle.fromJson({});
      expect(s.color, isNull);
    });

    test('invalid hex string returns null', () {
      final s = UIStyle.fromJson({'color': '#ZZZZZZ'});
      expect(s.color, isNull);
    });

    test('empty string returns null', () {
      final s = UIStyle.fromJson({'color': ''});
      expect(s.color, isNull);
    });

    test('whitespace is trimmed', () {
      final s = UIStyle.fromJson({'color': '  #FF0000  '});
      expect(s.color, const Color(0xFFFF0000));
    });
  });

  group('UIStyle.fromJson — fontWeight parsing', () {
    test('named weights', () {
      expect(UIStyle.fromJson({'fontWeight': 'bold'}).fontWeight, FontWeight.bold);
      expect(UIStyle.fromJson({'fontWeight': 'normal'}).fontWeight, FontWeight.normal);
    });

    test('w-prefixed numeric weights', () {
      expect(UIStyle.fromJson({'fontWeight': 'w100'}).fontWeight, FontWeight.w100);
      expect(UIStyle.fromJson({'fontWeight': 'w300'}).fontWeight, FontWeight.w300);
      expect(UIStyle.fromJson({'fontWeight': 'w500'}).fontWeight, FontWeight.w500);
      expect(UIStyle.fromJson({'fontWeight': 'w900'}).fontWeight, FontWeight.w900);
    });

    test('semantic weight names', () {
      expect(UIStyle.fromJson({'fontWeight': 'thin'}).fontWeight, FontWeight.w100);
      expect(UIStyle.fromJson({'fontWeight': 'light'}).fontWeight, FontWeight.w300);
      expect(UIStyle.fromJson({'fontWeight': 'regular'}).fontWeight, FontWeight.w400);
      expect(UIStyle.fromJson({'fontWeight': 'medium'}).fontWeight, FontWeight.w500);
      expect(UIStyle.fromJson({'fontWeight': 'semibold'}).fontWeight, FontWeight.w600);
      expect(UIStyle.fromJson({'fontWeight': 'extrabold'}).fontWeight, FontWeight.w800);
      expect(UIStyle.fromJson({'fontWeight': 'black'}).fontWeight, FontWeight.w900);
    });

    test('numeric weight as number', () {
      // FontWeight.values index: w100=0, w200=1, ..., w900=8
      final s = UIStyle.fromJson({'fontWeight': 7});
      expect(s.fontWeight, FontWeight.values[7]); // w800
    });

    test('is case-insensitive', () {
      expect(UIStyle.fromJson({'fontWeight': 'BOLD'}).fontWeight, FontWeight.bold);
      expect(UIStyle.fromJson({'fontWeight': 'Medium'}).fontWeight, FontWeight.w500);
    });

    test('null returns null', () {
      final s = UIStyle.fromJson({});
      expect(s.fontWeight, isNull);
    });

    test('unknown string returns null', () {
      final s = UIStyle.fromJson({'fontWeight': 'super-bold'});
      expect(s.fontWeight, isNull);
    });
  });

  group('UIStyle.fromJson — numeric fields', () {
    test('parses padding as double', () {
      final s = UIStyle.fromJson({'padding': 16});
      expect(s.padding, 16.0);
    });

    test('parses padding as string', () {
      final s = UIStyle.fromJson({'padding': '20'});
      expect(s.padding, 20.0);
    });

    test('parses paddingHorizontal alias px', () {
      expect(UIStyle.fromJson({'px': 12}).paddingHorizontal, 12.0);
      expect(UIStyle.fromJson({'paddingHorizontal': 12}).paddingHorizontal, 12.0);
    });

    test('parses paddingVertical alias py', () {
      expect(UIStyle.fromJson({'py': 8}).paddingVertical, 8.0);
      expect(UIStyle.fromJson({'paddingVertical': 8}).paddingVertical, 8.0);
    });

    test('parses fontSize', () {
      expect(UIStyle.fromJson({'fontSize': 14}).fontSize, 14.0);
    });

    test('parses radius', () {
      expect(UIStyle.fromJson({'radius': 12}).radius, 12.0);
    });

    test('parses elevation', () {
      expect(UIStyle.fromJson({'elevation': 4}).elevation, 4.0);
    });

    test('parses borderWidth', () {
      expect(UIStyle.fromJson({'borderWidth': 2}).borderWidth, 2.0);
    });

    test('parses gap', () {
      expect(UIStyle.fromJson({'gap': 10}).gap, 10.0);
    });

    test('parses widthFactor', () {
      expect(UIStyle.fromJson({'widthFactor': 1.0}).widthFactor, 1.0);
    });
  });

  group('UIStyle.fromJson — other fields', () {
    test('parses fontStyle', () {
      final s = UIStyle.fromJson({'fontStyle': 'italic'});
      expect(s.fontStyle, 'italic');
    });

    test('parses align', () {
      expect(UIStyle.fromJson({'align': 'center'}).align, 'center');
    });

    test('parses maxLines as int', () {
      expect(UIStyle.fromJson({'maxLines': 3}).maxLines, 3);
    });

    test('parses crossAxis', () {
      expect(UIStyle.fromJson({'crossAxis': 'center'}).crossAxis, 'center');
    });

    test('parses mainAxis', () {
      expect(UIStyle.fromJson({'mainAxis': 'spaceBetween'}).mainAxis, 'spaceBetween');
    });

    test('parses expand as bool', () {
      expect(UIStyle.fromJson({'expand': true}).expand, isTrue);
    });

    test('non-bool expand is null', () {
      expect(UIStyle.fromJson({'expand': 'yes'}).expand, isNull);
    });
  });

  group('UIStyle.fromJson — edge cases', () {
    test('null returns empty style', () {
      final s = UIStyle.fromJson(null);
      expect(s, same(UIStyle.empty));
    });

    test('non-Map (string) returns empty style', () {
      final s = UIStyle.fromJson('token-name');
      expect(s, same(UIStyle.empty));
    });

    test('non-Map (int) returns empty style', () {
      final s = UIStyle.fromJson(42);
      expect(s, same(UIStyle.empty));
    });

    test('empty Map returns all-null style', () {
      final s = UIStyle.fromJson({});
      expect(s.padding, isNull);
      expect(s.color, isNull);
      expect(s.fontSize, isNull);
    });
  });

  group('UIStyle.copyWith', () {
    test('returns self when other is null', () {
      const original = UIStyle(fontSize: 14, color: Colors.red);
      expect(original.copyWith(null), same(original));
    });

    test('overrides only provided fields', () {
      const original = UIStyle(fontSize: 14, color: Colors.red);
      final merged = original.copyWith(const UIStyle(fontSize: 18));
      expect(merged.fontSize, 18);     // overridden
      expect(merged.color, Colors.red); // kept from original
    });

    test('fills all fields from empty original', () {
      const empty = UIStyle.empty;
      final merged = empty.copyWith(const UIStyle(padding: 10, radius: 8));
      expect(merged.padding, 10);
      expect(merged.radius, 8);
    });
  });
}
