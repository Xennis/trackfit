@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/app/theme.dart';
import 'package:trackfit/l10n/generated/app_localizations.dart';
import 'package:trackfit/ui/charts/history_chart.dart';
import 'package:trackfit/ui/values/series_view_model.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  testWidgets('history chart with reference band', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    for (final (date, value, range, flag) in [
      ('2023-01-10', '98', '60 - 170', ''),
      ('2024-11-02', '55', '60 - 170', 'L'),
      ('2025-03-14', '52', '50 - 160', ''),
    ]) {
      await seedReport(
        db,
        reportDate: date,
        drafts: [
          ObservationDraft(
            name: 'Eisen',
            value: value,
            unit: 'µg/dl',
            reference: range,
            flag: flag,
          ),
        ],
      );
    }
    final all = await tester.runAsync(
      () => SeriesRepository(db).watchSeries(1).first,
    );
    final summary = all!.single;
    final view = SeriesView(summary);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              child: HistoryChart(points: view.points, unit: view.unit),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(HistoryChart),
      matchesGoldenFile('goldens/history_chart.png'),
    );
  });
}
