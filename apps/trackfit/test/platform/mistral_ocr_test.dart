import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trackfit/platform/ocr/mistral_ocr.dart';
import 'package:trackfit/platform/ocr/ocr.dart';

/// Shape of a Mistral OCR answer, with synthetic content.
const _response = '''
{
  "pages": [
    {"index": 1, "markdown": "## Blutbild\\n\\n[tbl-1.html](tbl-1.html)",
     "tables": [{"id": "tbl-1.html", "content": "| Test | Wert |\\n|---|---|\\n| Hb | 12,9 |"}],
     "images": [], "dimensions": {"dpi": 200, "height": 2200, "width": 1700}},
    {"index": 0, "markdown": "# Labor Beispiel\\n\\n| Test | Wert |\\n|---|---|\\n| Eisen | 52 |",
     "images": [], "dimensions": {"dpi": 200, "height": 2200, "width": 1700}}
  ],
  "model": "mistral-ocr-2512",
  "usage_info": {"pages_processed": 2, "doc_size_bytes": 1024}
}
''';

void main() {
  final pdf = OcrDocument(
    bytes: Uint8List.fromList(utf8.encode('%PDF-1.7')),
    mimeType: 'application/pdf',
  );

  test('sends the document as data url and reads pages in order', () async {
    late http.Request sent;
    final ocr = MistralOcr(
      apiKey: 'test-key',
      client: MockClient((request) async {
        sent = request;
        return http.Response.bytes(utf8.encode(_response), 200);
      }),
    );

    final pages = await ocr.read(pdf);

    expect(sent.url.toString(), 'https://api.mistral.ai/v1/ocr');
    expect(sent.headers['Authorization'], 'Bearer test-key');
    final body = jsonDecode(sent.body) as Map<String, Object?>;
    expect(body['model'], 'mistral-ocr-latest');
    final document = body['document']! as Map<String, Object?>;
    expect(document['type'], 'document_url');
    expect(
      document['document_url'],
      startsWith('data:application/pdf;base64,'),
    );
    expect(pages.map((p) => p.index), [0, 1]);
    expect(pages.first.markdown, contains('| Eisen | 52 |'));
    expect(pages.last.markdown, contains('| Hb | 12,9 |'));
    expect(pages.last.markdown, isNot(contains('tbl-1.html')));
  });

  test('sends an image as image url', () async {
    late http.Request sent;
    final ocr = MistralOcr(
      apiKey: 'k',
      client: MockClient((request) async {
        sent = request;
        return http.Response('{"pages": []}', 200);
      }),
    );

    await ocr.read(OcrDocument(bytes: Uint8List(3), mimeType: 'image/jpeg'));

    final document =
        (jsonDecode(sent.body) as Map<String, Object?>)['document']!
            as Map<String, Object?>;
    expect(document['type'], 'image_url');
    expect(document['image_url'], startsWith('data:image/jpeg;base64,'));
  });

  test('a rejected key is not retried', () async {
    final ocr = MistralOcr(
      apiKey: 'wrong',
      client: MockClient((_) async => http.Response('{}', 401)),
    );

    await expectLater(
      ocr.read(pdf),
      throwsA(
        isA<OcrException>().having((e) => e.retryable, 'retryable', false),
      ),
    );
  });

  test('a server error can be retried', () async {
    final ocr = MistralOcr(
      apiKey: 'k',
      client: MockClient((_) async => http.Response('{}', 503)),
    );

    await expectLater(
      ocr.read(pdf),
      throwsA(
        isA<OcrException>().having((e) => e.retryable, 'retryable', true),
      ),
    );
  });

  test('rejects a response without pages', () {
    expect(
      () => MistralOcr.parseResponse('{"error": "x"}'),
      throwsA(isA<OcrException>()),
    );
  });
}
