import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:trackfit_db/trackfit_db.dart';

/// A fresh in-memory database.
TrackfitDatabase memoryDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return TrackfitDatabase(NativeDatabase.memory());
}

/// Bytes that are detected as a PDF; [tag] makes them unique.
Uint8List fakePdf([String tag = '']) =>
    Uint8List.fromList(utf8.encode('%PDF-1.7\n% $tag\n%%EOF'));

/// Bytes that are detected as a JPEG; [tag] makes them unique.
Uint8List fakeJpeg([String tag = '']) => Uint8List.fromList([
  0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, //
  ...utf8.encode(tag),
]);
