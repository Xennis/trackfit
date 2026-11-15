import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/application/backup.dart';
import 'package:trackfit_db/trackfit_db.dart';

import '../helpers.dart';

void main() {
  test('names backups by day', () {
    expect(backupFileName(DateTime(2026, 11, 5)), 'trackfit-2026-11-05.sqlite');
  });

  test('returns a copy of the database as SQLite bytes', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await PersonRepository(
      db,
    ).ensureDefaultPerson(defaultTz: 'UTC', now: DateTime.utc(2026));

    final bytes = await backupBytes(db, Directory.systemTemp);

    expect(String.fromCharCodes(bytes.take(15)), 'SQLite format 3');
  });
}
