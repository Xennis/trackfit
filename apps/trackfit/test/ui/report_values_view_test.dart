import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/l10n/generated/app_localizations.dart';
import 'package:trackfit/ui/reports/report_values_view.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../helpers.dart';

void main() {
  testWidgets('groups values by panel and marks abnormal ones', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final reportId = await seedReport(
      db,
      reportDate: '2025-03-14',
      drafts: const [
        ObservationDraft(
          name: 'Eisen',
          value: '52',
          unit: 'µg/dl',
          reference: '60 - 170',
          flag: 'L',
          panel: 'Eisenstoffwechsel',
          page: 1,
        ),
        ObservationDraft(
          name: 'Hämoglobin',
          value: '12,9',
          unit: 'g/dl',
          reference: '12 - 16',
          panel: 'Blutbild',
          page: 2,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: ReportValuesView(reportId: reportId)),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Eisenstoffwechsel'), findsOneWidget);
    expect(find.text('Blutbild'), findsOneWidget);
    expect(find.text('52 µg/dl'), findsOneWidget);
    expect(find.text('12,9 g/dl'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    expect(find.textContaining('Ref 60 - 170 · p. 1'), findsOneWidget);
  });
}
