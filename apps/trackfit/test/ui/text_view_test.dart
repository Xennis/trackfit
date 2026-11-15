import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/l10n/generated/app_localizations.dart';
import 'package:trackfit/ui/reports/text_view.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  testWidgets('shows the pages and switches to raw text', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
    final reports = ReportRepository(db);
    final reportId = await reports.createReport(
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
      now: DateTime.utc(2026),
    );
    final fileId = (await reports.getFiles(reportId)).single.id;
    await PageRepository(db).savePages(
      sourceFileId: fileId,
      textOrigin: 'ocr:fake',
      pages: const [
        NewPage(pageIx: 0, markdown: '# Labor Beispiel'),
        NewPage(pageIx: 1, markdown: '**Eisen** 52'),
      ],
      now: DateTime.utc(2026),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: TextView(reportId: reportId)),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Page 1'), findsOneWidget);
    expect(find.text('Page 2'), findsOneWidget);
    expect(find.text('Labor Beispiel'), findsOneWidget);

    await tester.tap(find.text('Raw text'));
    await tester.pump();
    expect(find.text('# Labor Beispiel'), findsOneWidget);
  });
}
