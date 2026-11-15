import 'package:test/test.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  test('foreign keys are enforced', () async {
    await expectLater(insertReport(db, 42), throwsA(isA<Exception>()));
  });

  test('deleting a report deletes its files', () async {
    final personId = await insertPerson(db);
    final reportId = await insertReport(db, personId);
    await insertSourceFile(db, personId: personId, reportId: reportId);

    await (db.delete(db.report)..where((r) => r.id.equals(reportId))).go();

    expect(await db.select(db.sourceFile).get(), isEmpty);
  });
}
