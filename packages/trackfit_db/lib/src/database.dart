import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

import 'converters.dart';

part 'database.g.dart';

/// The user database of trackfit.
///
/// Tables, views and constraints are written in SQL in `src/schema/*.drift`.
/// Rows of observations are never updated in place: a correction is a new
/// row that points at the row it amends.
@DriftDatabase(
  include: {
    'schema/person.drift',
    'schema/reports.drift',
    'schema/pages.drift',
    'schema/observations.drift',
    'schema/coding.drift',
    'schema/views.drift',
    'schema/report_queries.drift',
  },
)
class TrackfitDatabase extends _$TrackfitDatabase {
  TrackfitDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  /// Writes a consistent copy of the database to [path], which must not
  /// exist yet. Safe while the app keeps running.
  Future<void> backupTo(String path) =>
      customStatement('VACUUM INTO ?', [path]);

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // SQLite does not enforce foreign keys unless asked to, per connection.
      await customStatement('PRAGMA foreign_keys = ON');
      // Lets the UI read while an import writes. In-memory databases ignore it.
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
}
