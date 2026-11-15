import 'package:standardize/standardize.dart';
import 'package:test/test.dart';

void main() {
  const cases = {
    'Eisen': 'eisen',
    '  25-OH-Vitamin  D ': '25-oh-vitamin d',
    'Ferritin:': 'ferritin',
    'GPT (ALAT).': 'gpt (alat)',
    'ＨＤＬ－Ｃ': 'hdl-c',
    '白细胞 计数': '白细胞计数',
    'Hämoglobin': 'hämoglobin',
  };

  for (final MapEntry(key: printed, value: expected) in cases.entries) {
    test('folds "$printed"', () => expect(nameKey(printed), expected));
  }

  test('does not translate or expand', () {
    expect(nameKey('Hb'), 'hb');
    expect(nameKey('Glucose im Urin'), 'glucose im urin');
  });
}
