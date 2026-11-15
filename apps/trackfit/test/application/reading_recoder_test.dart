import 'package:flutter_test/flutter_test.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/application/reading_recoder.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../helpers.dart';

void main() {
  test('codes readings of an older terminology again', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    // Imported before the terminology knew the name or the unit.
    await seedReport(
      db,
      reportDate: '2025-03-14',
      drafts: const [
        ObservationDraft(name: 'Leukocyten', value: '6,2', unit: 'c/nl'),
        ObservationDraft(name: 'Foobarin', value: '1', unit: 'mg/l'),
      ],
    );
    final coder = LexicalCoder(seedTerminology());

    final recoded = await ReadingRecoder(db: db).recodeOutdated(1, coder);

    expect(recoded, 2);
    final readings = await db.select(db.vObservation).get();
    final leukocytes = readings.firstWhere((r) => r.nameText == 'Leukocyten');
    expect(leukocytes.code, '6690-2');
    expect(leukocytes.unitUcum, '/nL');
    expect(leukocytes.unitText, 'c/nl');
    final unknown = readings.firstWhere((r) => r.nameText == 'Foobarin');
    expect(unknown.outcome, CodingOutcome.needsInput);
    expect(unknown.terminologyRelease, coder.release);

    expect(await ReadingRecoder(db: db).recodeOutdated(1, coder), 0);
  });
}
