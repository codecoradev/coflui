import 'package:coflui/src/dynamic/controllers/coflui_form_controller.dart';
import 'package:coflui/src/dynamic/models/ui_component.dart';
import 'package:coflui/src/dynamic/registry/widget_registry.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test JSON trees used across multiple test groups.
const _simpleForm = [
  {'id': 'name', 'type': 'textfield', 'value': 'Budi'},
  {'id': 'email', 'type': 'textfield', 'value': 'budi@test.com'},
  {
    'id': 'section',
    'type': 'card',
    'children': [
      {'id': 'nested_field', 'type': 'switch', 'value': true},
    ],
  },
];

void main() {
  group('CofluiFormController.loadFromJson', () {
    test('parses JSON list and populates components', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      expect(c.components.length, 3);
      expect(c.components[0].id, 'name');
    });

    test('seeds field values from component value', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      expect(c.getValue('name'), 'Budi');
      expect(c.getValue('email'), 'budi@test.com');
    });

    test('seeds nested field values via traverse', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      expect(c.getValue('nested_field'), true);
    });

    test('handles single Map (not a List)', () {
      final c = CofluiFormController()
        ..loadFromJson({'id': 'root', 'type': 'text', 'value': 'hello'});
      expect(c.components.length, 1);
      expect(c.getValue('root'), 'hello');
    });

    test('handles empty list', () {
      final c = CofluiFormController()..loadFromJson([]);
      expect(c.components, isEmpty);
    });

    test('handles null', () {
      final c = CofluiFormController()..loadFromJson(null);
      expect(c.components, isEmpty);
    });

    test('notifies listeners after load', () {
      final c = CofluiFormController();
      var notified = 0;
      c.addListener(() => notified++);
      c.loadFromJson(_simpleForm);
      expect(notified, 1);
    });

    test('replaces previous components on re-load', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      expect(c.components.length, 3);

      c.loadFromJson([
        {'id': 'only', 'type': 'text'},
      ]);
      expect(c.components.length, 1);
      expect(c.components[0].id, 'only');
    });
  });

  group('CofluiFormController.getValue / setValue', () {
    test('getValue returns null for unknown id', () {
      final c = CofluiFormController();
      expect(c.getValue('nonexistent'), isNull);
    });

    test('setValue stores and getValue retrieves', () {
      final c = CofluiFormController();
      c.setValue('foo', 'bar');
      expect(c.getValue('foo'), 'bar');
    });

    test('setValue overwrites existing value', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      c.setValue('name', 'Andi');
      expect(c.getValue('name'), 'Andi');
    });

    test('setValue does NOT trigger notifyListeners (granular by design)', () {
      final c = CofluiFormController();
      var notified = 0;
      c.addListener(() => notified++);
      c.setValue('foo', 'bar');
      expect(notified, 0);
    });

    test('handles various value types', () {
      final c = CofluiFormController();
      c.setValue('str', 'text');
      c.setValue('int', 42);
      c.setValue('double', 3.14);
      c.setValue('bool', true);
      c.setValue('list', [1, 2, 3]);
      c.setValue('map', {'a': 1});
      c.setValue('null', null);

      expect(c.getValue('str'), 'text');
      expect(c.getValue('int'), 42);
      expect(c.getValue('double'), 3.14);
      expect(c.getValue('bool'), isTrue);
      expect(c.getValue('list'), [1, 2, 3]);
      expect(c.getValue('map'), {'a': 1});
      expect(c.getValue('null'), isNull);
    });
  });

  group('CofluiFormController.snapshot', () {
    test('returns id→value map for all fields', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      final snap = c.snapshot();
      expect(snap['name'], 'Budi');
      expect(snap['email'], 'budi@test.com');
      expect(snap['nested_field'], isTrue);
    });

    test('reflects updated values after setValue', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      c.setValue('name', 'Changed');
      final snap = c.snapshot();
      expect(snap['name'], 'Changed');
    });

    test('includes manually set values not in original JSON', () {
      final c = CofluiFormController();
      c.setValue('extra', 'val');
      expect(c.snapshot()['extra'], 'val');
    });

    test('snapshot is a copy (mutating does not affect controller)', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      final snap = c.snapshot();
      snap['name'] = 'HACKED';
      // Controller value is untouched.
      expect(c.getValue('name'), 'Budi');
    });
  });

  group('CofluiFormController.resetValues', () {
    test('restores initial values from JSON', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      // Mutate.
      c.setValue('name', 'Changed');
      c.setValue('nested_field', false);
      expect(c.getValue('name'), 'Changed');

      // Reset.
      c.resetValues();
      expect(c.getValue('name'), 'Budi');
      expect(c.getValue('nested_field'), isTrue);
    });

    test('notifies listeners', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      var notified = 0;
      c.addListener(() => notified++);
      c.resetValues();
      expect(notified, 1);
    });

    test('fields without initial value reset to null', () {
      final c = CofluiFormController();
      c.setValue('temp', 'will-reset');
      c.loadFromJson([{'id': 'temp', 'type': 'text'}]);
      // The component's value is null → after reset it should be null.
      c.setValue('temp', 'changed');
      c.resetValues();
      expect(c.getValue('temp'), isNull);
    });
  });

  group('CofluiFormController.seedValues', () {
    test('injects values into fields', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      c.seedValues({'name': 'Seeded', 'new_field': 'extra'});
      expect(c.getValue('name'), 'Seeded');
      expect(c.getValue('new_field'), 'extra');
    });

    test('notifies listeners', () {
      final c = CofluiFormController();
      var notified = 0;
      c.addListener(() => notified++);
      c.seedValues({'a': 1});
      expect(notified, 1);
    });

    test('can be called before loadFromJson', () {
      final c = CofluiFormController();
      c.seedValues({'pre': 'value'});
      expect(c.getValue('pre'), 'value');
    });
  });

  group('CofluiFormController.fieldListenable', () {
    test('returns ValueListenable for seeded field', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      final listenable = c.fieldListenable('name');
      expect(listenable, isNotNull);
      expect(listenable!.value, 'Budi');
    });

    test('returns null for unknown field', () {
      final c = CofluiFormController();
      expect(c.fieldListenable('nope'), isNull);
    });

    test('listenable reflects setValue changes', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      final listenable = c.fieldListenable('name')!;
      expect(listenable.value, 'Budi');

      c.setValue('name', 'Updated');
      expect(listenable.value, 'Updated');
    });
  });

  group('CofluiFormController.readOnly', () {
    test('defaults to false', () {
      expect(CofluiFormController().readOnly, isFalse);
    });

    test('can be set to true', () {
      final c = CofluiFormController(readOnly: true);
      expect(c.readOnly, isTrue);
    });

    test('can be toggled after construction', () {
      final c = CofluiFormController();
      c.readOnly = true;
      expect(c.readOnly, isTrue);
    });
  });

  group('CofluiFormController.onAction', () {
    test('default implementation does nothing (no throw)', () {
      final c = CofluiFormController();
      // Should not throw.
      c.onAction('submit', 'btn1');
    });

    test('subclass override receives action and id', () {
      String? capturedAction;
      String? capturedId;

      final c = _ActionSpyController()
        ..onActionHandler = (action, id) {
          capturedAction = action;
          capturedId = id;
        };

      c.onAction('submit', 'btn1');
      expect(capturedAction, 'submit');
      expect(capturedId, 'btn1');
    });
  });

  group('CofluiFormController.dispose', () {
    test('can be called without error', () {
      final c = CofluiFormController()..loadFromJson(_simpleForm);
      // Should not throw.
      c.dispose();
    });
  });

  group('CofluiFormControllerLike interface', () {
    test('CofluiFormController implements the interface', () {
      CofluiFormControllerLike ctrl = CofluiFormController();
      expect(ctrl, isA<CofluiFormControllerLike>());
    });

    test('all 4 interface methods are accessible via interface type', () {
      CofluiFormControllerLike ctrl = CofluiFormController()
        ..loadFromJson(_simpleForm);

      // readOnly getter
      expect(ctrl.readOnly, isFalse);
      // getValue
      expect(ctrl.getValue('name'), 'Budi');
      // setValue
      ctrl.setValue('name', 'X');
      expect(ctrl.getValue('name'), 'X');
      // onAction
      ctrl.onAction('test', 'id');
    });
  });
}

/// Test subclass that captures onAction calls.
class _ActionSpyController extends CofluiFormController {
  void Function(String action, String id)? onActionHandler;

  @override
  void onAction(String action, String componentId) {
    onActionHandler?.call(action, componentId);
  }
}


