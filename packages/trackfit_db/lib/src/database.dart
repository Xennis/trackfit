import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

import 'converters.dart';

part 'database.g.dart';

/// The user database of trackfit.
///
/// Tables, views and constraints are written in SQL in `src/schema/*.drift`.
/// Rows of observations are never updated in place: a correction is a new
/// row that points at the row it amends.
@DriftDatabase(include: {'schema/person.drift', 'schema/reports.drift', 'schema/pages.drift', 'schema/observations.drift', 'schema/coding.drift', 'schema/views.drift'})
class TrackfitDatabase extends _$TrackfitDatabase {
  TrackfitDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
