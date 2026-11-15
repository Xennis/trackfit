import 'package:standardize/standardize.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  group('quantities', () {
    final cases = <String, (double, int, Comparator, String)>{
      '52': (52, 0, Comparator.none, ''),
      '12,9': (12.9, 1, Comparator.none, ''),
      '12.90': (12.9, 2, Comparator.none, ''),
      '<0,5': (0.5, 1, Comparator.lessThan, ''),
      '< 5': (5, 0, Comparator.lessThan, ''),
      '>= 90': (90, 0, Comparator.greaterOrEqual, ''),
      'unter 3': (3, 0, Comparator.lessThan, ''),
      '1.234,5': (1234.5, 1, Comparator.none, ''),
      '52 µg/dl': (52, 0, Comparator.none, 'µg/dl'),
      '-2': (-2, 0, Comparator.none, ''),
    };
    for (final MapEntry(key: printed, value: expected) in cases.entries) {
      test('"$printed"', () {
        final parsed = parseValue(printed);
        expect(parsed.kind, ValueKind.quantity);
        expect(parsed.number, closeTo(expected.$1, 1e-9));
        expect(parsed.decimals, expected.$2);
        expect(parsed.comparator, expected.$3);
        expect(parsed.unitInValue, expected.$4);
      });
    }
  });

  test('ordinals', () {
    expect(parseValue('++').code, '++');
    expect(parseValue('2+').code, '2+');
    expect(parseValue('(+)').kind, ValueKind.ordinal);
    expect(parseValue('Spuren').code, 'trace');
  });

  test('nominals', () {
    expect(parseValue('negativ').code, 'negative');
    expect(parseValue('Pos.').code, 'positive');
    expect(parseValue('nicht nachweisbar').code, 'not-detected');
  });

  test('absent values', () {
    expect(parseValue('').absentReason, 'not-reported');
    expect(parseValue('n.b.').absentReason, 'not-performed');
    expect(parseValue('folgt').absentReason, 'pending');
    expect(parseValue('k. Mat.').absentReason, 'no-specimen');
  });

  test('two readings in one cell stay narrative', () {
    expect(parseValue('120/80').kind, ValueKind.narrative);
    expect(parseValue('5-10').kind, ValueKind.narrative);
    expect(parseValue('siehe Text unten').kind, ValueKind.narrative);
  });
}
