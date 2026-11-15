import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../database.dart';

/// How a reading was coded, as written next to it.
class CodingInput {
  const CodingInput({
    required this.terminologyRelease,
    required this.outcome,
    required this.rule,
    required this.seriesId,
    this.reason = '',
    this.codeSystem,
    this.code,
    this.groupId,
    this.valueCanonical,
    this.unitCanonical,
    this.evidence = const [],
    this.human = false,
    this.concept,
  });

  final String terminologyRelease;
  final CodingOutcome outcome;
  final String rule;
  final String seriesId;
  final String reason;
  final String? codeSystem;
  final String? code;
  final String? groupId;
  final double? valueCanonical;
  final String? unitCanonical;
  final List<String> evidence;
  final bool human;

  /// Display data of the code, stored once per release.
  final ConceptCompanion? concept;
}

/// A reading to write, with its coding.
class NewObservation {
  const NewObservation(this.row, this.coding);

  final ObservationCompanion row;
  final CodingInput coding;
}

/// Writes and reads observations together with their coding.
class ObservationRepository {
  ObservationRepository(this._db);

  final TrackfitDatabase _db;

  /// Id of the decision shared by every reading with the same key.
  static String decisionId({
    required String nameKey,
    required String unitUcum,
    required ValueKind valueKind,
    required String release,
    required String rule,
  }) => sha256
      .convert(
        utf8.encode('$nameKey\n$unitUcum\n${valueKind.wire}\n$release\n$rule'),
      )
      .toString()
      .substring(0, 16);

  /// Inserts [observation] and its coding; returns the new id.
  Future<int> insert(
    NewObservation observation, {
    required DateTime now,
    CodingCause cause = CodingCause.ingest,
  }) => _db.transaction(() async {
    final id = await _db.into(_db.observation).insert(observation.row);
    await _writeCoding(id, observation, now: now, cause: cause);
    return id;
  });

  /// Replaces the coding of an existing observation, e.g. after a person
  /// confirmed what a name means or a new terminology arrived.
  ///
  /// The printed fields stay untouched. Columns derived from them (unit in
  /// UCUM and the keys built from it) are refreshed, because a newer
  /// version may derive them better.
  Future<void> recode(
    int observationId,
    NewObservation observation, {
    required DateTime now,
    required CodingCause cause,
  }) => _db.transaction(() async {
    final row = observation.row;
    await (_db.update(
      _db.observation,
    )..where((o) => o.id.equals(observationId))).write(
      ObservationCompanion(
        unitUcum: row.unitUcum,
        localKey: row.localKey,
        streamKey: row.streamKey,
      ),
    );
    await _writeCoding(observationId, observation, now: now, cause: cause);
  });

