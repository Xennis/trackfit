import 'package:drift/drift.dart';

import '../database.dart';

/// Access to the people whose data is stored.
class PersonRepository {
  PersonRepository(this._db);

  final TrackfitDatabase _db;

  /// Returns the id of the first person, creating it on first start.
  ///
  /// [defaultTz] is the IANA zone of the device, used for readings that do
  /// not carry a zone of their own.
  Future<int> ensureDefaultPerson({
    required String defaultTz,
    required DateTime now,
  }) => _db.transaction(() async {
    final existing =
        await (_db.select(_db.person)
              ..orderBy([(p) => OrderingTerm.asc(p.id)])
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing.id;
    return _db
        .into(_db.person)
        .insert(
          PersonCompanion.insert(
            displayName: '',
            defaultTz: defaultTz,
            createdAt: now,
          ),
        );
  });
}
