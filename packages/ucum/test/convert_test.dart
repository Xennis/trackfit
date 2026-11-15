import 'package:test/test.dart';
import 'package:ucum/ucum.dart';

void main() {
  test('converts within a dimension', () {
    expect(convertValue(52, 'ug/dL', 'ug/L'), closeTo(520, 1e-9));
    expect(convertValue(12.9, 'g/dL', 'g/L'), closeTo(129, 1e-9));
    expect(convertValue(6.5, '10*9/L', '10*3/uL'), closeTo(6.5, 1e-9));
    expect(convertValue(4.2, '10*6/uL', '10*12/L'), closeTo(4.2, 1e-9));
    expect(convertValue(2, 'mU/L', 'U/L'), closeTo(0.002, 1e-12));
  });

  test('converts mass and amount with a molar mass', () {
    // 25-OH vitamin D: 400.64 g/mol, 1 ng/mL = 2.496 nmol/L.
    expect(
      convertValue(24.3, 'ng/mL', 'nmol/L', molarMass: 400.64),
      closeTo(60.65, 0.01),
    );
    // Iron: 55.845 g/mol, 52 µg/dL = 9.31 µmol/L.
    expect(
      convertValue(52, 'ug/dL', 'umol/L', molarMass: 55.845),
      closeTo(9.31, 0.01),
    );
    expect(
      convertValue(9.31, 'umol/L', 'ug/dL', molarMass: 55.845),
      closeTo(52, 0.02),
    );
  });

  test('does not convert mass and amount without a molar mass', () {
    expect(convertValue(24.3, 'ng/mL', 'nmol/L'), isNull);
  });

  test('does not convert different measurements', () {
    expect(convertValue(60, '%', '10*3/uL'), isNull);
    expect(convertValue(1, 'U/L', '[IU]/L'), isNull);
    expect(convertValue(1, 'mg/dL', 'mmol/L', molarMass: 0), isNull);
    expect(canConvert('mm/h', 'mg/L'), isFalse);
  });

  test('converts a unit to itself', () {
    expect(convertValue(3, '%', '%'), 3);
  });
}
