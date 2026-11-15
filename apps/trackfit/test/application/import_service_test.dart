import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/application/import_service.dart';
import 'package:trackfit/data/file_store.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  late TrackfitDatabase db;
  late Directory root;
  late ImportService service;
  late ReportRepository reports;
  late int personId;

  setUp(() async {
    db = memoryDatabase();
    root = await Directory.systemTemp.createTemp('import_service_test');
    reports = ReportRepository(db);
    service = ImportService(
      reports: reports,
      fileStore: FileStore(root),
      clock: () => DateTime.utc(2026, 11, 15),
    );
    personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
  });
  tearDown(() async {
    await db.close();
    await root.delete(recursive: true);
  });

  ImportCandidate candidate(String name, Uint8List bytes) => ImportCandidate(
    name: name,
    bytes: bytes,
    channel: ImportChannel.filePicker,
  );

  test('imports a PDF as a pending report and stores the file', () async {
    final outcome = await service.importFiles(personId, [
      candidate('befund.pdf', fakePdf()),
    ]);

    final files = await reports.getFiles(outcome.reportIds.single);
    expect(files.single.kind, FileKind.pdf);
    expect(files.single.mimeType, 'application/pdf');
    expect(File('${root.path}/${files.single.storedPath}').existsSync(), true);
    final report = await reports.getReport(outcome.reportIds.single);
    expect(report!.status, ReportStatus.pending);
  });

  test('imports images as separate reports by default', () async {
    final outcome = await service.importFiles(personId, [
      candidate('1.jpg', fakeJpeg('1')),
      candidate('2.jpg', fakeJpeg('2')),
    ]);

    expect(outcome.reportIds, hasLength(2));
  });

  test('combines images into one report on request', () async {
    final outcome = await service.importFiles(personId, [
      candidate('1.jpg', fakeJpeg('1')),
      candidate('2.jpg', fakeJpeg('2')),
      candidate('befund.pdf', fakePdf()),
    ], imagesAsOneReport: true);

    expect(outcome.reportIds, hasLength(2));
    final files = await reports.getFiles(outcome.reportIds.last);
    expect(files.map((f) => f.fileName), ['1.jpg', '2.jpg']);
  });

  test('skips a file imported before', () async {
    final first = await service.importFiles(personId, [
      candidate('befund.pdf', fakePdf()),
    ]);

    final second = await service.importFiles(personId, [
      candidate('copy.pdf', fakePdf()),
    ]);

    expect(second.reportIds, isEmpty);
    expect(second.duplicates.single.name, 'copy.pdf');
    expect(second.duplicates.single.existingReportId, first.reportIds.single);
  });

  test('imports the same file chosen twice only once', () async {
    final outcome = await service.importFiles(personId, [
      candidate('a.pdf', fakePdf()),
      candidate('b.pdf', fakePdf()),
    ]);

    expect(outcome.reportIds, hasLength(1));
  });

  test('rejects files that are not PDFs or images', () async {
    final outcome = await service.importFiles(personId, [
      candidate('notes.txt', Uint8List.fromList('hello'.codeUnits)),
    ]);

    expect(outcome.reportIds, isEmpty);
    expect(outcome.unsupported, ['notes.txt']);
  });
}
