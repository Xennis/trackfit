import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';
import 'package:trackfit_core/trackfit_core.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;
  late ObservationRepository observations;
  late SeriesRepository series;
  late int personId;
  var row = 0;

  setUp(() async {
    db = openTestDatabase();
    observations = ObservationRepository(db);
    series = SeriesRepository(db);
    personId = await insertPerson(db);
  });
  tearDown(() => db.close());

  Future<void> reading({
    required String date,
    required double value,
    String name = 'Eisen',
    String unit = 'ug/dL',
    String? code = '2498-4',
    String group = 'iron',
  }) => observations.insert(
    NewObservation(
      labObservation(personId: personId, name: name, valueNum: value).copyWith(
        localDate: Value(date),
        observedStart: Value(DateTime.parse('${date}T00:00:00Z')),
        observedEnd: Value(
          DateTime.parse('${date}T00:00:00Z').add(const Duration(days: 1)),
        ),
        unitUcum: Value(unit),
        sourceRecordId: Value('row:${row++}'),
      ),
      CodingInput(
        terminologyRelease: testRelease,
        outcome: code == null ? CodingOutcome.needsInput : CodingOutcome.coded,
        reason: code == null ? 'engine:no-match' : '',
        rule: 'engine:lexical',
        seriesId: code == null
            ? 'local:${name.toLowerCase()}|$unit'
            : 'loinc:$code',
        codeSystem: code == null ? null : 'http://loinc.org',
        code: code,
        groupId: code == null ? null : group,
      ),
    ),
    now: testNow,
  );

  test('groups readings of one analyte across units', () async {
    await reading(date: '2024-11-02', value: 55);
    await reading(
      date: '2025-03-14',
      value: 9.3,
      unit: 'umol/L',
      code: '14798-3',
    );
    await reading(date: '2023-01-10', value: 98);

    final all = await series.watchSeries(personId).first;

    final iron = all.single;
    expect(iron.key, 'group:iron');
    expect(iron.readingCount, 3);
    expect(iron.history.map((r) => r.localDate), [
      '2023-01-10',
      '2024-11-02',
      '2025-03-14',
    ]);
    expect(iron.latest.valueNum, 9.3);
  });

  test('keeps uncoded names apart from coded ones', () async {
    await reading(date: '2025-03-14', value: 52);
    await reading(
      date: '2025-03-14',
      value: 14,
      name: 'Fe-Sätt.',
      unit: '%',
      code: null,
    );

    final keys = (await series.watchSeries(personId).first).map((s) => s.key);

    expect(keys, containsAll(['group:iron', 'local:fe-sätt.|%']));
  });

  test('watches one series', () async {
    await reading(date: '2025-03-14', value: 52);

    final one = await series.watchOne(personId, 'group:iron').first;

    expect(one!.readingCount, 1);
    expect(await series.watchOne(personId, 'group:none').first, isNull);
  });
}
