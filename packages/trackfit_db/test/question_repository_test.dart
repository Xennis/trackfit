import 'package:drift/drift.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late QuestionRepository questions;
  late ObservationRepository observations;
  late int personId;
  var row = 0;

  setUp(() async {
    db = openTestDatabase();
    questions = QuestionRepository(db);
    observations = ObservationRepository(db);
    personId = await insertPerson(db);
  });
  tearDown(() => db.close());

  Future<int> open(String name, String date) => observations.insert(
    NewObservation(
      labObservation(
        personId: personId,
        name: name,
      ).copyWith(localDate: Value(date), sourceRecordId: Value('row:${row++}')),
      CodingInput(
        terminologyRelease: testRelease,
        outcome: CodingOutcome.needsInput,
        reason: 'engine:no-match',
        rule: 'engine:lexical',
        seriesId: 'local:${name.toLowerCase()}|ug/dL',
      ),
    ),
    now: testNow,
  );

  test('one question per printed name and unit', () async {
    await open('Fe-Sätt.', '2024-01-01');
    await open('Fe-Sätt.', '2025-01-01');
    await open('Foo', '2025-01-01');

    final open_ = await questions.watchOpen(personId).first;

    expect(open_, hasLength(2));
    final first = open_.firstWhere((q) => q.nameKey == 'fe-sätt.');
    expect(first.readings, hasLength(2));
    expect(first.example.localDate, '2025-01-01');
    expect(first.reason, 'engine:no-match');
  });

  test('stores answers and finds the readings they apply to', () async {
    await open('Fe-Sätt.', '2024-01-01');
    await questions.confirm(
      personId: personId,
      nameKey: 'fe-sätt.',
      codeSystem: 'http://loinc.org',
      code: '2502-3',
      now: testNow,
    );
    await questions.confirm(
      personId: personId,
      nameKey: 'fe-sätt.',
      codeSystem: 'http://loinc.org',
      code: '2502-3',
      now: testNow,
    );

    expect(await questions.aliases(personId), hasLength(1));
    final readings = await questions.openReadingsNamed(personId, 'fe-sätt.');
    expect(readings, hasLength(1));
  });
}
