import 'dart:typed_data';

/// A document to recognize: a PDF or one image.
class OcrDocument {
  const OcrDocument({required this.bytes, required this.mimeType});

  final Uint8List bytes;
  final String mimeType;

  bool get isPdf => mimeType == 'application/pdf';
}

/// Recognized text of one page.
class OcrPage {
  const OcrPage({required this.index, required this.markdown});

  /// Page within the document, starting at 0.
  final int index;

  /// Text of the page as Markdown, tables included.
  final String markdown;
}

/// Recognition failed; [message] is safe to show and to log.
class OcrException implements Exception {
  const OcrException(this.message, {this.retryable = true});

  final String message;

  /// Trying again later may succeed, e.g. after a network error.
  final bool retryable;

  @override
  String toString() => 'OcrException: $message';
}

/// Turns a document into text, page by page.
abstract interface class Ocr {
  /// Stored with every page, e.g. `ocr:mistral:mistral-ocr-latest`.
  String get origin;

  Future<List<OcrPage>> read(OcrDocument document);
}
