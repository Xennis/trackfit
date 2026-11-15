import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/app/app.dart';
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
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reports'));
    await tester.pump();
    await tester.pump();

    expect(find.text('New report'), findsOneWidget);
    expect(find.text('Waiting for recognition'), findsOneWidget);
    expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
  });
}
