import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/app/app.dart';
import 'package:trackfit/application/processing_providers.dart';
import 'package:trackfit/application/question_answers.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  testWidgets('answers an open question by choosing the test', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final terminology = seedTerminology();
    final lexical = LexicalCoder(terminology);
    await seedReport(
      db,
      reportDate: '2025-03-14',
      coder: lexical,
      drafts: const [
        ObservationDraft(name: 'Fe-Sätt.', value: '14', unit: '%'),
      ],
    );
    final questions = QuestionRepository(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...testOverrides(db, coder: lexical),
          terminologyProvider.overrideWith((ref) => terminology),
          questionAnswersProvider.overrideWithValue(
            QuestionAnswers(
              db: db,
              coder: () async => AliasCoder(lexical, [
                for (final a in await questions.aliases(1))
                  ConfirmedAlias(nameKey: a.nameKey, code: a.code),
              ]),
            ),
          ),
        ],
        child: const TrackfitApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Values'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    expect(find.text('The name is not known yet.'), findsOneWidget);
    await tester.tap(find.text('Choose test'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Transferrins');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Transferrinsättigung'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('1 value assigned'), findsOneWidget);
    expect(find.text('No open questions.'), findsOneWidget);
  });
}
