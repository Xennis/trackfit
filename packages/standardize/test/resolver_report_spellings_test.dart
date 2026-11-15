import 'package:standardize/standardize.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

import 'seed_terminology.dart';

/// Names and units as printed by German labs and blood donation services,
/// with made-up values, and the code they must get.
const _cases = <(String name, String value, String unit, String code)>[
  ('Basophile (Zentrallabor)', '0,6', '%', '706-2'),
  ('Basophile (Zentrallabor)', '0,04', '/nl', '704-7'),
  ('Eosinophile (Zentrallabor)', '2,1', '%', '713-8'),
  ('Eosinophile (Zentrallabor)', '0,15', '/nl', '711-2'),
  ('Lymphozyten (Zentrallabor)', '30', '%', '736-9'),
  ('Lymphozyten (Zentrallabor)', '1,9', '/nl', '731-0'),
  ('Monozyten (Zentrallabor)', '8', '%', '5905-5'),
  ('Monozyten (Zentrallabor)', '0,5', '/nl', '742-7'),
  ('Neutrophile (Zentrallabor)', '58', '%', '770-8'),
  ('Neutrophile (Zentrallabor)', '3,6', '/nl', '751-8'),
  ('EVB (Zentrallabor)', '12,9', '%', '788-0'),
  ('Albumin (Zentrallabor)', '45', 'g/l', '1751-7'),
  ('Gesamteiweiß', '72', 'g/l', '2885-2'),
  ('Gesamteiweiss', '7,2', 'g/dl', '2885-2'),
  ('Haematokrit (Zentrallabor)', '42', '%', '4544-3'),
  ('HKT', '42', 'Vol%', '4544-3'),
  ('ERY', '4,8', 'c/pl', '789-8'),
  ('Erythrozyten (Zentrallabor)', '4,8', 'Mrd/ml', '789-8'),
  ('Leukocyten', '6,2', 'c/nl', '6690-2'),
  ('Leukozytenzahl (Freigabeparameter)', '6,2', '/nl', '6690-2'),
  ('Thrombocyten', '250', 'c/nl', '777-3'),
  ('Hämoglobinkonzentration (Freigabeparameter)', '14,1', 'g/dl', '718-7'),
  ('ALT Freigabe', '21', 'IU/L', '1742-6'),
  ('Vitamin B 12', '420', 'pg/ml', '2132-9'),
  ('HBsAg Screening', 'negativ', '', '5195-3'),
  ('Anti-HBc Screening', 'negativ', '', '16933-4'),
  ('Anti-HCV Screening', 'negativ', '', '16128-1'),
  ('Anti-HIV-1/-2 Screening', 'negativ', '', '7918-6'),
  ('Treponema Pallidum Antikörper - Screening', 'negativ', '', '22587-0'),
  ('Anti-CMV Screening', 'positiv', '', '22244-8'),
  ('HBV-PCR Screening (Pool)', 'negativ', '', '29610-3'),
  ('HCV-PCR Screening (Pool)', 'negativ', '', '11259-9'),
  ('HIV1-PCR Screening (Pool)', 'negativ', '', '25835-0'),
  ('HEV-PCR Screening (Pool)', 'negativ', '', '90460-7'),
  ('(SE) Ferritin', '35', 'µg/l', '2276-4'),
  ('(SE) Folsäure', '6,1', 'µg/l', '2284-8'),
  ('(SE) Vitamin B12', '380', 'ng/l', '2132-9'),
  ('(SE) Vitamin D (25-OH-Cholecalciferol)', '28', 'µg/l', '1989-3'),
  ('Vitamin B2', '210', 'µg/l', '2924-9'),
  ('Zink i.S.', '0,9', 'mg/l', '5763-8'),
  ('Zink', '13', 'µmol/l', '14955-9'),
  ('Magnesium (Serum)', '0,85', 'mmol/l', '2601-3'),
  ('Lymphozyten abs.', '1,8', '/nl', '731-0'),
  ('Lymphozyten rel.', '29', '%', '736-9'),
  ('Neutrophile absolut', '3,9', '/nl', '751-8'),
  ('eGFR nach MDRD', '95', 'ml/min', '33914-3'),
  ('eGFR (CKD-EPI)', '95', 'ml/min', '62238-1'),
  ('Quick-Wert', '98', '%', '5894-1'),
  ('INR', '1,02', '', '6301-6'),
  ('aPTT', '29,5', 'sec', '14979-9'),
  ('PTT', 'k. Mat.', 'sec.', '14979-9'),
  ('INR', 'k. Mat.', '', '6301-6'),
];

void main() {
  final coder = LexicalCoder(seedTerminology());

  for (final (name, value, unit, expected) in _cases) {
    test('$name $value $unit', () {
      final coding = standardizeDraft(
        ObservationDraft(name: name, value: value, unit: unit),
        coder,
      ).coding;
      expect(coding.outcome, CodingOutcome.coded, reason: coding.reason);
      expect(coding.code, expected);
    });
  }

  test('percent and count of one cell type are different series', () {
    final percent = standardizeDraft(
      const ObservationDraft(name: 'Lymphozyten', value: '30', unit: '%'),
      coder,
    );
    final count = standardizeDraft(
      const ObservationDraft(name: 'Lymphozyten', value: '1,9', unit: '/nl'),
      coder,
    );
    expect(percent.coding.groupId, isNot(count.coding.groupId));
  });

  test('a cell type without unit needs input', () {
    final coding = standardizeDraft(
      const ObservationDraft(name: 'Lymphozyten', value: '30'),
      coder,
    ).coding;
    expect(coding.outcome, CodingOutcome.needsInput);
    expect(coding.reason, 'unit:missing');
  });
}
