import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/data/database_providers.dart';
import 'package:trackfit_db/trackfit_db.dart';

void main() {
  test('creates the default person with the device time zone', () async {
    final db = TrackfitDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        deviceTimeZoneProvider.overrideWith((ref) => 'Europe/Berlin'),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    final id = await container.read(currentPersonIdProvider.future);

    final person = await db.select(db.person).getSingle();
    expect(person.id, id);
    expect(person.defaultTz, 'Europe/Berlin');
  });
}
