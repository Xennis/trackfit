import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// A file copied into the app directory.
class StoredFile {
  const StoredFile({
    required this.contentHash,
    required this.relativePath,
    required this.byteSize,
  });

  /// SHA-256 of the bytes, lowercase hex.
  final String contentHash;

  /// Path relative to the root of the [FileStore].
  final String relativePath;

  final int byteSize;
}

/// Stores imported files under their content hash.
///
/// The same bytes always end up at the same path, so storing a file twice
/// writes it only once and never overwrites a different file.
class FileStore {
  FileStore(this.root);

  /// Directory of the app data, e.g. the application support directory.
  final Directory root;

  static const _folder = 'files';

  /// SHA-256 of [bytes] as lowercase hex.
  static String hashOf(Uint8List bytes) => sha256.convert(bytes).toString();

  /// Writes [bytes] as `files/<hash>.<extension>` unless already present.
  Future<StoredFile> store(Uint8List bytes, {required String extension}) async {
    final hash = hashOf(bytes);
    final ext = extension.toLowerCase().replaceAll('.', '');
    final relativePath = ext.isEmpty ? '$_folder/$hash' : '$_folder/$hash.$ext';
    final file = resolve(relativePath);
    if (!await file.exists()) {
      await file.parent.create(recursive: true);
      // Write to a temporary file first so a crash never leaves a partial
      // file under the final name.
      final partial = File('${file.path}.part');
      await partial.writeAsBytes(bytes, flush: true);
      await partial.rename(file.path);
    }
    return StoredFile(
      contentHash: hash,
      relativePath: relativePath,
      byteSize: bytes.length,
    );
  }

  /// The file at [relativePath] below [root].
  File resolve(String relativePath) =>
      File('${root.path}${Platform.pathSeparator}$relativePath');

  /// Deletes the stored file, if it exists.
  Future<void> delete(String relativePath) async {
    final file = resolve(relativePath);
    if (await file.exists()) await file.delete();
  }
}
