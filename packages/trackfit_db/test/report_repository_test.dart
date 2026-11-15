import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late ReportRepository repository;
  late int personId;

  setUp(() async {
    db = openTestDatabase();
    repository = ReportRepository(db);
    personId = await insertPerson(db);
  });
  tearDown(() => db.close());

  NewSourceFile file(String hashChar) => NewSourceFile(
    contentHash: hashChar * 64,
    fileName: '$hashChar.jpg',
    mimeType: 'image/jpeg',
    byteSize: 10,
    storedPath: 'files/$hashChar.jpg',
    kind: FileKind.image,
    importChannel: ImportChannel.gallery,
  );

  test('creates a report with its files in order', () async {
    final id = await repository.createReport(
      personId: personId,
      files: [file('a'), file('b')],
      now: testNow,
    );

    final files = await repository.getFiles(id);
    expect(files.map((f) => f.fileName), ['a.jpg', 'b.jpg']);
    expect(files.map((f) => f.position), [0, 1]);
    expect((await repository.getReport(id))!.status, ReportStatus.pending);
  });

  test('rejects a file imported before and writes nothing', () async {
    await repository.createReport(
      personId: personId,
      files: [file('a')],
      now: testNow,
    );

    await expectLater(
      repository.createReport(
        personId: personId,
        files: [file('b'), file('a')],
        now: testNow,
      ),
      throwsA(isA<DuplicateFileException>()),
    );
    expect(await db.select(db.report).get(), hasLength(1));
  });

  test('lists reports with their file count', () async {
    await repository.createReport(
      personId: personId,
      files: [file('a'), file('b')],
      now: testNow,
    );

    final summaries = await repository.watchSummaries(personId).first;

    expect(summaries.single.fileCount, 2);
    expect(summaries.single.firstFileKind, FileKind.image);
    expect(summaries.single.valueCount, 0);
  });

  test('a failed report keeps its error', () async {
    final id = await repository.createReport(
      personId: personId,
      files: [file('a')],
      now: testNow,
    );

    await repository.setStatus(id, ReportStatus.failed, error: 'offline');

    final report = await repository.getReport(id);
    expect(report!.status, ReportStatus.failed);
    expect(report.error, 'offline');
    expect(await repository.reportIdsWithStatus(ReportStatus.failed), [id]);
  });

  group('deleteReport', () {
    late int reportId;

    setUp(() async {
      reportId = await repository.createReport(
        personId: personId,
        files: [file('a')],
        now: testNow,
      );
      await db
          .into(db.observation)
          .insert(
            labObservation(
              personId: personId,
            ).copyWith(reportId: Value(reportId)),
          );
    });

    test('returns the stored paths and removes the files', () async {
      final paths = await repository.deleteReport(reportId, deleteValues: true);

      expect(paths, ['files/a.jpg']);
      expect(await db.select(db.sourceFile).get(), isEmpty);
      expect(await db.select(db.observation).get(), isEmpty);
    });

    test('can keep the values', () async {
      await repository.deleteReport(reportId, deleteValues: false);

      final rows = await db.select(db.observation).get();
      expect(rows.single.reportId, isNull);
    });
  });
}
