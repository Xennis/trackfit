import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  group('ObservationDraft', () {
    test('round-trips through json', () {
      const draft = ObservationDraft(
        name: 'Eisen',
        value: '52',
        unit: 'µg/dl',
        reference: '60 - 170',
        flag: 'L',
        specimen: 'Serum',
        panel: 'Eisenstoffwechsel',
        page: 1,
      );

      expect(ObservationDraft.fromJson(draft.toJson()), draft);
    });

    test('leaves out empty fields in json', () {
      expect(const ObservationDraft(name: 'TSH').toJson(), {'name': 'TSH'});
    });

    test('accepts numbers as values', () {
      final draft = ObservationDraft.fromJson({'name': 'Hb', 'value': 12.9});

      expect(draft.value, '12.9');
    });

    test('rejects a missing or blank name', () {
      expect(
        () => ObservationDraft.fromJson({'value': '1'}),
        throwsFormatException,
      );
      expect(
        () => ObservationDraft.fromJson({'name': '  '}),
        throwsFormatException,
      );
    });

    test('rejects a page that is not an integer', () {
      expect(
        () => ObservationDraft.fromJson({'name': 'Hb', 'page': '1'}),
        throwsFormatException,
      );
    });
  });
}
