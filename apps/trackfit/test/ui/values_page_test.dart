import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/app/app.dart';
import 'package:trackfit/ui/charts/sparkline.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../helpers.dart';

void main() {
  testWidgets('lists values by category with their trend', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final coder = LexicalCoder(seedTerminology());
    await seedReport(
      db,
      reportDate: '2024-11-02',
      coder: coder,
      drafts: const [
        ObservationDraft(
          name: 'Eisen',
          value: '55',
          unit: 'µg/dl',
          reference: '60 - 170',
        ),
        ObservationDraft(name: 'Fe-Sätt.', value: '14', unit: '%'),
      ],
    );
    await seedReport(
      db,
      reportDate: '2025-03-14',
      coder: coder,
      drafts: const [
        ObservationDraft(
          name: 'Eisen',
          value: '9,3',
          unit: 'µmol/l',
          reference: '10,7 - 30,4',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(db, coder: coder),
        child: const TrackfitApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Values'));
    await tester.pumpAndSettle();

    expect(find.text('Iron metabolism'), findsOneWidget);
    expect(find.text('Eisen'), findsOneWidget);
    expect(find.text('2 measurements'), findsOneWidget);
    expect(find.text('9,3 µmol/l'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.byType(Sparkline), findsNWidgets(2));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Eisen'), findsNothing);
    expect(find.text('Fe-Sätt.'), findsOneWidget);
  });
}
