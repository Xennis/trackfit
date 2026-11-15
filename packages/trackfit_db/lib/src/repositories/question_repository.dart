import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../database.dart';

/// Readings with the same printed name and unit that wait for an answer.
///
/// One question per name, not per reading: answering it once codes every
/// reading with that name.
class OpenQuestion {
  const OpenQuestion({required this.readings});

  /// Newest first.
  final List<VObservationData> readings;

  VObservationData get example => readings.first;
  String get nameKey => example.nameKey;
  String get unitUcum => example.unitUcum;
  String get reason => example.codingReason;

  /// Number of reports the name appears in.
  int get reportCount => readings.map((r) => r.reportId).toSet().length;
}

/// Open questions and the answers a person gave.
class QuestionRepository {
  QuestionRepository(this._db);

  final TrackfitDatabase _db;

  /// Scope of the answers of a person.
  static String personScope(int personId) => 'person:$personId';

  /// Readings that need input, grouped by name and unit.
  Stream<List<OpenQuestion>> watchOpen(int personId) =>
      (_db.select(_db.vObservation)
            ..where(
              (o) =>
                  o.personId.equals(personId) &
                  o.outcome.equalsValue(CodingOutcome.needsInput),
            )
            ..orderBy([
              (o) => OrderingTerm.desc(o.localDate),
              (o) => OrderingTerm.desc(o.id),
            ]))
          .watch()
          .map((rows) {
            final groups = <(String, String), List<VObservationData>>{};
            for (final row in rows) {
              groups
                  .putIfAbsent((row.nameKey, row.unitUcum), () => [])
                  .add(row);
            }
            return [
              for (final readings in groups.values)
                OpenQuestion(readings: readings),
            ];
          });

  /// Answers of a person, the person's own first.
  Future<List<CodingAliasRow>> aliases(int personId) =>
      (_db.select(_db.codingAlias)
            ..where(
              (a) =>
                  a.scope.equals(personScope(personId)) |
                  a.scope.equals('global'),
            )
            ..orderBy([(a) => OrderingTerm.desc(a.scope)]))
          .get();

  /// Stores the answer that [nameKey] (with [unitUcum], '' for any unit) is
  /// [code], or no standard test when [code] is null.
  Future<int> confirm({
    required int personId,
    required String nameKey,
    required DateTime now,
    String unitUcum = '',
    String? codeSystem,
    String? code,
  }) {
    final row = CodingAliasCompanion.insert(
      scope: personScope(personId),
      nameKey: nameKey,
      unitUcum: Value(unitUcum),
      codeSystem: Value(code == null ? null : codeSystem),
      code: Value(code),
      confirmedAt: now,
    );
    return _db
        .into(_db.codingAlias)
        .insert(
          row,
          onConflict: DoUpdate(
            (_) => row,
            target: [
              _db.codingAlias.scope,
              _db.codingAlias.nameKey,
              _db.codingAlias.unitUcum,
            ],
          ),
        );
  }

  /// Current readings with [nameKey] that wait for an answer.
  Future<List<ObservationRow>> openReadingsNamed(
    int personId,
    String nameKey,
  ) async {
    final ids =
        await (_db.selectOnly(_db.vObservation)
              ..addColumns([_db.vObservation.id])
              ..where(
                _db.vObservation.personId.equals(personId) &
                    _db.vObservation.nameKey.equals(nameKey) &
                    _db.vObservation.outcome.equalsValue(
                      CodingOutcome.needsInput,
                    ),
              ))
            .map((row) => row.read(_db.vObservation.id)!)
            .get();
    return (_db.select(_db.observation)..where((o) => o.id.isIn(ids))).get();
  }
}
