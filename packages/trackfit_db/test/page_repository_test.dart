import 'package:test/test.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late PageRepository pages;
  late int reportId;
  late int fileId;

  setUp(() async {
    db = openTestDatabase();
    pages = PageRepository(db);
    final personId = await insertPerson(db);
    reportId = await insertReport(db, personId);
    fileId = await insertSourceFile(db, personId: personId, reportId: reportId);
  });
  tearDown(() => db.close());

  test('stores pages and replaces an earlier result', () async {
    await pages.savePages(
      sourceFileId: fileId,
      textOrigin: 'ocr:test',
      pages: const [NewPage(pageIx: 0, markdown: 'old')],
      now: testNow,
    );
    await pages.savePages(
      sourceFileId: fileId,
      textOrigin: 'ocr:test',
      pages: const [
        NewPage(pageIx: 0, markdown: 'a'),
        NewPage(pageIx: 1, markdown: 'b'),
      ],
      now: testNow,
    );

    final result = await pages.reportPages(reportId);
    expect(result.map((p) => p.markdown), ['a', 'b']);
    expect(result.map((p) => p.reportPageIx), [0, 1]);
    expect(await pages.hasPages(fileId, 'ocr:test'), isTrue);
    expect(await pages.hasPages(fileId, 'ocr:other'), isFalse);
  });
}
