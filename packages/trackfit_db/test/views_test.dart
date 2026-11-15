import 'package:drift/drift.dart';
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late int personId;
  late String decisionId;

  setUp(() async {
    db = openTestDatabase();
    personId = await insertPerson(db);
    decisionId = await insertDecision(db);
  });
  tearDown(() => db.close());

  Future<int> insertCoded(ObservationCompanion row) async {
    final id = await db.into(db.observation).insert(row);
    await db
        .into(db.codingCurrent)
        .insert(codedAs(observationId: id, decisionId: decisionId));
    return id;
  }

  group('v_observation', () {
    test('joins coding and concept', () async {
      await db
          .into(db.concept)
          .insert(
            ConceptCompanion.insert(
              terminologyRelease: testRelease,
              codeSystem: 'http://loinc.org',
              code: '2498-4',
              display: 'Iron [Mass/volume] in Serum or Plasma',
              displayDe: const Value('Eisen'),
            ),
          );
      await insertCoded(labObservation(personId: personId));

      final row = await db.select(db.vObservation).getSingle();
      expect(row.code, '2498-4');
      expect(row.displayDe, 'Eisen');
      expect(row.valueKind, ValueKind.quantity);
    });

    test('shows only the latest correction', () async {
      final original = await insertCoded(labObservation(personId: personId));
      await insertCoded(
        labObservation(personId: personId, valueNum: 25, amends: original),
      );

      final rows = await db.select(db.vObservation).get();
      expect(rows.single.valueNum, 25);
    });

    test('hides a value entered in error', () async {
      final original = await insertCoded(labObservation(personId: personId));
      await insertCoded(
        labObservation(
          personId: personId,
          status: ObservationStatus.enteredInError,
          amends: original,
        ),
      );

      expect(await db.select(db.vObservation).get(), isEmpty);
    });
  });

  test('v_report_page counts pages across the files of a report', () async {
    final reportId = await insertReport(db, personId);
    final first = await insertSourceFile(
      db,
      personId: personId,
      reportId: reportId,
      hash: 'a' * 64,
    );
    final second = await insertSourceFile(
      db,
      personId: personId,
      reportId: reportId,
      position: 1,
      hash: 'b' * 64,
    );
    Future<void> page(int fileId, int pageIx) => db
        .into(db.sourcePage)
        .insert(
          SourcePageCompanion.insert(
            sourceFileId: fileId,
            pageIx: pageIx,
            textOrigin: 'ocr:test',
            markdown: '$fileId/$pageIx',
            createdAt: testNow,
          ),
        );
    await page(second, 0);
    await page(first, 1);
    await page(first, 0);

    final pages = await (db.select(
      db.vReportPage,
    )..orderBy([(p) => OrderingTerm.asc(p.reportPageIx)])).get();

    expect(pages.map((p) => p.reportPageIx), [0, 1, 2]);
    expect(pages.map((p) => p.markdown), ['$first/0', '$first/1', '$second/0']);
  });
}
