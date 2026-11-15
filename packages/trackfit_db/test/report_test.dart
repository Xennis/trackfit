import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late int personId;

  setUp(() async {
    db = openTestDatabase();
    personId = await insertPerson(db);
  });
  tearDown(() => db.close());

  test('a new report is pending and has no date', () async {
    final id = await insertReport(db, personId);

    final row = await (db.select(
      db.report,
    )..where((r) => r.id.equals(id))).getSingle();
    expect(row.status, ReportStatus.pending);
    expect(row.reportDate, isNull);
    expect(row.dateSource, DateSource.unknown);
  });

  test('a failed report needs an error', () async {
    final insert = db
        .into(db.report)
        .insert(
          ReportCompanion.insert(
            personId: personId,
            createdAt: testNow,
            status: const Value(ReportStatus.failed),
          ),
        );

    await expectLater(insert, throwsA(isA<Exception>()));
  });

  test('a report date needs its source', () async {
    final insert = db
        .into(db.report)
        .insert(
          ReportCompanion.insert(
            personId: personId,
            createdAt: testNow,
            reportDate: const Value('2025-03-14'),
          ),
        );

    await expectLater(insert, throwsA(isA<Exception>()));
  });

  test('the same file cannot be imported twice', () async {
    final reportId = await insertReport(db, personId);
    await insertSourceFile(db, personId: personId, reportId: reportId);

    final otherReport = await insertReport(db, personId);
    final duplicate = insertSourceFile(
      db,
      personId: personId,
      reportId: otherReport,
    );

    await expectLater(duplicate, throwsA(isA<Exception>()));
  });

  test('files of a report keep their order', () async {
    final reportId = await insertReport(db, personId);
    await insertSourceFile(
      db,
      personId: personId,
      reportId: reportId,
      hash: 'b' * 64,
    );

    final samePosition = insertSourceFile(
      db,
      personId: personId,
      reportId: reportId,
      hash: 'c' * 64,
    );

    await expectLater(samePosition, throwsA(isA<Exception>()));
  });
}
