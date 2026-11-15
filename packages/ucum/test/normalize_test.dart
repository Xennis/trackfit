import 'package:test/test.dart';
import 'package:ucum/ucum.dart';

void main() {
  const cases = {
    'µg/dl': 'ug/dL',
    'μg/dL': 'ug/dL',
    'mcg/dl': 'ug/dL',
    'mg/dl': 'mg/dL',
    'g/dl': 'g/dL',
    'g/l': 'g/L',
    'mmol/l': 'mmol/L',
    'µmol/l': 'umol/L',
    'nmol/l': 'nmol/L',
    'ng/ml': 'ng/mL',
    'pg/ml': 'pg/mL',
    'mg/l': 'mg/L',
    'U/l': 'U/L',
    'U/L': 'U/L',
    'IE/l': '[IU]/L',
    'mIU/l': 'm[IU]/L',
    'mU/l': 'mU/L',
    'µIU/ml': 'u[IU]/mL',
    'Tsd/µl': '10*3/uL',
    '10^3/µl': '10*3/uL',
    'x10^9/l': '10*9/L',
    'Gpt/l': '10*9/L',
    'Mio/µl': '10*6/uL',
    'Tpt/l': '10*12/L',
    '/µl': '/uL',
    '%': '%',
    'fl': 'fL',
    'pg': 'pg',
    'mm/h': 'mm/h',
    'mmHg': 'mm[Hg]',
    'ml/min/1,73m²': 'mL/min/{1.73_m2}',
    ' mg / dl ': 'mg/dL',
    'c/nl': '/nL',
    'c/pl': '/pL',
    'Zellen/µl': '/uL',
    'Mrd/ml': '10*9/mL',
    'Vol%': '%',
  };

  for (final MapEntry(key: printed, value: expected) in cases.entries) {
    test('normalizes "$printed"', () {
      expect(normalizeUnit(printed), expected);
    });
  }

  test('does not guess unknown units', () {
    for (final printed in ['', 'Stück', 'mg/kg/xyz', 'qq/l', 'mg/g']) {
      expect(normalizeUnit(printed), isNull, reason: printed);
    }
  });

  test('parses what it produces', () {
    for (final code in cases.values.toSet()) {
      final unit = parseUcum(code);
      final atomic =
          code == '%' ||
          code.contains('{') ||
          code.contains('[Hg]') ||
          code.contains('min') ||
          code.contains('h') ||
          code == 'fL' ||
          code == 'pg';
      if (!atomic) expect(unit, isNotNull, reason: code);
    }
  });
}
