import 'package:drift/drift.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'reading_builder.dart';

/// Answers to open questions: what a printed name means.
class QuestionAnswers {
  QuestionAnswers({
    required TrackfitDatabase db,
    required Future<Coder> Function() coder,
    DateTime Function()? clock,
  }) : _questions = QuestionRepository(db),
       _observations = ObservationRepository(db),
       _coder = coder,
       _clock = clock ?? DateTime.now;

  final QuestionRepository _questions;
  final ObservationRepository _observations;

  /// The coder that knows the answers given so far.
  final Future<Coder> Function() _coder;
  final DateTime Function() _clock;

  /// Stores that [nameKey] is [code] (or no standard test when null) and
  /// codes every open reading with that name again. Returns how many
  /// readings were recoded.
  Future<int> answer({
    required int personId,
    required String nameKey,
    String? code,
  }) async {
    final now = _clock().toUtc();
    await _questions.confirm(
      personId: personId,
      nameKey: nameKey,
      codeSystem: code == null ? null : LexicalCoder.codeSystem,
      code: code,
      now: now,
    );
    final coder = await _coder();
    final readings = await _questions.openReadingsNamed(personId, nameKey);
    for (final row in readings) {
      final reading = standardizeDraft(
        ObservationDraft(
          name: row.nameText,
          value: row.valueText,
          unit: row.unitText,
          reference: row.refText,
          flag: row.flagText,
          specimen: row.specimenText,
          method: row.methodText,
          panel: row.panelText,
        ),
        coder,
      );
      final rebuilt = buildLabReading(
        reading,
        ReadingSource(
          personId: row.personId,
          reportId: row.reportId ?? 0,
          reportDate: row.localDate,
          timeZone: row.tz,
          now: now,
        ),
        rowIx: row.rowIx ?? 0,
        terminologyRelease: coder.release,
      );
      await _observations.recode(
        row.id,
        NewObservation(
          rebuilt.row.copyWith(unitUcum: Value(row.unitUcum)),
          rebuilt.coding,
        ),
        now: now,
        cause: CodingCause.recodeAlias,
      );
    }
    return readings.length;
  }
}
