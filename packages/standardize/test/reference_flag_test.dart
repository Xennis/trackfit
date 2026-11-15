import 'package:standardize/standardize.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

void main() {
  group('parseReference', () {
    test('two-sided ranges', () {
      for (final printed in [
        '60 - 170',
        '60-170',
        '60–170 µg/dl',
        '60 bis 170',
      ]) {
        final range = parseReference(printed);
        expect((range.low, range.high), (60, 170), reason: printed);
      }
      final decimals = parseReference('0,1 - 4,0');
      expect((decimals.low, decimals.high), (0.1, 4.0));
    });

    test('one-sided ranges', () {
      final upper = parseReference('< 5,0');
      expect((upper.low, upper.high), (null, 5.0));
      expect(upper.comparator, Comparator.lessThan);
      final lower = parseReference('> 30');
      expect((lower.low, lower.high), (30, null));
      expect(parseReference('bis 40').high, 40);
    });

    test('no bounds', () {
      expect(parseReference('negativ').isEmpty, isTrue);
      expect(parseReference('').isEmpty, isTrue);
      expect(parseReference('170 - 60').isEmpty, isTrue);
    });
  });

  group('normalizeFlag', () {
    test('a printed flag wins', () {
      expect(normalizeFlag('L'), Flag.low);
      expect(normalizeFlag('↑'), Flag.high);
      expect(normalizeFlag('HH'), Flag.criticalHigh);
      expect(normalizeFlag('*'), Flag.abnormal);
      expect(normalizeFlag('?'), Flag.abnormal);
    });

    test('derives low and high from the range', () {
      final range = parseReference('60 - 170');
      expect(normalizeFlag('', value: 52, reference: range), Flag.low);
      expect(normalizeFlag('', value: 180, reference: range), Flag.high);
      expect(normalizeFlag('', value: 100, reference: range), Flag.none);
      final upper = parseReference('< 5');
      expect(normalizeFlag('', value: 5, reference: upper), Flag.high);
      expect(normalizeFlag('', value: 4.9, reference: upper), Flag.none);
    });

    test('no value, no flag', () {
      expect(normalizeFlag(''), Flag.none);
    });
  });
}
