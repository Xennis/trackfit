import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/app/app.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  testWidgets('shows open questions, abnormal values and the latest report', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final coder = LexicalCoder(seedTerminology());
    await seedReport(
      db,
      reportDate: '2025-03-14',
      coder: coder,
      drafts: const [
        ObservationDraft(
          name: 'Eisen',
          value: '52',
          unit: 'µg/dl',
          reference: '60 - 170',
        ),
        ObservationDraft(
          name: 'Hämoglobin',
          value: '13,5',
          unit: 'g/dl',
          reference: '12 - 16',
        ),
        ObservationDraft(name: 'Fe-Sätt.', value: '14', unit: '%'),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(db, coder: coder),
        child: const TrackfitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 value needs your help'), findsOneWidget);
    expect(find.text('Abnormal'), findsOneWidget);
    expect(find.text('Eisen'), findsOneWidget);
    expect(find.text('Hämoglobin'), findsNothing);
    expect(find.text('Latest report'), findsOneWidget);
    expect(find.text('Mar 14, 2025'), findsOneWidget);
  });
  testWidgets('a pending report without setup waits instead of spinning', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final personId = await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));
    await ReportRepository(db).createReport(
      personId: personId,
      files: [
        NewSourceFile(
          contentHash: 'e' * 64,
          fileName: 'befund.pdf',
          mimeType: 'application/pdf',
          byteSize: 1,
          storedPath: 'files/e.pdf',
          kind: FileKind.pdf,
          importChannel: ImportChannel.filePicker,
        ),
      ],
      now: DateTime.utc(2026),
    );

    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides(db), child: const TrackfitApp()),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('1 report waits for recognition to be set up'),
      findsOneWidget,
    );
    expect(find.textContaining('being processed'), findsNothing);
  });
}
