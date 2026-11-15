import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackfit/data/file_store.dart';

void main() {
  late Directory root;
  late FileStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('file_store_test');
    store = FileStore(root);
  });
  tearDown(() => root.delete(recursive: true));

  final bytes = Uint8List.fromList([1, 2, 3]);

  test('stores a file under its hash', () async {
    final stored = await store.store(bytes, extension: '.PDF');

    expect(stored.contentHash, hasLength(64));
    expect(stored.relativePath, 'files/${stored.contentHash}.pdf');
    expect(await store.resolve(stored.relativePath).readAsBytes(), bytes);
    expect(stored.byteSize, 3);
  });

  test('storing the same bytes twice gives the same file', () async {
    final first = await store.store(bytes, extension: 'pdf');
    final second = await store.store(bytes, extension: 'pdf');

    expect(second.relativePath, first.relativePath);
    expect(root.listSync(recursive: true).whereType<File>(), hasLength(1));
  });

  test('deletes a stored file', () async {
    final stored = await store.store(bytes, extension: 'jpg');

    await store.delete(stored.relativePath);

    expect(await store.resolve(stored.relativePath).exists(), isFalse);
  });
}
