import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/models/ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UIType.fromString', () {
    test('maps core container types', () {
      expect(UIType.fromString('column'), UIType.column);
      expect(UIType.fromString('row'), UIType.row);
      expect(UIType.fromString('grid'), UIType.grid);
      expect(UIType.fromString('card'), UIType.card);
      expect(UIType.fromString('section'), UIType.section);
    });

    test('maps display types', () {
      expect(UIType.fromString('text'), UIType.text);
      expect(UIType.fromString('heading'), UIType.heading);
      expect(UIType.fromString('divider'), UIType.divider);
    });

    test('maps input types', () {
      expect(UIType.fromString('textfield'), UIType.textfield);
      expect(UIType.fromString('dropdown'), UIType.dropdown);
      expect(UIType.fromString('switch'), UIType.switchField);
      expect(UIType.fromString('datepicker'), UIType.datePicker);
      expect(UIType.fromString('checkbox'), UIType.checkbox);
    });

    test('maps action types', () {
      expect(UIType.fromString('button'), UIType.button);
      expect(UIType.fromString('btn'), UIType.button);
    });

    test('aliases resolve correctly', () {
      expect(UIType.fromString('input'), UIType.textfield);
      expect(UIType.fromString('textarea'), UIType.textfield);
      expect(UIType.fromString('select'), UIType.dropdown);
      expect(UIType.fromString('date'), UIType.datePicker);
      expect(UIType.fromString('date_picker'), UIType.datePicker);
      expect(UIType.fromString('title'), UIType.heading);
    });

    test('is case-insensitive', () {
      expect(UIType.fromString('COLUMN'), UIType.column);
      expect(UIType.fromString('TextField'), UIType.textfield);
      expect(UIType.fromString('DropDown'), UIType.dropdown);
    });

    test('null falls back to text', () {
      expect(UIType.fromString(null), UIType.text);
    });

    test('unknown string falls back to text', () {
      expect(UIType.fromString('chart'), UIType.text);
      expect(UIType.fromString('nonexistent'), UIType.text);
      expect(UIType.fromString(''), UIType.text);
    });
  });

  group('UIComponent.fromJson', () {
    test('parses a minimal leaf node', () {
      final c = UIComponent.fromJson({
        'id': 'name',
        'type': 'text',
        'label': 'Name',
      });
      expect(c.id, 'name');
      expect(c.type, UIType.text);
      expect(c.label, 'Name');
      expect(c.value, isNull);
      expect(c.props, isEmpty);
      expect(c.children, isEmpty);
    });

    test('parses a node with value and props', () {
      final c = UIComponent.fromJson({
        'id': 'email',
        'type': 'textfield',
        'value': 'test@example.com',
        'props': {'hint': 'Email', 'keyboard': 'email'},
      });
      expect(c.id, 'email');
      expect(c.type, UIType.textfield);
      expect(c.value, 'test@example.com');
      expect(c.props['hint'], 'Email');
      expect(c.props['keyboard'], 'email');
    });

    test('parses style block', () {
      final c = UIComponent.fromJson({
        'id': 't',
        'type': 'text',
        'style': {'fontSize': 16, 'fontWeight': 'bold'},
      });
      expect(c.style.fontSize, 16);
      expect(c.style.fontWeight, FontWeight.bold);
    });

    test('parses nested children recursively', () {
      final c = UIComponent.fromJson({
        'id': 'root',
        'type': 'column',
        'children': [
          {'id': 'c1', 'type': 'text'},
          {
            'id': 'c2',
            'type': 'card',
            'children': [
              {'id': 'c2a', 'type': 'text'},
              {'id': 'c2b', 'type': 'button'},
            ],
          },
        ],
      });
      expect(c.children.length, 2);
      expect(c.children[0].id, 'c1');
      expect(c.children[1].children.length, 2);
      expect(c.children[1].children[0].id, 'c2a');
      expect(c.children[1].children[1].id, 'c2b');
    });

    test('auto-generates id when omitted', () {
      final c = UIComponent.fromJson({'type': 'text'});
      expect(c.id, isNotEmpty);
      expect(c.id.startsWith('_'), isTrue);
    });

    test('uses "key" as id fallback', () {
      final c = UIComponent.fromJson({'key': 'alt_id', 'type': 'text'});
      expect(c.id, 'alt_id');
    });

    test('handles missing props gracefully', () {
      final c = UIComponent.fromJson({'id': 't', 'type': 'text'});
      expect(c.props, isEmpty);
    });

    test('handles missing style gracefully', () {
      final c = UIComponent.fromJson({'id': 't', 'type': 'text'});
      expect(c.style, same(UIStyle.empty));
    });

    test('handles non-Map children gracefully', () {
      final c = UIComponent.fromJson({
        'id': 't',
        'type': 'column',
        'children': 'not a list',
      });
      expect(c.children, isEmpty);
    });
  });

  group('UIComponent.fromJsonList', () {
    test('parses a JSON array', () {
      final list = UIComponent.fromJsonList([
        {'id': 'a', 'type': 'text'},
        {'id': 'b', 'type': 'heading'},
      ]);
      expect(list.length, 2);
      expect(list[0].id, 'a');
      expect(list[1].id, 'b');
    });

    test('wraps a single Map into a one-element list', () {
      final list = UIComponent.fromJsonList({'id': 'root', 'type': 'card'});
      expect(list.length, 1);
      expect(list[0].id, 'root');
    });

    test('returns empty list for null', () {
      expect(UIComponent.fromJsonList(null), isEmpty);
    });

    test('returns empty list for non-Map/non-List types', () {
      expect(UIComponent.fromJsonList('string'), isEmpty);
      expect(UIComponent.fromJsonList(42), isEmpty);
    });
  });

  group('UIComponent.findById', () {
    test('finds root node by id', () {
      final c = UIComponent.fromJson({
        'id': 'root',
        'type': 'column',
        'children': [{'id': 'child', 'type': 'text'}],
      });
      expect(c.findById('root'), same(c));
    });

    test('finds direct child', () {
      final c = UIComponent.fromJson({
        'id': 'root',
        'type': 'column',
        'children': [{'id': 'child', 'type': 'text'}],
      });
      final found = c.findById('child');
      expect(found, isNotNull);
      expect(found!.id, 'child');
    });

    test('finds deeply nested child', () {
      final c = UIComponent.fromJson({
        'id': 'root',
        'type': 'column',
        'children': [
          {
            'id': 'level1',
            'type': 'card',
            'children': [
              {
                'id': 'level2',
                'type': 'row',
                'children': [{'id': 'target', 'type': 'text'}],
              },
            ],
          },
        ],
      });
      final found = c.findById('target');
      expect(found, isNotNull);
      expect(found!.id, 'target');
    });

    test('returns null for non-existent id', () {
      final c = UIComponent.fromJson({'id': 'root', 'type': 'text'});
      expect(c.findById('nonexistent'), isNull);
    });
  });

  group('UIComponent.traverse', () {
    test('visits root and all descendants depth-first', () {
      final c = UIComponent.fromJson({
        'id': 'root',
        'type': 'column',
        'children': [
          {'id': 'a', 'type': 'text'},
          {
            'id': 'b',
            'type': 'card',
            'children': [{'id': 'b1', 'type': 'text'}],
          },
        ],
      });
      final visited = <String>[];
      c.traverse((node) => visited.add(node.id));
      expect(visited, ['root', 'a', 'b', 'b1']);
    });

    test('callback called once for leaf node', () {
      final c = UIComponent.fromJson({'id': 'leaf', 'type': 'text'});
      final visited = <String>[];
      c.traverse((node) => visited.add(node.id));
      expect(visited, ['leaf']);
    });
  });

  group('UIComponentProps extension', () {
    test('stringProp reads from props.value then component.value', () {
      var c = UIComponent.fromJson({
        'id': 't', 'type': 'text', 'props': {'value': 'fromProps'},
      });
      expect(c.stringProp, 'fromProps');

      c = UIComponent.fromJson({'id': 't', 'type': 'text', 'value': 'fromValue'});
      expect(c.stringProp, 'fromValue');
    });

    test('boolProp reads bool from props.value or component.value', () {
      var c = UIComponent.fromJson({
        'id': 't', 'type': 'switch', 'props': {'value': true},
      });
      expect(c.boolProp, isTrue);

      c = UIComponent.fromJson({'id': 't', 'type': 'switch', 'value': false});
      expect(c.boolProp, isFalse);

      c = UIComponent.fromJson({'id': 't', 'type': 'switch'});
      expect(c.boolProp, isNull);
    });
  });
}
