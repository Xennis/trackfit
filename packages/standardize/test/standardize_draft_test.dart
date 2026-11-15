import 'package:standardize/standardize.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  test('derives typed values from a printed reading', () {
    final reading = standardizeDraft(
      const ObservationDraft(
        name: 'Eisen ',
        value: '52',
        unit: 'µg/dl',
        reference: '60 - 170',
      ),
      const NoCoder(),
    );

    expect(reading.nameKey, 'eisen');
    expect(reading.value.number, 52);
    expect(reading.unitUcum, 'ug/dL');
    expect(reading.reference.low, 60);
    expect(reading.flag, Flag.low);
    expect(reading.coding.outcome, CodingOutcome.needsInput);
    expect(reading.seriesId, 'local:eisen|ug/dL');
    expect(reading.valueCanonical, isNull);
  });

  test('takes a unit printed in the value cell', () {
    final reading = standardizeDraft(
      const ObservationDraft(name: 'TSH', value: '1,2 mU/l'),
      const NoCoder(),
    );

    expect(reading.unitText, 'mU/l');
    expect(reading.unitUcum, 'mU/L');
  });
}
