import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/application/import_service.dart';
import 'package:trackfit/application/processing_queue.dart';
import 'package:trackfit/application/report_processor.dart';
import 'package:trackfit/data/file_store.dart';
import 'package:trackfit/platform/ocr/ocr.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  late TrackfitDatabase db;
  late Directory root;
  late ReportRepository reports;
  late PageRepository pages;
  late FileStore store;
  late FakeOcr ocr;
  late int personId;

  setUp(() async {
    db = memoryDatabase();
    root = await Directory.systemTemp.createTemp('processor_test');
    reports = ReportRepository(db);
    pages = PageRepository(db);
    store = FileStore(root);
    ocr = FakeOcr();
    personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
  });
  tearDown(() async {
    await db.close();
    await root.delete(recursive: true);
  });

  ReportProcessor processor() => ReportProcessor(
    reports: reports,
    pages: pages,
    fileStore: store,
    ocr: ocr,
  );

  Future<int> importReport(List<ImportCandidate> files) async {
    final outcome = await ImportService(
      reports: reports,
      fileStore: store,
    ).importFiles(personId, files, imagesAsOneReport: true);
    return outcome.reportIds.single;
  }

  ImportCandidate pdf() => ImportCandidate(
    name: 'befund.pdf',
    bytes: fakePdf(),
    channel: ImportChannel.filePicker,
  );

  test('stores the recognized pages and waits for review', () async {
    final reportId = await importReport([pdf()]);

    await processor().process(reportId);

    final stored = await pages.reportPages(reportId);
    expect(stored.single.markdown, '# Page');
    expect(stored.single.textOrigin, 'ocr:fake');
    expect((await reports.getReport(reportId))!.status, ReportStatus.review);
    expect(ocr.received.single.mimeType, 'application/pdf');
  });

  test('counts pages across the photos of one report', () async {
    final reportId = await importReport([
      ImportCandidate(
        name: '1.png',
        bytes: tinyPng,
        channel: ImportChannel.gallery,
      ),
      ImportCandidate(
        name: '2.jpg',
        bytes: fakeJpeg('2'),
        channel: ImportChannel.gallery,
      ),
    ]);

    await processor().process(reportId);

    final stored = await pages.reportPages(reportId);
    expect(stored.map((p) => p.reportPageIx), [0, 1]);
  });

  test('a failure keeps the reason and a retry sends only the rest', () async {
    final reportId = await importReport([pdf()]);
    ocr.failWith = const OcrException('Mistral OCR answered 503');

    await processor().process(reportId);

    final failed = await reports.getReport(reportId);
    expect(failed!.status, ReportStatus.failed);
    expect(failed.error, 'Mistral OCR answered 503');

    ocr.failWith = null;
    await processor().process(reportId);
    await processor().process(reportId);
    expect(ocr.received, hasLength(2));
  });

  test('runs the next step after recognition', () async {
    final reportId = await importReport([pdf()]);
    int? handedOver;

    await ReportProcessor(
      reports: reports,
      pages: pages,
      fileStore: store,
      ocr: ocr,
      afterRecognition: (id) async => handedOver = id,
    ).process(reportId);

    expect(handedOver, reportId);
  });

  group('ProcessingQueue', () {
    test('processes pending reports when recognition is ready', () async {
      final reportId = await importReport([pdf()]);
      var ready = false;
      final queue = ProcessingQueue(
        pending: reports.watchPendingIds(),
        processor: () async => ready ? processor() : null,
      )..start();
      addTearDown(queue.dispose);

      await pumpEventQueue();
      expect((await reports.getReport(reportId))!.status, ReportStatus.pending);

      ready = true;
      queue.poke();
      await pumpEventQueue();
      expect((await reports.getReport(reportId))!.status, ReportStatus.review);
    });
  });
}
