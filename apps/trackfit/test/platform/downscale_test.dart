import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:trackfit/platform/images/downscale.dart';

void main() {
  test('shrinks a large photo to the maximum edge', () async {
    final large = Uint8List.fromList(
      img.encodePng(img.Image(width: 4000, height: 3000)),
    );

    final prepared = await downscaleForRecognition(large, 'image/png');

    final decoded = img.decodeImage(prepared.bytes)!;
    expect(prepared.mimeType, 'image/jpeg');
    expect(decoded.width, maxRecognitionEdge);
    expect(decoded.height, 1500);
  });

  test('keeps a small photo unchanged', () async {
    final small = Uint8List.fromList(
      img.encodePng(img.Image(width: 100, height: 50)),
    );

    final prepared = await downscaleForRecognition(small, 'image/png');

    expect(prepared.bytes, small);
    expect(prepared.mimeType, 'image/png');
  });

  test('keeps an image it cannot decode', () async {
    final unknown = Uint8List.fromList([1, 2, 3]);

    final prepared = await downscaleForRecognition(unknown, 'image/heic');

    expect(prepared.bytes, unknown);
  });
}
