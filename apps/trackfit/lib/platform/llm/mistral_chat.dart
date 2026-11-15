import 'dart:convert';

import 'package:http/http.dart' as http;

/// A language model call failed; [message] is safe to show and to log.
class LlmException implements Exception {
  const LlmException(this.message, {this.retryable = true});

  final String message;
  final bool retryable;

  @override
  String toString() => 'LlmException: $message';
}

/// Chat completions of Mistral with an answer that follows a JSON schema.
class MistralChat {
  MistralChat({
    required String apiKey,
    http.Client? client,
    this.model = 'mistral-medium-latest',
    Uri? endpoint,
  }) : _apiKey = apiKey,
       _client = client ?? http.Client(),
       _endpoint =
           endpoint ?? Uri.parse('https://api.mistral.ai/v1/chat/completions');

  final String _apiKey;
  final http.Client _client;
  final Uri _endpoint;
  final String model;

  /// Asks the model and returns its answer, a JSON document following
  /// [schema].
  Future<String> completeJson({
    required String system,
    required String user,
    required String schemaName,
    required Map<String, Object?> schema,
  }) async {
    final body = jsonEncode({
      'model': model,
      'temperature': 0,
      'messages': [
        {'role': 'system', 'content': system},
        {'role': 'user', 'content': user},
      ],
      'response_format': {
        'type': 'json_schema',
        'json_schema': {'name': schemaName, 'schema': schema, 'strict': true},
      },
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
      throw LlmException('network error (${error.runtimeType})');
    }
    if (response.statusCode != 200) {
      throw LlmException(
        'Mistral answered ${response.statusCode}',
        retryable: response.statusCode == 429 || response.statusCode >= 500,
      );
    }
    return parseContent(utf8.decode(response.bodyBytes));
  }

  /// The text of the first choice of a chat completion.
  static String parseContent(String json) {
    try {
      final decoded = jsonDecode(json) as Map<String, Object?>;
      final choices = decoded['choices']! as List<Object?>;
      final message =
          (choices.first! as Map<String, Object?>)['message']!
              as Map<String, Object?>;
      return message['content']! as String;
    } on Object {
      throw const LlmException('malformed response', retryable: false);
    }
  }
}
