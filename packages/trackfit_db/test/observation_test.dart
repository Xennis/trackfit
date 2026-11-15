import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late int personId;

  setUp(() async {
    db = openTestDatabase();
    personId = await insertPerson(db);
  });
  tearDown(() => db.close());

  Future<int> insert(ObservationCompanion row) =>
      db.into(db.observation).insert(row);

  final rejected = throwsA(isA<Exception>());

  test('stores a lab value', () async {
    final id = await insert(labObservation(personId: personId));

    final row = await (db.select(
      db.observation,
    )..where((o) => o.id.equals(id))).getSingle();
    expect(row.valueKind, ValueKind.quantity);
    expect(row.valueNum, 52);
    expect(row.grain, Grain.day);
    expect(row.comparator, Comparator.none);
    expect(row.status, ObservationStatus.finalStatus);
  });

  test('a quantity needs a number', () async {
    await expectLater(
      insert(labObservation(personId: personId, valueNum: null)),
      rejected,
    );
  });

  test('an absent value needs a reason', () async {
    await expectLater(
      insert(
        labObservation(
          personId: personId,
          valueKind: ValueKind.absent,
          valueNum: null,
        ),
      ),
      rejected,
    );
  });

  test('an instant starts and ends at the same time', () async {
    await expectLater(
      insert(
        labObservation(
          personId: personId,
        ).copyWith(grain: const Value(Grain.instant)),
      ),
      rejected,
    );
  });

  test('a reading is stored only once', () async {
    await insert(labObservation(personId: personId));

    await expectLater(insert(labObservation(personId: personId)), rejected);
  });

  test('a correction is a new row that amends the old one', () async {
    final original = await insert(labObservation(personId: personId));

    final correction = await insert(
      labObservation(personId: personId, valueNum: 25, amends: original),
    );

    expect(correction, isNot(original));
  });

  test('entered in error needs the row it retracts', () async {
    await expectLater(
      insert(
        labObservation(
          personId: personId,
          status: ObservationStatus.enteredInError,
        ),
      ),
      rejected,
    );
  });
}
