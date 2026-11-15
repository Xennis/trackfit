import 'dart:io';

import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trackfit_db/trackfit_db.dart';

import 'fixtures.dart';
import 'test_database.dart';

void main() {
  test('writes a copy that opens with the same data', () async {
    final db = openTestDatabase();
    addTearDown(db.close);
    await insertPerson(db);
    final dir = await Directory.systemTemp.createTemp('backup_test');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/backup.sqlite';

    await db.backupTo(path);

    final copy = TrackfitDatabase(NativeDatabase(File(path)));
    addTearDown(copy.close);
    expect(await copy.select(copy.person).get(), hasLength(1));
  });
}
