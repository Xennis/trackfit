import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'test_database.dart';

void main() {
  late TrackfitDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  test('stores a person with enum and time converted', () async {
    final createdAt = DateTime.utc(2026, 11, 15, 12);
    final id = await db
        .into(db.person)
        .insert(
          PersonCompanion.insert(
            displayName: 'Me',
            defaultTz: 'Europe/Berlin',
            createdAt: createdAt,
            sex: const Value(Sex.female),
          ),
        );

    final row = await (db.select(
      db.person,
    )..where((p) => p.id.equals(id))).getSingle();
    expect(row.sex, Sex.female);
    expect(row.createdAt, createdAt);
    expect(row.birthDate, isNull);
  });

  test('rejects a malformed birth date', () async {
    final insert = db
        .into(db.person)
        .insert(
          PersonCompanion.insert(
            displayName: 'Me',
            defaultTz: 'Europe/Berlin',
            createdAt: DateTime.utc(2026),
            birthDate: const Value('15.11.1990'),
          ),
        );

    await expectLater(insert, throwsA(isA<Exception>()));
  });
}
