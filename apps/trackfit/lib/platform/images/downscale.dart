import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Longest edge of a photo sent for recognition.
const maxRecognitionEdge = 2000;

/// An image prepared for recognition.
class PreparedImage {
  const PreparedImage(this.bytes, this.mimeType);

  final Uint8List bytes;
  final String mimeType;
}

/// Shrinks a photo so its longest edge is at most [maxRecognitionEdge] and
/// encodes it as JPEG. The stored original is never changed.
///
/// Images that are small enough, or that cannot be decoded here (e.g. HEIC),
/// are returned unchanged.
Future<PreparedImage> downscaleForRecognition(
  Uint8List bytes,
  String mimeType,
) => compute(_downscale, (bytes, mimeType));

PreparedImage _downscale((Uint8List, String) input) {
  final (bytes, mimeType) = input;
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return PreparedImage(bytes, mimeType);
  final longest = decoded.width > decoded.height
      ? decoded.width
      : decoded.height;
  if (longest <= maxRecognitionEdge) return PreparedImage(bytes, mimeType);
  final oriented = img.bakeOrientation(decoded);
  final resized = oriented.width >= oriented.height
      ? img.copyResize(oriented, width: maxRecognitionEdge)
      : img.copyResize(oriented, height: maxRecognitionEdge);
  return PreparedImage(img.encodeJpg(resized, quality: 85), 'image/jpeg');
}
