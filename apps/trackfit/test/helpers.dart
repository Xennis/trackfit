import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/application/processing_providers.dart';
import 'package:trackfit/application/reading_builder.dart';
import 'package:trackfit/application/recognition_settings.dart';
import 'package:trackfit/data/database_providers.dart';
import 'package:trackfit/data/file_store.dart';
import 'package:trackfit/data/secret_store.dart';
import 'package:trackfit/platform/ocr/ocr.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

/// A fresh in-memory database.
///
/// Streams close synchronously, so widget tests do not end with a pending
/// timer from drift.
TrackfitDatabase memoryDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return TrackfitDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}

/// Bytes that are detected as a PDF; [tag] makes them unique.
Uint8List fakePdf([String tag = '']) =>
    Uint8List.fromList(utf8.encode('%PDF-1.7\n% $tag\n%%EOF'));

/// Bytes that are detected as a JPEG; [tag] makes them unique.
Uint8List fakeJpeg([String tag = '']) => Uint8List.fromList([
  0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, //
  ...utf8.encode(tag),
]);

/// Provider overrides that run the app on [db] instead of a file.
List<Override> testOverrides(
  TrackfitDatabase db, {
  SecretStore? secrets,
  FileStore? files,
  Coder coder = const NoCoder(),
}) => [
  coderProvider.overrideWith((ref) => coder),
  databaseProvider.overrideWithValue(db),
  fileStoreProvider.overrideWith(
    (ref) =>
        files ?? FileStore(Directory.systemTemp.createTempSync('trackfit')),
  ),
  deviceTimeZoneProvider.overrideWith((ref) => 'Europe/Berlin'),
  secretStoreProvider.overrideWithValue(secrets ?? MemorySecretStore()),
];

/// A valid 1x1 PNG.
final Uint8List tinyPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
);

/// OCR that answers with fixed pages, or fails while [failWith] is set.
class FakeOcr implements Ocr {
  FakeOcr({this.pages = const [OcrPage(index: 0, markdown: '# Page')]});

  final List<OcrPage> pages;
  OcrException? failWith;
  final List<OcrDocument> received = [];

  @override
  String get origin => 'ocr:fake';

  @override
  Future<List<OcrPage>> read(OcrDocument document) async {
    received.add(document);
    final failure = failWith;
    if (failure != null) throw failure;
    return pages;
  }
}

/// Creates a report of the default person with lab readings for
/// [reportDate] and returns its id.
Future<int> seedReport(
  TrackfitDatabase db, {
  required String reportDate,
  required List<ObservationDraft> drafts,
  String hash = '',
  Coder coder = const NoCoder(),
}) async {
  final personId = await PersonRepository(
    db,
  ).ensureDefaultPerson(defaultTz: 'Europe/Berlin', now: DateTime.utc(2026));
  final reports = ReportRepository(db);
  final reportId = await reports.createReport(
    personId: personId,
    files: [
      NewSourceFile(
        contentHash: hash.isEmpty
            ? reportDate.hashCode.toRadixString(16).padLeft(64, '0')
            : hash,
        fileName: 'befund.pdf',
        mimeType: 'application/pdf',
        byteSize: 1,
        storedPath: 'files/missing.pdf',
        kind: FileKind.pdf,
        importChannel: ImportChannel.filePicker,
      ),
    ],
    now: DateTime.utc(2026),
  );
  await reports.setReportInfo(reportId, reportDate: reportDate);
  await reports.setStatus(reportId, ReportStatus.review);
  final source = ReadingSource(
    personId: personId,
    reportId: reportId,
    reportDate: reportDate,
    timeZone: 'Europe/Berlin',
    now: DateTime.utc(2026),
  );
  await ObservationRepository(db).replaceReportReadings(reportId, [
    for (final (row, draft) in drafts.indexed)
      buildLabReading(
        standardizeDraft(draft, coder),
        source,
        rowIx: row,
        terminologyRelease: coder.release,
      ),
  ], now: DateTime.utc(2026));
  return reportId;
}

/// The terminology built from the seed tables, as bundled with the app.
Terminology seedTerminology() => Terminology.fromSeed(
  release: 'seed-test',
  labTests: File(
    '../../packages/standardize/seed/lab_tests.tsv',
  ).readAsStringSync(),
  categories: File(
    '../../packages/standardize/seed/categories.tsv',
  ).readAsStringSync(),
);
