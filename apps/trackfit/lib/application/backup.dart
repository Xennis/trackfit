import 'dart:io';
import 'dart:typed_data';

import 'package:trackfit_db/trackfit_db.dart';

/// File name of a backup made on [day], e.g. `trackfit-2026-11-15.sqlite`.
String backupFileName(DateTime day) =>
    'trackfit-${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}.sqlite';

/// A consistent copy of the database as bytes, made in [tempDirectory].
Future<Uint8List> backupBytes(
  TrackfitDatabase db,
  Directory tempDirectory,
) async {
  final dir = await tempDirectory.createTemp('backup');
  try {
    final path = '${dir.path}/backup.sqlite';
    await db.backupTo(path);
    return await File(path).readAsBytes();
  } finally {
    await dir.delete(recursive: true);
  }
}
