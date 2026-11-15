import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/app/app.dart';
import 'package:trackfit/ui/charts/history_chart.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../helpers.dart';

void main() {
  testWidgets('shows the history of a value across reports and units', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(500, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
        ObservationDraft(name: 'Leukozyten', value: '6,5', unit: 'Tsd/µl'),
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
    await tester.tap(find.text('Eisen'));
    await tester.pumpAndSettle();

    final chart = tester.widget<HistoryChart>(find.byType(HistoryChart));
    expect(chart.unit, 'ug/dL');
    expect(chart.points, hasLength(2));
    // 9.3 µmol/L iron is about 51.9 µg/dL; its range scales the same way.
    expect(chart.points.last.value, closeTo(51.9, 0.1));
    expect(chart.points.last.refLow, closeTo(59.8, 0.1));
    expect(find.text('55 µg/dl'), findsOneWidget);
    expect(find.text('LOINC 14798-3'), findsOneWidget);

    await tester.tap(find.text('Values'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leukozyten'));
    await tester.pumpAndSettle();
    expect(find.text('6,5 Tsd/µl'), findsWidgets);
  });
}
