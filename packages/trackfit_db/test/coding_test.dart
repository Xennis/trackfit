import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late int observationId;
  late String decisionId;

  setUp(() async {
    db = openTestDatabase();
    final personId = await insertPerson(db);
    observationId = await db
        .into(db.observation)
        .insert(labObservation(personId: personId));
    decisionId = await insertDecision(db);
  });
  tearDown(() => db.close());

  final rejected = throwsA(isA<Exception>());

  test('stores a coded reading', () async {
    await db
        .into(db.codingCurrent)
        .insert(codedAs(observationId: observationId, decisionId: decisionId));

    final row = await db.select(db.codingCurrent).getSingle();
    expect(row.outcome, CodingOutcome.coded);
    expect(row.code, '2498-4');
  });

  test('a reading without code needs a reason', () async {
    await expectLater(
      db
          .into(db.codingCurrent)
          .insert(
            codedAs(
              observationId: observationId,
              decisionId: decisionId,
              outcome: CodingOutcome.needsInput,
              code: null,
            ),
          ),
      rejected,
    );
  });

  test('stores an open question', () async {
    await db
        .into(db.codingCurrent)
        .insert(
          codedAs(
            observationId: observationId,
            decisionId: decisionId,
            outcome: CodingOutcome.needsInput,
            code: null,
            reason: 'engine:no-match',
          ),
        );

    final row = await db.select(db.codingCurrent).getSingle();
    expect(row.seriesId, 'local:eisen|ug/dL');
  });

  test('only a coded reading has a code', () async {
    await expectLater(
      db
          .into(db.codingCurrent)
          .insert(
            codedAs(
              observationId: observationId,
              decisionId: decisionId,
              outcome: CodingOutcome.refused,
              reason: 'engine:refused',
            ),
          ),
      rejected,
    );
  });

  test('a reading has one current coding', () async {
    final row = codedAs(observationId: observationId, decisionId: decisionId);
    await db.into(db.codingCurrent).insert(row);

    await expectLater(db.into(db.codingCurrent).insert(row), rejected);
  });
}
