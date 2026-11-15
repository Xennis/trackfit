import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trackfit/platform/llm/lab_report_extractor.dart';
import 'package:trackfit/platform/llm/mistral_chat.dart';

/// Shape of a Mistral chat completion, with a synthetic answer.
String _completion(String content) => jsonEncode({
  'id': 'cmpl-test',
  'object': 'chat.completion',
  'model': 'mistral-medium-latest',
  'choices': [
    {
      'index': 0,
      'message': {'role': 'assistant', 'content': content},
      'finish_reason': 'stop',
    },
  ],
  'usage': {'prompt_tokens': 100, 'completion_tokens': 50},
});

const _answer = '''
{"report_date": "2025-03-14", "lab_name": "Labor Beispiel", "results": [
  {"name": "Eisen", "value": "52", "unit": "µg/dl", "reference": "60 - 170",
   "flag": "L", "specimen": "Serum", "panel": "Eisenstoffwechsel", "page": 1},
  {"name": "Hämoglobin", "value": "12,9", "unit": "g/dl", "reference": "12 - 16",
   "flag": "", "specimen": "", "panel": "Blutbild", "page": 2}
]}
''';

void main() {
  test('sends pages with markers and the schema, reads the answer', () async {
    late Map<String, Object?> sent;
    final extractor = LabReportExtractor(
      MistralChat(
        apiKey: 'test-key',
        client: MockClient((request) async {
          sent = jsonDecode(request.body) as Map<String, Object?>;
          return http.Response.bytes(utf8.encode(_completion(_answer)), 200);
        }),
      ),
    );

    final result = await extractor.extract(const [
      ExtractorPage(number: 1, markdown: '| Eisen | 52 |'),
      ExtractorPage(number: 2, markdown: '| Hämoglobin | 12,9 |'),
    ]);

    final messages = sent['messages']! as List<Object?>;
    final user = (messages.last! as Map<String, Object?>)['content']! as String;
    expect(user, contains('--- page 1 ---\n| Eisen | 52 |'));
    expect(user, contains('--- page 2 ---'));
    final format = sent['response_format']! as Map<String, Object?>;
    expect(format['type'], 'json_schema');
    expect(sent['temperature'], 0);

    expect(result.reportDate, '2025-03-14');
    expect(result.results, hasLength(2));
    expect(result.results.first.unit, 'µg/dl');
    expect(result.results.last.value, '12,9');
    expect(result.results.last.page, 2);
    expect(extractor.id, 'llm:mistral/mistral-medium-latest@lab-report-v2');
  });

  test('an answer that is not json is not retried', () {
    expect(
      () => LabReportExtractor.parseAnswer('Sorry, I cannot help.'),
      throwsA(isA<LlmException>().having((e) => e.retryable, 'retry', false)),
    );
  });

  test('a rate limit can be retried', () async {
    final chat = MistralChat(
      apiKey: 'k',
      client: MockClient((_) async => http.Response('{}', 429)),
    );

    await expectLater(
      chat.completeJson(system: 's', user: 'u', schemaName: 'x', schema: {}),
      throwsA(isA<LlmException>().having((e) => e.retryable, 'retry', true)),
    );
  });
}
