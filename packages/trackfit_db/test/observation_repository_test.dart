import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late ObservationRepository observations;
  late int personId;
  late int reportId;

  setUp(() async {
    db = openTestDatabase();
    observations = ObservationRepository(db);
    personId = await insertPerson(db);
    reportId = await insertReport(db, personId);
  });
  tearDown(() => db.close());

  NewObservation reading(String name, {int row = 0}) => NewObservation(
    labObservation(personId: personId, name: name).copyWith(
      reportId: Value(reportId),
      sourceRecordId: Value('row:$row'),
      rowIx: Value(row),
    ),
    CodingInput(
      terminologyRelease: testRelease,
      outcome: CodingOutcome.needsInput,
      reason: 'engine:no-match',
      rule: 'engine:lexical',
      seriesId: 'local:${name.toLowerCase()}|ug/dL',
    ),
  );

  test('writes a reading with coding, decision and history', () async {
    final id = await observations.insert(reading('Eisen'), now: testNow);

    final current = await db.select(db.codingCurrent).getSingle();
    expect(current.observationId, id);
    expect(await db.select(db.codingDecision).get(), hasLength(1));
    expect(await db.select(db.codingHistory).get(), hasLength(1));
    final shown = await observations.watchReportReadings(reportId).first;
    expect(shown.single.nameText, 'Eisen');
  });

  test('readings with the same key share one decision', () async {
    await observations.insert(reading('Eisen'), now: testNow);
    await observations.insert(reading('Eisen', row: 1), now: testNow);

    expect(await db.select(db.codingDecision).get(), hasLength(1));
  });

  test('reading a report again replaces its readings', () async {
    await observations.replaceReportReadings(reportId, [
      reading('Eisen'),
      reading('Ferritin', row: 1),
    ], now: testNow);

    await observations.replaceReportReadings(reportId, [
      reading('Eisen'),
    ], now: testNow);

    final shown = await observations.watchReportReadings(reportId).first;
    expect(shown.map((o) => o.nameText), ['Eisen']);
  });

  test('a corrected reading survives reading the report again', () async {
    final original = await observations.insert(reading('Eisen'), now: testNow);
    await observations.insert(
      NewObservation(
        reading('Eisen').row.copyWith(
          valueNum: const Value(55),
          amends: Value(original),
          modality: const Value(Modality.manual),
        ),
        reading('Eisen').coding,
      ),
      now: testNow,
    );

    await observations.replaceReportReadings(reportId, [], now: testNow);

    final shown = await observations.watchReportReadings(reportId).first;
    expect(shown.single.valueNum, 55);
  });
  test('a correction replaces the reading and keeps the original', () async {
    final original = await observations.insert(reading('Eisen'), now: testNow);

    await observations.amend(
      original,
      NewObservation(
        reading('Eisen').row.copyWith(valueNum: const Value(25)),
        reading('Eisen').coding,
      ),
      now: testNow,
    );

    final shown = await observations.watchReportReadings(reportId).first;
    expect(shown.single.valueNum, 25);
    expect((await observations.get(original)).valueNum, 52);
  });

  test('a retracted reading disappears but stays stored', () async {
    final id = await observations.insert(reading('Eisen'), now: testNow);

    await observations.retract(id, now: testNow);

    expect(await observations.watchReportReadings(reportId).first, isEmpty);
    expect(await db.select(db.observation).get(), hasLength(2));
  });
}
