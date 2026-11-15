import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:standardize/standardize.dart';
import 'package:standardize/terminology_sqlite.dart';

/// Path of the bundled terminology database.
const terminologyAsset = 'assets/terminology.sqlite';

/// Loads the terminology bundled with the app into memory.
///
/// SQLite cannot open an asset directly, so the database is copied into
/// [directory] first. It is small and only read once per start.
Future<Terminology> loadBundledTerminology(
  Directory directory, {
  AssetBundle? bundle,
}) async {
  final data = await (bundle ?? rootBundle).load(terminologyAsset);
  final file = File('${directory.path}/terminology.sqlite');
  final partial = File('${file.path}.part');
  await partial.writeAsBytes(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    flush: true,
  );
  await partial.rename(file.path);
  final db = sqlite3.open(file.path, mode: OpenMode.readOnly);
  try {
    return readTerminology(db);
  } finally {
    db.close();
  }
}
