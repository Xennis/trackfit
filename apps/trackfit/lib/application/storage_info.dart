import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Where the data lives and how much space it takes.
class StorageInfo {
  const StorageInfo({required this.directory, required this.bytes});

  final String directory;
  final int bytes;
}

/// Size of everything in [directory], files of all reports included.
Future<StorageInfo> measureStorage(Directory directory) async {
  var bytes = 0;
  if (await directory.exists()) {
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) bytes += await entity.length();
    }
  }
  return StorageInfo(directory: directory.path, bytes: bytes);
}

final storageInfoProvider = FutureProvider.autoDispose<StorageInfo>(
  (ref) async => measureStorage(await getApplicationSupportDirectory()),
);

/// Bytes as a short text such as `1.4 MB`.
String formatBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(unit == 0 ? 0 : 1)} ${units[unit]}';
}
