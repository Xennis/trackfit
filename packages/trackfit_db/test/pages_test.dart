import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late int personId;
  late int reportId;

  setUp(() async {
    db = openTestDatabase();
    personId = await insertPerson(db);
    reportId = await insertReport(db, personId);
  });
  tearDown(() => db.close());

  ExtractionCompanion extraction({
    ExtractionStatus status = ExtractionStatus.ok,
    String reason = '',
    String? payload = '[]',
  }) => ExtractionCompanion.insert(
    personId: personId,
    sourceKind: SourceKind.file,
    sourceRef: 'report:$reportId',
    reportId: Value(reportId),
    extractor: 'manual',
    status: status,
    reason: Value(reason),
    payload: Value(payload),
    digest: 'd' * 64,
    createdAt: testNow,
  );

  test('keeps one text per page and origin', () async {
    final fileId = await insertSourceFile(
      db,
      personId: personId,
      reportId: reportId,
    );
    SourcePageCompanion page(String origin) => SourcePageCompanion.insert(
      sourceFileId: fileId,
      pageIx: 0,
      textOrigin: origin,
      markdown: '# Page',
      createdAt: testNow,
    );

    await db.into(db.sourcePage).insert(page('ocr:mistral:test'));
    await db.into(db.sourcePage).insert(page('text-layer'));

    await expectLater(
      db.into(db.sourcePage).insert(page('text-layer')),
      throwsA(isA<Exception>()),
    );
  });

  test('stores a successful extraction', () async {
    await db.into(db.extraction).insert(extraction());

    expect(await db.select(db.extraction).get(), hasLength(1));
  });

  test('a failed extraction needs a reason', () async {
    await expectLater(
      db
          .into(db.extraction)
          .insert(extraction(status: ExtractionStatus.failed, payload: null)),
      throwsA(isA<Exception>()),
    );
  });

  test('a successful extraction needs a payload', () async {
    await expectLater(
      db.into(db.extraction).insert(extraction(payload: null)),
      throwsA(isA<Exception>()),
    );
  });

  test('the same result is not stored twice', () async {
    await db.into(db.extraction).insert(extraction());

    await expectLater(
      db.into(db.extraction).insert(extraction()),
      throwsA(isA<Exception>()),
    );
  });
}
