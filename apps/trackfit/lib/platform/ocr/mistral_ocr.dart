import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ocr.dart';

/// Recognition with the Mistral OCR API (OCR 4).
///
/// Sends the document as a base64 data URL and reads the Markdown of every
/// page. Without `table_format`, tables come inline in the Markdown. The
/// model is pinned instead of using the `-latest` alias, so results only
/// change when the model is changed here on purpose.
class MistralOcr implements Ocr {
  MistralOcr({
    required String apiKey,
    http.Client? client,
    this.model = defaultModel,
    Uri? endpoint,
  }) : _apiKey = apiKey,
       _client = client ?? http.Client(),
       _endpoint = endpoint ?? Uri.parse('https://api.mistral.ai/v1/ocr');

  final String _apiKey;
  final http.Client _client;
  final Uri _endpoint;
  final String model;

  static const defaultModel = 'mistral-ocr-4-1';

  @override
  String get origin => 'ocr:mistral:$model';

  @override
  Future<List<OcrPage>> read(OcrDocument document) async {
    final dataUrl =
        'data:${document.mimeType};base64,${base64Encode(document.bytes)}';
    final body = jsonEncode({
      'model': model,
      'document': document.isPdf
          ? {'type': 'document_url', 'document_url': dataUrl}
          : {'type': 'image_url', 'image_url': dataUrl},
      'include_image_base64': false,
    });

    final http.Response response;
    try {
      response = await _client.post(
        _endpoint,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );
    } on Object catch (error) {
      throw OcrException('network error (${error.runtimeType})');
    }

    if (response.statusCode != 200) {
      throw OcrException(
        'Mistral OCR answered ${response.statusCode}',
        retryable: response.statusCode == 429 || response.statusCode >= 500,
      );
    }
    return parseResponse(utf8.decode(response.bodyBytes));
  }

  /// Reads the pages from an OCR response.
  static List<OcrPage> parseResponse(String json) {
    final Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      throw const OcrException('malformed response', retryable: false);
    }
    if (decoded is! Map<String, Object?> || decoded['pages'] is! List) {
      throw const OcrException('response without pages', retryable: false);
    }
    final pages = <OcrPage>[];
    for (final (position, page) in (decoded['pages']! as List).indexed) {
      if (page is! Map<String, Object?>) continue;
      final index = page['index'];
      final markdown = page['markdown'];
      pages.add(
        OcrPage(
          index: index is int ? index : position,
          markdown: _inlineTables(
            markdown is String ? markdown : '',
            page['tables'],
          ),
        ),
      );
    }
    pages.sort((a, b) => a.index.compareTo(b.index));
    return pages;
  }

  /// Replaces table links such as `[tbl-0.html](tbl-0.html)` with the table
  /// content, in case tables are returned apart from the Markdown.
  static String _inlineTables(String markdown, Object? tables) {
    if (tables is! List) return markdown;
    var result = markdown;
    for (final table in tables) {
      if (table is! Map<String, Object?>) continue;
      final id = table['id'];
      final content = table['content'] ?? table['markdown'] ?? table['html'];
      if (id is! String || content is! String) continue;
      result = result.replaceAll('[$id]($id)', content);
    }
    return result;
  }
}
