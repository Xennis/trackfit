import 'package:flutter_test/flutter_test.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit/application/question_answers.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  test('an answer codes every reading with that name', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final lexical = LexicalCoder(seedTerminology());
    for (final date in ['2024-11-02', '2025-03-14']) {
      await seedReport(
        db,
        reportDate: date,
        coder: lexical,
        drafts: const [
          ObservationDraft(name: 'Fe-Sätt.', value: '14', unit: '%'),
        ],
      );
    }
    final questions = QuestionRepository(db);
    expect(await questions.watchOpen(1).first, hasLength(1));

    final answers = QuestionAnswers(
      db: db,
      coder: () async => AliasCoder(lexical, [
        for (final a in await questions.aliases(1))
          ConfirmedAlias(
            nameKey: a.nameKey,
            unitUcum: a.unitUcum,
            code: a.code,
          ),
      ]),
    );
    final recoded = await answers.answer(
      personId: 1,
      nameKey: nameKey('Fe-Sätt.'),
      code: '2502-3',
    );

    expect(recoded, 2);
    expect(await questions.watchOpen(1).first, isEmpty);
    final series = await SeriesRepository(db).watchSeries(1).first;
    expect(series.single.key, 'group:transferrin-saturation');
    expect(series.single.latest.code, '2502-3');
    final history = await db.select(db.codingHistory).get();
    expect(
      history.where((h) => h.cause == CodingCause.recodeAlias),
      hasLength(2),
    );
  });
}
