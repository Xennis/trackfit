import 'package:drift/drift.dart';
import 'package:test/test.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  late TrackfitDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  final rejected = throwsA(isA<Exception>());

  CodingAliasCompanion alias({
    String scope = 'person:1',
    String? code = '2276-4',
  }) => CodingAliasCompanion.insert(
    scope: scope,
    nameKey: 'ferr.',
    codeSystem: Value(code == null ? null : 'http://loinc.org'),
    code: Value(code),
    confirmedAt: testNow,
  );

  test('stores a concept once per release', () async {
    final concept = ConceptCompanion.insert(
      terminologyRelease: testRelease,
      codeSystem: 'http://loinc.org',
      code: '2498-4',
      display: 'Iron [Mass/volume] in Serum or Plasma',
      displayDe: const Value('Eisen'),
    );
    await db.into(db.concept).insert(concept);

    await db.into(db.concept).insertOnConflictUpdate(concept);

    expect(await db.select(db.concept).get(), hasLength(1));
  });

  test('stores a confirmed alias and a "not standard" answer', () async {
    await db.into(db.codingAlias).insert(alias());
    await db.into(db.codingAlias).insert(alias(scope: 'global', code: null));

    expect(await db.select(db.codingAlias).get(), hasLength(2));
  });

  test('an alias scope is global or a person', () async {
    await expectLater(
      db.into(db.codingAlias).insert(alias(scope: 'everyone')),
      rejected,
    );
  });

  test('one alias per scope, name and unit', () async {
    await db.into(db.codingAlias).insert(alias());

    await expectLater(db.into(db.codingAlias).insert(alias()), rejected);
  });
}
