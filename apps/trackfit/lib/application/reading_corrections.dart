import 'package:drift/drift.dart';
import 'package:standardize/standardize.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'reading_builder.dart';

/// Changes a person makes to readings. Nothing is overwritten: a correction
/// is a new row that amends the old one.
class ReadingCorrections {
  ReadingCorrections({
    required TrackfitDatabase db,
    required this.coder,
    DateTime Function()? clock,
  }) : _db = db,
       _observations = ObservationRepository(db),
       _clock = clock ?? DateTime.now;

  final TrackfitDatabase _db;
  final ObservationRepository _observations;
  final Coder coder;
  final DateTime Function() _clock;

  /// Replaces a reading by [draft], as entered by the person.
  Future<int> edit(int observationId, ObservationDraft draft) async {
    final original = await _observations.get(observationId);
    final now = _clock().toUtc();
    final corrected = buildLabReading(
      standardizeDraft(draft, coder),
      ReadingSource(
        personId: original.personId,
        reportId: original.reportId ?? 0,
        extractionId: original.extractionId,
        reportDate: original.localDate,
        timeZone: original.tz,
        now: now,
        modality: Modality.manual,
      ),
      rowIx: original.rowIx ?? 0,
      recordId: original.sourceRecordId,
      terminologyRelease: coder.release,
    );
    return _observations.amend(
      observationId,
      NewObservation(
        corrected.row.copyWith(
          sourceRef: Value(original.sourceRef),
          reportId: Value(original.reportId),
          pageIx: Value(original.pageIx),
          panelText: Value(
            draft.panel.isEmpty ? original.panelText : draft.panel,
          ),
        ),
        corrected.coding,
      ),
      now: now,
    );
  }

  /// Marks a reading as entered in error.
  Future<void> retract(int observationId) =>
      _observations.retract(observationId, now: _clock().toUtc());

  /// Adds a reading the recognition missed to [reportId].
  Future<int> addToReport(int reportId, ObservationDraft draft) async {
    final report = await (_db.select(
      _db.report,
    )..where((r) => r.id.equals(reportId))).getSingle();
    final person = await (_db.select(
      _db.person,
    )..where((p) => p.id.equals(report.personId))).getSingle();
    final date = report.reportDate;
    if (date == null) {
      throw StateError('report $reportId has no date yet');
    }
    final now = _clock().toUtc();
    return _observations.insert(
      buildLabReading(
        standardizeDraft(draft, coder),
        ReadingSource(
          personId: report.personId,
          reportId: reportId,
          reportDate: date,
          timeZone: person.defaultTz,
          now: now,
          modality: Modality.manual,
        ),
        rowIx: 0,
        recordId: 'manual:${now.microsecondsSinceEpoch}',
        terminologyRelease: coder.release,
      ),
      now: now,
    );
  }
}
