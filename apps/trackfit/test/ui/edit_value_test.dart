import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/l10n/generated/app_localizations.dart';
import 'package:trackfit/ui/reports/report_values_view.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../helpers.dart';

void main() {
  late int reportId;

  Future<void> pump(WidgetTester tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    reportId = await seedReport(
      db,
      reportDate: '2025-03-14',
      drafts: const [
        ObservationDraft(name: 'Eisen', value: '52', unit: 'µg/dl'),
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
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('corrects a value and keeps the original', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Eisen'));
    await tester.pumpAndSettle();
    expect(find.text('The original stays stored.'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, '52'), '25');
    await tester.tap(find.text('Save'));
    await settle(tester);

    expect(find.text('25 µg/dl'), findsOneWidget);
    expect(find.text('52 µg/dl'), findsNothing);
  });

  testWidgets('hides a value', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Eisen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hide value'));
    await settle(tester);

    expect(find.text('52 µg/dl'), findsNothing);
  });

  testWidgets('adds a value the recognition missed', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Add value'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ferritin');
    await tester.enterText(fields.at(1), '18');
    await tester.enterText(fields.at(2), 'ng/ml');
    await tester.tap(find.text('Save'));
    await settle(tester);

    expect(find.text('18 ng/ml'), findsOneWidget);
  });
}
