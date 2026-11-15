import 'package:test/test.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  test('creates the default person once', () async {
    final repository = PersonRepository(db);

    final first = await repository.ensureDefaultPerson(
      defaultTz: 'Europe/Berlin',
      now: testNow,
    );
    final second = await repository.ensureDefaultPerson(
      defaultTz: 'UTC',
      now: testNow,
    );

    expect(second, first);
    final person = await db.select(db.person).getSingle();
    expect(person.defaultTz, 'Europe/Berlin');
  });
}
