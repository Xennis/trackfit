import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/app/app.dart';
import 'package:trackfit/data/file_store.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  testWidgets('lists imported reports with their status', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
    await ReportRepository(db).createReport(
      personId: personId,
      files: [
        NewSourceFile(
          contentHash: 'a' * 64,
          fileName: 'befund.pdf',
          mimeType: 'application/pdf',
          byteSize: 1,
          storedPath: 'files/a.pdf',
          kind: FileKind.pdf,
          importChannel: ImportChannel.filePicker,
        ),
      ],
      now: DateTime.utc(2026, 11, 15),
    );

    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides(db), child: const TrackfitApp()),
    );
    await pumpFrames(tester);
    await tester.tap(find.text('Reports'));
    await tester.pump();
    await tester.pump();

    expect(find.text('New report'), findsOneWidget);
    expect(find.text('Waiting for recognition to be set up'), findsOneWidget);
    expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
  });
  testWidgets('opens a report with its files', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final root = Directory.systemTemp.createTempSync('reports_page_test');
    addTearDown(() => root.deleteSync(recursive: true));
    final store = FileStore(root);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
    final stored = await tester.runAsync(
      () => store.store(tinyPng, extension: 'png'),
    );
    NewSourceFile image(String hash) => NewSourceFile(
      contentHash: hash,
      fileName: 'photo.png',
      mimeType: 'image/png',
      byteSize: stored!.byteSize,
      storedPath: stored.relativePath,
      kind: FileKind.image,
      importChannel: ImportChannel.gallery,
    );
    await ReportRepository(db).createReport(
      personId: personId,
      files: [image('a' * 64), image('b' * 64)],
      now: DateTime.utc(2026, 11, 15),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(db, files: store),
        child: const TrackfitApp(),
      ),
    );
    await pumpFrames(tester);
    await tester.tap(find.text('Reports'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('New report'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Original'), findsOneWidget);
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('File 1'), findsOneWidget);
    expect(find.text('File 2'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Recognition is not set up yet.'), findsOneWidget);
  });
  testWidgets('a failed report shows the reason and can be retried', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final reports = ReportRepository(db);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
    final reportId = await reports.createReport(
      personId: personId,
      files: [
        NewSourceFile(
          contentHash: 'c' * 64,
          fileName: 'befund.pdf',
          mimeType: 'application/pdf',
          byteSize: 1,
          storedPath: 'files/missing.pdf',
          kind: FileKind.pdf,
          importChannel: ImportChannel.filePicker,
        ),
      ],
      now: DateTime.utc(2026, 11, 15),
    );
    await reports.setStatus(
      reportId,
      ReportStatus.failed,
      error: 'Mistral OCR answered 401',
    );

    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides(db), child: const TrackfitApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New report'));
    await tester.pumpAndSettle();

    expect(
      find.text('Recognition failed: Mistral OCR answered 401'),
      findsOneWidget,
    );
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump();

    expect((await reports.getReport(reportId))!.status, ReportStatus.pending);
  });
  testWidgets('asks for the date of a report without one', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final reports = ReportRepository(db);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
    final reportId = await reports.createReport(
      personId: personId,
      files: [
        NewSourceFile(
          contentHash: 'd' * 64,
          fileName: 'befund.pdf',
          mimeType: 'application/pdf',
          byteSize: 1,
          storedPath: 'files/missing.pdf',
          kind: FileKind.pdf,
          importChannel: ImportChannel.filePicker,
        ),
      ],
      now: DateTime.utc(2026, 11, 15),
    );
    await reports.setStatus(reportId, ReportStatus.review);

    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides(db), child: const TrackfitApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New report'));
    await tester.pumpAndSettle();

    expect(find.textContaining('The report date is missing'), findsOneWidget);
    await tester.tap(find.text('Set date'));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
