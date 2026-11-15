import 'package:drift/drift.dart';

part 'database.g.dart';

/// The user database of trackfit.
///
/// Tables, views and constraints are written in SQL in `src/schema/*.drift`.
/// Rows of observations are never updated in place: a correction is a new
/// row that points at the row it amends.
@DriftDatabase(include: {})
class TrackfitDatabase extends _$TrackfitDatabase {
  TrackfitDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
