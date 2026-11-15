import 'package:standardize/standardize.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'reading_builder.dart';

/// Codes stored readings again from their printed fields.
class ReadingRecoder {
  ReadingRecoder({required TrackfitDatabase db, DateTime Function()? clock})
    : _observations = ObservationRepository(db),
      _clock = clock ?? DateTime.now;

  final ObservationRepository _observations;
  final DateTime Function() _clock;

  /// Codes [rows] again with [coder]. Returns how many were recoded.
  Future<int> recode(
    List<ObservationRow> rows,
    Coder coder, {
    required CodingCause cause,
  }) async {
    final now = _clock().toUtc();
    for (final row in rows) {
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
      await _observations.recode(row.id, rebuilt, now: now, cause: cause);
    }
    return rows.length;
  }

  /// Codes all readings of [personId] that were coded with an older
  /// terminology, e.g. after an app update. Returns how many changed.
  Future<int> recodeOutdated(int personId, Coder coder) async {
    if (coder is NoCoder) return 0;
    final rows = await _observations.readingsNotCodedWith(
      personId,
      coder.release,
    );
    return recode(rows, coder, cause: CodingCause.recodeRelease);
  }
}
