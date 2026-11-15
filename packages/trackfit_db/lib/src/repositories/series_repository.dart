import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

import '../database.dart';

/// One measured quantity over time, e.g. iron across all reports.
///
/// Readings of one analyte belong together even when printed in different
/// units (mass or substance); uncoded readings form a series per printed
/// name and unit.
class SeriesSummary {
  const SeriesSummary({
    required this.key,
    required this.latest,
    required this.readingCount,
    required this.history,
  });

  /// `group:<analyte>` or the series id of an uncoded reading.
  final String key;

  /// The newest reading.
  final VObservationData latest;
  final int readingCount;

  /// All readings, oldest first.
  final List<VObservationData> history;

  bool get isCoded => latest.outcome == CodingOutcome.coded;
}

/// Key of the series a reading belongs to.
String seriesKeyOf(VObservationData reading) {
  final group = reading.groupId;
  return group != null && reading.outcome == CodingOutcome.coded
      ? 'group:$group'
      : reading.seriesId;
}

/// Readings grouped into series for lists and charts.
class SeriesRepository {
  SeriesRepository(this._db);

  final TrackfitDatabase _db;

  Selectable<VObservationData> _measurements(int personId) =>
      _db.select(_db.vObservation)
        ..where(
          (o) =>
              o.personId.equals(personId) &
              o.kind.equalsValue(ObservationKind.measurement),
        )
        ..orderBy([
          (o) => OrderingTerm.asc(o.localDate),
          (o) => OrderingTerm.asc(o.id),
        ]);

  /// All series of a person, updated on every change.
  Stream<List<SeriesSummary>> watchSeries(int personId) =>
      _measurements(personId).watch().map(_group);

  /// One series, oldest reading first; null when it has no readings.
  Stream<SeriesSummary?> watchOne(int personId, String key) => watchSeries(
    personId,
  ).map((all) => all.where((s) => s.key == key).firstOrNull);

  static List<SeriesSummary> _group(List<VObservationData> readings) {
    final byKey = <String, List<VObservationData>>{};
    for (final reading in readings) {
      byKey.putIfAbsent(seriesKeyOf(reading), () => []).add(reading);
    }
    return [
      for (final MapEntry(key: key, value: history) in byKey.entries)
        SeriesSummary(
          key: key,
          latest: history.last,
          readingCount: history.length,
          history: history,
        ),
    ];
  }
}
