import 'package:standardize/standardize.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';

import 'seed_terminology.dart';

void main() {
  final lexical = LexicalCoder(seedTerminology());

  CodingResult code(Coder coder, String name, String unit) => coder.code(
    nameKey: nameKey(name),
    unitUcum: unit,
    valueKind: ValueKind.quantity,
  );

  test('a confirmed alias names the analyte, the unit picks the code', () {
    final coder = AliasCoder(lexical, [
      ConfirmedAlias(nameKey: nameKey('Fe i.S.'), code: '2498-4'),
    ]);

    expect(code(coder, 'Fe i.S.', 'ug/dL').code, '2498-4');
    expect(code(coder, 'Fe i.S.', 'umol/L').code, '14798-3');
    expect(code(coder, 'Fe i.S.', 'ug/dL').rule, 'alias:person');
  });

  test('a name confirmed as not standard is refused', () {
    final coder = AliasCoder(lexical, [
      ConfirmedAlias(nameKey: nameKey('Bemerkung')),
    ]);

    final result = code(coder, 'Bemerkung', '');
    expect(result.outcome, CodingOutcome.refused);
    expect(result.reason, 'alias:not-standard');
  });

  test('an alias for one unit wins over one for all units', () {
    final coder = AliasCoder(lexical, [
      ConfirmedAlias(nameKey: 'x', code: '2498-4'),
      ConfirmedAlias(nameKey: 'x', unitUcum: '%', code: '2502-3'),
    ]);

    expect(code(coder, 'x', '%').code, '2502-3');
    expect(code(coder, 'x', 'ug/dL').code, '2498-4');
  });

  test('other names go to the resolver', () {
    final coder = AliasCoder(lexical, const []);

    expect(code(coder, 'Ferritin', 'ng/mL').rule, 'engine:lexical');
  });
}
