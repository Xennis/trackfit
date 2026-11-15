import 'package:standardize/standardize.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

import 'seed_terminology.dart';

/// Lines as printed on lab reports and the code they must get.
const _golden = <(String name, String value, String unit, String code)>[
  ('Hämoglobin', '12,9', 'g/dl', '718-7'),
  ('Hb', '8,0', 'mmol/l', '59260-0'),
  ('Leukozyten', '6,5', 'Tsd/µl', '6690-2'),
  ('Leukos', '6,5', 'Gpt/l', '6690-2'),
  ('Erythrozyten', '4,5', 'Mio/µl', '789-8'),
  ('Hämatokrit', '41', '%', '4544-3'),
  ('MCV', '88', 'fl', '787-2'),
  ('Thrombozyten', '250', 'Tsd/µl', '777-3'),
  ('Eisen', '52', 'µg/dl', '2498-4'),
  ('Eisen', '9,3', 'µmol/l', '14798-3'),
  ('Ferritin', '18', 'ng/ml', '2276-4'),
  ('Transferrin', '310', 'mg/dl', '3034-6'),
  ('Transferrinsättigung', '14', '%', '2502-3'),
  ('Glukose nüchtern', '92', 'mg/dl', '2345-7'),
  ('Glucose', '5,1', 'mmol/l', '14749-6'),
  ('HbA1c', '5,4', '%', '4548-4'),
  ('Kreatinin', '0,9', 'mg/dl', '2160-0'),
  ('Kreatinin', '80', 'µmol/l', '14682-9'),
  ('eGFR (CKD-EPI)', '95', 'ml/min/1,73m²', '62238-1'),
  ('Harnsäure', '5,2', 'mg/dl', '3084-1'),
  ('Cholesterin gesamt', '193', 'mg/dl', '2093-3'),
  ('Cholesterin', '5,0', 'mmol/l', '14647-2'),
  ('HDL-Cholesterin', '55', 'mg/dl', '2085-9'),
  ('LDL-C', '2,48', 'mmol/l', '22748-8'),
  ('LDL Cholesterol', '101', 'mg/dl', '13457-7'),
  ('Triglyceride', '120', 'mg/dl', '2571-8'),
  ('GPT (ALAT)', '25', 'U/l', '1742-6'),
  ('GOT', '22', 'U/l', '1920-8'),
  ('Gamma-GT', '30', 'U/l', '2324-2'),
  ('γ-GT', '30', 'U/l', '2324-2'),
  ('TSH basal', '1,2', 'mIU/l', '3016-3'),
  ('TSH', '1,2', 'µIU/ml', '3016-3'),
  ('fT4', '1,3', 'ng/dl', '3024-7'),
  ('fT4', '16', 'pmol/l', '14920-3'),
  ('25-OH-Vitamin D', '24,3', 'ng/ml', '1989-3'),
  ('Vitamin D3 (25-OH)', '61', 'nmol/l', '62292-8'),
  ('Vitamin B12', '350', 'pg/ml', '2132-9'),
  ('Natrium', '140', 'mmol/l', '2951-2'),
  ('Kalium', '4,2', 'mmol/l', '2823-3'),
  ('Calcium', '2,4', 'mmol/l', '2000-8'),
  ('CRP', '<0,5', 'mg/l', '1988-5'),
  ('CRP', '0,3', 'mg/dl', '1988-5'),
  ('Ferritin*', '18', 'ng/ml', '2276-4'),
];

void main() {
  final coder = LexicalCoder(seedTerminology());

  CodingResult code(String name, String value, String unit) {
    final reading = standardizeDraft(
      ObservationDraft(name: name, value: value, unit: unit),
      coder,
    );
    return reading.coding;
  }

  group('golden lines', () {
    for (final (name, value, unit, expected) in _golden) {
      test('$name $value $unit', () {
        final result = code(name, value, unit);
        expect(result.outcome, CodingOutcome.coded, reason: result.reason);
        expect(result.code, expected);
      });
    }
  });

  test('iron, ferritin, transferrin and saturation stay apart', () {
    final groups = {
      code('Eisen', '52', 'µg/dl').groupId,
      code('Ferritin', '18', 'ng/ml').groupId,
      code('Transferrin', '310', 'mg/dl').groupId,
      code('Transferrinsättigung', '14', '%').groupId,
    };
    expect(groups, hasLength(4));
    expect(groups, isNot(contains(null)));
  });

  test('a category is refused', () {
    final result = code('Blutbild', '', '');
    expect(result.outcome, CodingOutcome.refused);
    expect(result.reason, 'engine:refused');
  });

  test('an unknown name needs input', () {
    final result = code('Foobarin', '3', 'mg/l');
    expect(result.outcome, CodingOutcome.needsInput);
    expect(result.reason, 'engine:no-match');
  });

  test('a missing unit needs input when codes differ by unit', () {
    expect(code('Glucose', '92', '').reason, 'unit:missing');
  });

  test('a unit that fits no code is a conflict', () {
    expect(code('Eisen', '52', 'U/l').reason, 'unit:conflict');
  });

  test('a qualitative value is not filed under a quantitative code', () {
    expect(code('Glucose', 'negativ', '').reason, startsWith('scale:'));
  });

  test('name and abbreviation must agree', () {
    expect(code('Blutzucker (HbA1c)', '5', '%').reason, 'name:ambiguous');
    expect(code('Glukose (GLU)', '92', 'mg/dl').code, '2345-7');
  });

  test('converts to the canonical unit of the analyte', () {
    final reading = standardizeDraft(
      const ObservationDraft(
        name: 'Vitamin D3 (25-OH)',
        value: '61',
        unit: 'nmol/l',
      ),
      coder,
    );
    expect(reading.valueCanonical, closeTo(24.44, 0.01));
    expect(reading.coding.canonicalUnit, 'ng/mL');
    expect(reading.seriesId, 'loinc:62292-8');
  });
}
