import 'package:test/test.dart';

import 'test_database.dart';

void main() {
  test('opens an empty database', () async {
    final db = openTestDatabase();
    addTearDown(db.close);

    final result = await db.customSelect('SELECT sqlite_version() AS v').get();

    expect(result.single.read<String>('v'), isNotEmpty);
  });
}