  Future<void> _writeCoding(
    int observationId,
    NewObservation observation, {
    required DateTime now,
    required CodingCause cause,
  }) async {
    final row = observation.row;
    final coding = observation.coding;
    final decision = decisionId(
      nameKey: row.nameKey.value,
      unitUcum: row.unitUcum.present ? row.unitUcum.value : '',
      valueKind: row.valueKind.value,
      release: coding.terminologyRelease,
      rule: coding.rule,
    );
    await _db
        .into(_db.codingDecision)
        .insert(
          CodingDecisionCompanion.insert(
            id: decision,
            nameKey: row.nameKey.value,
            unitUcum: Value(row.unitUcum.present ? row.unitUcum.value : ''),
            valueKind: row.valueKind.value,
            terminologyRelease: coding.terminologyRelease,
            rule: coding.rule,
            evidence: Value(jsonEncode(coding.evidence)),
            human: Value(coding.human),
            createdAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    final concept = coding.concept;
    if (concept != null) {
      await _db
          .into(_db.concept)
          .insert(concept, mode: InsertMode.insertOrIgnore);
    }
    await _db
        .into(_db.codingCurrent)
        .insertOnConflictUpdate(
          CodingCurrentCompanion.insert(
            observationId: Value(observationId),
            terminologyRelease: coding.terminologyRelease,
            outcome: coding.outcome,
            reason: Value(coding.reason),
            codeSystem: Value(coding.codeSystem),
            code: Value(coding.code),
            seriesId: coding.seriesId,
            groupId: Value(coding.groupId),
            valueCanonical: Value(coding.valueCanonical),
            unitCanonical: Value(
              coding.valueCanonical == null ? null : coding.unitCanonical,
            ),
            decisionId: decision,
            codedAt: now,
          ),
        );
    await _db
        .into(_db.codingHistory)
        .insert(
          CodingHistoryCompanion.insert(
            observationId: observationId,
            cause: cause,
            terminologyRelease: coding.terminologyRelease,
            outcome: coding.outcome,
            reason: Value(coding.reason),
            codeSystem: Value(coding.codeSystem),
            code: Value(coding.code),
            seriesId: coding.seriesId,
            groupId: Value(coding.groupId),
            valueCanonical: Value(coding.valueCanonical),
            unitCanonical: Value(
              coding.valueCanonical == null ? null : coding.unitCanonical,
            ),
            decisionId: decision,
            codedAt: now,
          ),
        );
  }

  /// The stored row of an observation.
  Future<ObservationRow> get(int observationId) => (_db.select(
    _db.observation,
  )..where((o) => o.id.equals(observationId))).getSingle();

  /// Writes [corrected] as a new row that replaces [originalId].
  ///
  /// The original row is kept unchanged; reads show only the correction.
  Future<int> amend(
    int originalId,
    NewObservation corrected, {
    required DateTime now,
  }) => insert(
    NewObservation(
      corrected.row.copyWith(
        amends: Value(originalId),
        status: const Value(ObservationStatus.finalStatus),
      ),
      corrected.coding,
    ),
    now: now,
    cause: CodingCause.correct,
  );

  /// Marks a reading as entered in error. A new row retracts it; nothing is
  /// deleted.
  Future<int> retract(int observationId, {required DateTime now}) async {
    final original = await get(observationId);
    return _db
        .into(_db.observation)
        .insert(
          original
              .toCompanion(true)
              .copyWith(
                id: const Value.absent(),
                status: const Value(ObservationStatus.enteredInError),
                amends: Value(observationId),
                createdAt: Value(now),
              ),
        );
  }

  /// Replaces the readings of a report that nobody corrected by [rows].
  ///
  /// Readings a person corrected or added stay, so reading a report again
  /// never loses manual work.
  Future<void> replaceReportReadings(
    int reportId,
    List<NewObservation> rows, {
    required DateTime now,
  }) => _db.transaction(() async {
    final o = _db.observation;
    final corrected =
        await (_db.selectOnly(o)
              ..addColumns([o.amends])
              ..where(o.amends.isNotNull()))
            .map((r) => r.read(o.amends)!)
            .get();
    await (_db.delete(o)..where(
          (row) =>
              row.reportId.equals(reportId) &
              row.amends.isNull() &
              row.modality.equalsValue(Modality.manual).not() &
              row.id.isNotIn(corrected),
        ))
        .go();
    for (final row in rows) {
      await insert(row, now: now);
    }
  });

  /// Current readings of [personId] coded with another terminology release
  /// than [release], e.g. after an app update brought a new one.
  Future<List<ObservationRow>> readingsNotCodedWith(
    int personId,
    String release,
  ) async {
    final v = _db.vObservation;
    final ids =
        await (_db.selectOnly(v)
              ..addColumns([v.id])
              ..where(
                v.personId.equals(personId) &
                    v.terminologyRelease.equals(release).not(),
              ))
            .map((row) => row.read(v.id)!)
            .get();
    return (_db.select(_db.observation)..where((o) => o.id.isIn(ids))).get();
  }

  /// Current readings of a report, in the order they were read.
  Stream<List<VObservationData>> watchReportReadings(int reportId) =>
      (_db.select(_db.vObservation)
            ..where((o) => o.reportId.equals(reportId))
            ..orderBy([
              (o) => OrderingTerm.asc(o.pageIx),
              (o) => OrderingTerm.asc(o.rowIx),
              (o) => OrderingTerm.asc(o.id),
            ]))
          .watch();
}
